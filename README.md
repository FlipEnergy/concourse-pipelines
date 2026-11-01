# concourse-pipelines
repo for my concourse CI pipelines.

Pipelines (set them all with `make set-all-pipelines`):
- `personal-sites`: build, push and deploy my websites to k8s
- `deploy-k8s-homelab` and `k8s-homelab-branch-tracker`: deploy and diff my [k8s-homelab](https://github.com/FlipEnergy/k8s-homelab) repo with Helmsman
- `terraform`: weekly `terraform plan` of my [tf-playground](https://github.com/FlipEnergy/tf-playground) repo
- `images-build`: build my [container images](https://github.com/FlipEnergy/container-images) when upstream releases
- `misc-notifications`: scheduled Discord reminders
- `clone-github-repos`: scheduled clones of my GitHub repos
