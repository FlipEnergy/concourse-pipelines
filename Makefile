# main commands

set-all-pipelines: compiled-pipelines-dir decrypt-secrets personal-website-pipeline k8s-homelab-pipeline images-build-pipeline image-notifications-pipeline misc-notifications-pipeline clean-decrypted-files

login:
	fly -t homelab login -kb

# sub-commands

compiled-pipelines-dir:
	mkdir -p compiled-pipelines

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml

personal-website-pipeline:
	cat common/reusable-blocks.yml personal-website/personal-website.yml > compiled-pipelines/personal-website.yml
	-fly -t homelab set-pipeline -n -p personal-website -c compiled-pipelines/personal-website.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml


k8s-homelab-pipeline:
	cat common/reusable-blocks.yml k8s-homelab/k8s-homelab.yml > compiled-pipelines/k8s-homelab.yml
	-fly -t homelab set-pipeline -n -p k8s-homelab -c compiled-pipelines/k8s-homelab.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml

images-build-pipeline:
	cat common/reusable-blocks.yml image-build/image-build.yml > compiled-pipelines/image-build.yml
	-fly -t homelab set-pipeline -n -p images-build -c compiled-pipelines/image-build.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml

image-notifications-pipeline:
	cat common/reusable-blocks.yml notification-jobs/image-notifications.yml > compiled-pipelines/image-notifications.yml
	-fly -t homelab set-pipeline -n -p image-notifications -c compiled-pipelines/image-notifications.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml

misc-notifications-pipeline:
	cat common/reusable-blocks.yml notification-jobs/misc-notifications.yml > compiled-pipelines/misc-notifications.yml
	-fly -t homelab set-pipeline -n -p misc-notifications -c compiled-pipelines/misc-notifications.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml

save-kube-config:
	kubectl config view -o json --flatten | sops --input-type json --output-type yaml -e --output common/misc/kube-config.enc.yml /dev/stdin
