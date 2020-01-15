FROM alpine:edge as dl-notofont
WORKDIR /work
RUN apk update && apk add jq wget unzip
RUN wget https://noto-website.storage.googleapis.com/pkgs/Noto-unhinted.zip \
  && unzip -d NotoSansJapanese Noto-unhinted.zip \
  && rm Noto-unhinted.zip

FROM alpine:edge

RUN apk add --update \
  udev \
  ttf-freefont \
  chromium

# install noto font
COPY --from=dl-notofont /work/NotoSansJapanese /usr/share/fonts/opentype/NotoSansJapanese
RUN fc-cache -fv

WORKDIR /images
