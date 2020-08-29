
set-all-pipelines:
	make login
	make personal_website_ci

login:
	fly -t homelab login -c http://concourse.tgp

personal-website-pipelines:
	sops -d personal_website/secrets.yml > personal_website/secrets.dec.yml
	-fly -t homelab set-pipeline -n -p personal-website-ci -c personal_website/build_latest_image.yml -l personal_website/secrets.dec.yml
	rm -f personal_website/secrets.dec.yml
