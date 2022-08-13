# syntax = docker/dockerfile:1.3-labs
FROM node:current-bullseye-slim
ENV APP_DIR=/usr/src/app


ENV SKIP_GITIGNORE_CHECK true
ENV NODE_ENV production
ENV PORT 8080

# Add your custom ENV vars here:
ENV WA_POPUP true
ENV IS_DOCKER=true
ENV WA_DISABLE_SPINS true
ENV WA_PORT $PORT
ENV WA_EXECUTABLE_PATH=/usr/bin/google-chrome
ENV CHROME_PATH=${WA_EXECUTABLE_PATH}
ENV WA_USE_CHROME=true

ENV PUPPETEER_CHROMIUM_REVISION=${PUPPETEER_CHROMIUM_REVISION}
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PLAYWRIGHT_BROWSERS_PATH=${APP_DIR}

COPY . $APP_DIR

WORKDIR $APP_DIR

RUN cat bash.txt

RUN npm prune --production && chown -R owauser:owauser $APP_DIR
EXPOSE $PORT

# test with root later
USER owauser


ENTRYPOINT ["/usr/bin/dumb-init", "--", "./start.sh", "./node_modules/@open-wa/wa-automate/bin/server.js", "--in-docker", "--qr-timeout", "0", "--popup", "--debug", "--force-port"]
