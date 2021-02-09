
set-all-pipelines:
	make personal-website-pipeline
	make k8s-homelab-helm-repo-pipeline
	make helm-charts-pipeline
	make utilities-pipeline

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

helm-charts-pipeline:
	make decrypt-secrets
	cat common/reusable_blocks.yml helm_charts/helm_charts.yml > compiled_pipelines/helm_charts.yml
	-fly -t homelab set-pipeline -n -p helm-charts -c compiled_pipelines/helm_charts.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

utilities-pipeline:
	make decrypt-secrets
	cat common/reusable_blocks.yml utilites/utilities.yml > compiled_pipelines/utilities.yml
	-fly -t homelab set-pipeline -n -p utilities -c compiled_pipelines/utilities.yml -l common/vars/secrets.dec.yml
	make clean-decrypted-files

decrypt-secrets:
	sops -d common/vars/secrets.enc.yml > common/vars/secrets.dec.yml

clean-decrypted-files:
	rm -f common/vars/secrets.dec.yml
