FROM node:20-alpine

MAINTAINER Daniel Espendiller <daniel@espendiller.net>

# Install build-essential, sqlite in order
RUN apk update \
    && apk --no-cache --update add build-base alpine-sdk && apk add git python3 sqlite

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install --omit=dev && \
    npm cache clean --force

# Bundle app source
COPY . /usr/src/app

# Apply all patches in app
RUN npm run postinstall

EXPOSE 8080
CMD ["npm", "run", "start"]
