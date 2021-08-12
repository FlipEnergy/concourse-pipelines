
set-all-pipelines:
	mkdir -p compiled-pipelines
	make personal-website-pipeline
	make k8s-homelab-helm-repo-pipeline
	make images-build-pipeline
	make notifications-pipeline

personal-website-pipeline:
	mkdir -p compiled-pipelines
	make decrypt-secrets
	cat common/reusable-blocks.yml personal-website/personal-website.yml > compiled-pipelines/personal-website.yml
	-fly -t homelab set-pipeline -n -p personal-website -c compiled-pipelines/personal-website.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml
	make clean-decrypted-files

k8s-homelab-helm-repo-pipeline:
	mkdir -p compiled-pipelines
	make decrypt-secrets
	cat common/reusable-blocks.yml k8s-homelab/k8s-homelab.yml > compiled-pipelines/k8s-homelab.yml
	-fly -t homelab set-pipeline -n -p k8s-homelab -c compiled-pipelines/k8s-homelab.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml
	make clean-decrypted-files

images-build-pipeline:
	mkdir -p compiled-pipelines
	make decrypt-secrets
	cat common/reusable-blocks.yml image-build/image-build.yml > compiled-pipelines/image-build.yml
	-fly -t homelab set-pipeline -n -p images-build -c compiled-pipelines/image-build.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml
	make clean-decrypted-files

notifications-pipeline:
	mkdir -p compiled-pipelines
	make decrypt-secrets
	cat common/reusable-blocks.yml notification-jobs/notification-jobs.yml > compiled-pipelines/notification-jobs.yml
	-fly -t homelab set-pipeline -n -p notification-jobs -c compiled-pipelines/notification-jobs.yml -l common/vars/secrets.dec.yml -l common/vars/vars.yml
	make clean-decrypted-files

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml
