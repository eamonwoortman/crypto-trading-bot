# Stage 1: Build
FROM node:20-alpine AS builder

LABEL version="0.0.0"
LABEL org.opencontainers.image.authors="Daniel Espendiller <daniel@espendiller.net>"

# Install build-essential, sqlite in order
RUN apk update \
    && apk --no-cache --update add build-base alpine-sdk && apk add python3 sqlite

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install --omit=dev && \
    npm cache clean --force

# Apply all patches in app
RUN npm run postinstall

# Stage 2: Run
FROM node:20-alpine

# Bundle app source
COPY . /usr/src/app

# Copy our node_modules from the builder stage
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules

EXPOSE 8080
CMD ["npm", "run", "start"]
