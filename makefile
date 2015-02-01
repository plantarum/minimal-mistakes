
publish: html
	rsync -vr _site/ tws@plantarum.ca:/var/www/

html:
	jekyll build
