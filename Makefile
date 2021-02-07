
set-all-pipelines:
	make personal-website-pipeline
	make k8s-homelab-helm-repo-pipeline
	make utilities-pipeline

personal-website-pipeline:
	make decrypt-secrets
	-fly -t homelab set-pipeline -n -p personal-website -c personal_website/build_push_deploy.yml -l common/vars/vars.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

k8s-homelab-helm-repo-pipeline:
	make decrypt-secrets
	-fly -t homelab set-pipeline -n -p k8s-homelab -c k8s_homelab/deploy_homelab_k8s.yml -l common/vars/vars.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

utilities-pipeline:
	make decrypt-secrets
	-fly -t homelab set-pipeline -n -p utilities -c utilites/utilities_pipeline.yml -l common/vars/vars.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml
