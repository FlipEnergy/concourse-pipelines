# concourse-pipelines — agent context

Concourse CI pipeline definitions for a personal homelab (owner: FlipEnergy / Dennis Zhang).
Target Concourse: `https://concourse.computersbarely.work`, fly target `homelab`.
Concourse itself is deployed from the `k8s-homelab` repo.

## Ground rules for agents (read first)

**Secrets**
- Never commit secrets: credentials, tokens, private keys, kubeconfigs, `.tfvars`, decrypted sops output, or anything that looks like one. If a change would add one, stop and ask.
- Before committing, review the staged diff (`git diff --cached`) for secret-looking values and for files that should be ignored. Never use `git add -f` on an ignored file, and never weaken `.gitignore` to make a file committable.
- Never put secret values into tracked files, commit messages, PR descriptions, logs, or chat output — not even partially or "redacted by hand".
- Encrypted files (`*.enc.yml`, sops `*-secrets.yaml`) may be read as-is, but only change them with the proper tool (`sops`); never decrypt them unless asked.

**Git-ignored files**
- Do not read, print, search, or open git-ignored files directly unless the user specifically asks for that file. They are often local secrets or decrypted copies (e.g. `*.dec.yml`, `*.yaml.dec`, `terraform.tfvars`, `backend.tf`, `*.key`, `*.pem`).
- Exclude them from searches (prefer `git ls-files` / `git grep`, or tools that respect `.gitignore`). Check with `git check-ignore -v <path>` if unsure.
- Generated build output that is ignored (e.g. `public/`, `.terraform/`) may be listed, but still don't read its contents unless needed for the task and asked.

## Layout

| Path | Purpose |
|---|---|
| `common/reusable-blocks.yml` | YAML anchors (creds, resource types, Discord webhooks, task images, notification hooks). **Prepended to every pipeline.** |
| `common/tasks/get-bw-secret.yml` | Reusable task: pulls Bitwarden items (`BW_ITEMS="<item_id>:<output_file> ..."`) into `secrets/` using the `flipenergy/bitwarden-cli` image. |
| `common/scripts/` | `get-bw-item.sh` (used by the task above), `import-secret-key.sh` (imports GPG key, decrypts kubeconfig with sops), `setup-git-config.sh`. |
| `common/vars/secrets.enc.yml` | sops/PGP-encrypted pipeline vars (`((var))` values). |
| `common/misc/kube-config.enc.yml` | sops-encrypted kubeconfig used by deploy tasks. |
| `personal-websites/` | `personal-sites` pipeline: Hugo build → OCI image → Docker Hub → `helm upgrade` with bjw-s app-template. |
| `k8s-homelab/` | `deploy-k8s-homelab` (Helmsman `-apply` on `main`), `k8s-homelab-branch-tracker` (sets one `k8s-homelab-diff` instanced pipeline per non-main branch running `-show-diff`). `common.yml` holds shared anchors; `pipeline-templates/` is compiled inside CI. The helmsman image (`helmsman-image-resource` in `common/reusable-blocks.yml`) bundles helm and its plugins; keep its tag in sync with helmsman in `k8s-homelab/mise.toml`. |
| `tf-pipeline/` | `terraform` pipeline: weekly (Friday) + on-push `tofu plan` (OpenTofu, `ghcr.io/opentofu/opentofu` image) of `tf-playground/homelab`. Keep the image tag in sync with `tf-playground/homelab/mise.toml`. |
| `image-build/` | `images-build` pipeline: builds `container-images` repo images when upstream releases. |
| `notification-jobs/` | `misc-notifications`: weekday Discord reminders (America/Vancouver). |
| `clone-repos/` | `clone-github-repos`: every 15m, `git clone --mirror` GitHub repos and force-push to `codeberg.org/FlipEnergy/<repo>`. |

## How pipelines are assembled

Pipeline files are **not valid standalone YAML** — they reference anchors (`*docker-creds`, `*job-notifications`, etc.) defined in other files. The Makefile concatenates them and pipes to fly:

```
cat common/reusable-blocks.yml [<dir>/common.yml] <dir>/<pipeline>.yml | fly -t homelab set-pipeline -n -p <name> -c - -l common/vars/secrets.dec.yml
```

Consequences:
- An anchor must be defined in a file that comes *earlier* in the `cat` order.
- Top-level keys like `common-templates:`, `template:`, `k8s-homelab-templates:` only exist to hold anchors. Because files are concatenated, each file must use a top-level holder key not used by any other file in the same `cat` (duplicate keys collide).
- To validate locally: `cat <files> | fly validate-pipeline -c /dev/stdin` (or `-c` to a temp file).

## Commands

- `make login` / `make sync` — fly login / update fly.
- `make set-all-pipelines` — decrypt secrets, set every pipeline, delete decrypted file.
- `make <pipeline-name>` — set one pipeline (needs `make decrypt-secrets` first, `make clean-decrypted-files` after).
- `make save-kube-config` — re-encrypt current kubeconfig into `common/misc/kube-config.enc.yml`.

Setting pipelines changes the live CI server — ask before running any `fly set-pipeline` / `make <pipeline>`.

## Secrets

- `common/vars/secrets.dec.yml` is the **decrypted** secrets file (gitignored, may exist locally). Never read it, print it, or commit it. Remove it with `make clean-decrypted-files` when done.
- Editing secrets: `sops common/vars/secrets.enc.yml` (requires the owner's PGP key). Do not hand-edit `*.enc.yml`.
- Runtime secrets in CI come from a self-hosted Bitwarden via `get-bw-secret.yml`; the GPG key fetched there decrypts sops files in-task.

## Conventions

- Notifications go to Discord via `flavorjones/webhook-notification-resource`; jobs use `<<: *job-notifications` (success + failure) or only failure hooks.
- Image builds use `concourse/oci-build-task` (`privileged: true`), pushed with `additional_tags` from a version/short_ref file.
- Git resources set `ignore_paths` for README/Makefile/renovate.json so doc changes don't trigger deploys.
- Renovate is enabled (`renovate.json`) — expect automated image tag bumps.

## Known issues / in-progress work (as of 2026-11)

`personal-websites/personal-websites.yml` was recently extended for a second site (`claricen/portfolio` → `flipenergy/clare-portfolio`) and is not finished:
- A stray backtick before `- name: concourse-pipelines-repo` in `deploy-website-to-k8s` breaks the YAML.
- Task `run.path` is `concourse-pipelines-repo/personal-website/deploy-to-k8s.sh`, but the directory is `personal-websites/`.
- Clare's Hugo step uses a placeholder `cd TODO_DIR`.
- `deploy-clare-website-to-k8s` gets `*site-repo` but its task expects `*clare-repo` as input.
- `personal-websites/deploy-to-k8s.sh` has broken quoting in the `helm upgrade` line (`"${RELEASE_NAME} bjw-s/app-template --version "${APP_TEMPLATE_VERSION}`).

Other drift:
- `k8s-homelab/pipeline-templates/diff-k8s-homelab.yml` still has a `diff-oracle` job using `oracle.yaml`, which no longer exists in `k8s-homelab`.
- `tf-pipeline` still fetches an `oracle.pem` from Bitwarden; Oracle is now only used for the TF state bucket/budget.

## Related repos (siblings in `~/repos`)

- `k8s-homelab` — Helmsman desired-state files deployed by this repo.
- `tf-playground` — OpenTofu config planned by this repo.
- `container-images` — Dockerfiles built by `images-build`.
- `personal-website` — Hugo site built/deployed by `personal-sites`.
