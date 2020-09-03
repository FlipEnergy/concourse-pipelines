
set-all-pipelines:
	make personal-website-pipeline
	make k8s-homelab-helm-repo-pipeline

personal-website-pipeline:
	sops -d personal_website/secrets.yml > personal_website/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p personal-website -c personal_website/build_push_deploy.yml -l personal_website/secrets.dec.yml
	rm -f personal_website/secrets.dec.yml

k8s-homelab-helm-repo-pipeline:
	sops -d k8s-homelab-helm-repo/secrets.yml > k8s-homelab-helm-repo/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p k8s-homelab-helm-repo -c k8s-homelab-helm-repo/index_charts_and_push.yml -l k8s-homelab-helm-repo/secrets.dec.yml
	rm -f k8s-homelab-helm-repo/secrets.dec.yml
