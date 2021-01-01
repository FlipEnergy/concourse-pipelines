
set-all-pipelines:
	make personal-website-pipeline
	make k8s-homelab-helm-repo-pipeline

personal-website-pipeline:
	sops -d common/secrets.enc.yml > common/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p personal-website -c personal_website/build_push_deploy.yml -l common/vars.yml -l common/secrets.dec.yml
	rm -f common/secrets.dec.yml

k8s-homelab-helm-repo-pipeline:
	sops -d common/secrets.enc.yml > common/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p k8s-homelab-helm-repo -c k8s_homelab/index_charts_and_push.yml -l common/vars.yml -l common/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p k8s-homelab -c k8s_homelab/deploy_homelab_k8s.yml -l common/vars.yml -l common/secrets.dec.yml
	rm -f common/secrets.dec.yml

build-push-bitwarden-cli:
	docker build -t flipenergy/bitwarden_cli:0.1.0 -f dockerfiles/bitwarden_cli dockerfiles/
	docker push flipenergy/bitwarden_cli:0.1.0
