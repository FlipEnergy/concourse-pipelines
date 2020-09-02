
set-all-pipelines:
	make personal-website-pipelines
	make helm-charts-repo-pipelines

personal-website-pipelines:
	sops -d personal_website/secrets.yml > personal_website/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p personal-website -c personal_website/build_push_deploy.yml -l personal_website/secrets.dec.yml
	rm -f personal_website/secrets.dec.yml

helm-charts-repo-pipelines:
	sops -d helm_charts_repo/secrets.yml > helm_charts_repo/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p helm-charts-repo -c helm_charts_repo/index_charts_and_push.yml -l helm_charts_repo/secrets.dec.yml
	rm -f helm_charts_repo/secrets.dec.yml
