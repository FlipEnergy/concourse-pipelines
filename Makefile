# main commands

set-all-pipelines: decrypt-secrets personal-website-pipeline artifacthub-to-branch-pipeline branch-tracker-k8s-homelab-pipeline deploy-k8s-homelab-pipeline images-build-pipeline image-notifications-pipeline misc-notifications-pipeline clean-decrypted-files

login:
	fly -t homelab login -kb -c https://concourse.tgp

# sub-commands

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml

personal-website-pipeline:
	cat common/reusable-blocks.yml personal-website/personal-website.yml | fly -t homelab set-pipeline -n -p personal-website -c - -l common/vars/secrets.dec.yml

artifacthub-to-branch-pipeline:
	cat common/reusable-blocks.yml k8s-homelab/artifacthub-to-branch.yml | fly -t homelab set-pipeline -n -p artifacthub-to-branch -c - -l common/vars/secrets.dec.yml

branch-tracker-k8s-homelab-pipeline:
	cat common/reusable-blocks.yml k8s-homelab/branch-tracker.yml | fly -t homelab set-pipeline -n -p k8s-homelab-branch-tracker -c - -l common/vars/secrets.dec.yml

deploy-k8s-homelab-pipeline:
	cat common/reusable-blocks.yml k8s-homelab/common.yml k8s-homelab/deploy-k8s-homelab.yml | fly -t homelab set-pipeline -n -p deploy-k8s-homelab -c - -l common/vars/secrets.dec.yml

images-build-pipeline:
	cat common/reusable-blocks.yml image-build/image-build.yml | fly -t homelab set-pipeline -n -p images-build -c - -l common/vars/secrets.dec.yml

image-notifications-pipeline:
	cat common/reusable-blocks.yml notification-jobs/image-notifications.yml | fly -t homelab set-pipeline -n -p image-notifications -c - -l common/vars/secrets.dec.yml

misc-notifications-pipeline:
	cat common/reusable-blocks.yml notification-jobs/misc-notifications.yml | fly -t homelab set-pipeline -n -p misc-notifications -c - -l common/vars/secrets.dec.yml

save-kube-config:
	kubectl config view -o json --flatten | sops --input-type json --output-type yaml -e --output common/misc/kube-config.enc.yml /dev/stdin
