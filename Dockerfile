FROM alpine:edge as dl-notofont
WORKDIR /work
RUN apk update && apk add jq wget unzip
RUN wget https://noto-website.storage.googleapis.com/pkgs/Noto-unhinted.zip \
  && unzip -d NotoSansJapanese Noto-unhinted.zip \
  && rm Noto-unhinted.zip

FROM node:12-slim

# Install chrome
RUN apt-get update \
  && apt-get install -y wget gnupg \
  &&  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y \
    google-chrome-unstable\
    fonts-ipafont-gothic\
    fonts-wqy-zenhei\
    fonts-thai-tlwg\
    fonts-kacst\
    fonts-freefont-ttf\
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Install puppeteer so it's available in the container.
RUN npm i puppeteer \
  # Add user so we don't need --no-sandbox.
  # same layer as npm install to keep re-chowned files from using up several hundred MBs more space
  && groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
  && mkdir -p /home/pptruser/Downloads \
  && chown -R pptruser:pptruser /home/pptruser \
  && chown -R pptruser:pptruser /node_modules

# Install noto font
COPY --from=dl-notofont /work/NotoSansJapanese /usr/share/fonts/opentype/NotoSansJapanese
RUN fc-cache -fv

# Setup node app
COPY *.json /app/
COPY src /app/src
WORKDIR /app
RUN yarn install && yarn run build
ENV mode=production

# Run everything after as non-privileged user.
USER pptruser
ENTRYPOINT [ "node", "/app/dist/index.js" ]
