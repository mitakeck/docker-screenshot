build:
	docker build -t mitake/chromium .
run:
	export UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"
	docker run -v `PWD`:/images mitake/chromium chromium-browser --headless --disable-gpu --screenshot --user-agent= --window-size=375,812 --no-sandbox ${URL}
