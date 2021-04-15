
set-all-pipelines:
	make personal-website-pipeline
	make k8s-homelab-helm-repo-pipeline
	make images-build-pipeline

personal-website-pipeline:
	make decrypt-secrets
	cat common/reusable_blocks.yml personal_website/personal_website.yml > compiled_pipelines/personal_website.yml
	-fly -t homelab set-pipeline -n -p personal-website -c compiled_pipelines/personal_website.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

k8s-homelab-helm-repo-pipeline:
	make decrypt-secrets
	cat common/reusable_blocks.yml k8s_homelab/k8s_homelab.yml > compiled_pipelines/k8s_homelab.yml
	-fly -t homelab set-pipeline -n -p k8s-homelab -c compiled_pipelines/k8s_homelab.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

images-build-pipeline:
	make decrypt-secrets
	cat common/reusable_blocks.yml images/image_build.yml > compiled_pipelines/image_build.yml
	-fly -t homelab set-pipeline -n -p images-build -c compiled_pipelines/image_build.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml
