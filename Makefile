build:
	docker build -t mitake/screenshot .
run:
	docker run -v `PWD`/images:/images mitake/screenshot https://google.com google.png
	docker run -v `PWD`/images:/images mitake/screenshot https://ja.wikipedia.org/wiki/%E5%AF%8C%E5%A3%AB%E5%B1%B1 fuji.png
screenshot:
	docker run -v `PWD`/images:/images mitake/screenshot ${URL} ${FILE}
