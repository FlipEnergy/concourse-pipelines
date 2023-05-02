# main commands

set-all-pipelines: decrypt-secrets personal-website k8s-homelab-branch-tracker deploy-k8s-homelab terraform images-build misc-notifications clean-decrypted-files

login:
	fly -t homelab login -kb -c https://concourse.tgp

sync:
	fly -t homelab sync

# sub-commands

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml

personal-website:
	cat common/reusable-blocks.yml personal-website/personal-website.yml | fly -t homelab set-pipeline -n -p $@ -c - -l common/vars/secrets.dec.yml

k8s-homelab-branch-tracker:
	cat common/reusable-blocks.yml k8s-homelab/branch-tracker.yml | fly -t homelab set-pipeline -n -p $@ -c - -l common/vars/secrets.dec.yml

deploy-k8s-homelab:
	cat common/reusable-blocks.yml k8s-homelab/common.yml k8s-homelab/deploy-k8s-homelab.yml | fly -t homelab set-pipeline -n -p $@ -c - -l common/vars/secrets.dec.yml

terraform:
	cat common/reusable-blocks.yml tf-pipeline/tf-pipeline.yml | fly -t homelab set-pipeline -n -p $@ -c - -l common/vars/secrets.dec.yml

images-build:
	cat common/reusable-blocks.yml image-build/image-build.yml | fly -t homelab set-pipeline -n -p $@ -c - -l common/vars/secrets.dec.yml

misc-notifications:
	cat common/reusable-blocks.yml notification-jobs/misc-notifications.yml | fly -t homelab set-pipeline -n -p $@ -c - -l common/vars/secrets.dec.yml

save-kube-config:
	kubectl config view -o json --flatten | sops --input-type json --output-type yaml -e --output common/misc/kube-config.enc.yml /dev/stdin
