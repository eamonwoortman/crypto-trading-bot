# Stage 1: Build
FROM node:20-alpine AS builder

LABEL version="1.0.0" \
      org.opencontainers.image.authors="Daniel Espendiller <daniel@espendiller.net>"

# Install build-essential, sqlite, and other dependencies
RUN apk add --no-cache \
    alpine-sdk \
    build-base \
    python3 \
    sqlite

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json package-lock.json ./
RUN npm install --omit=dev && \
    npm install tulind --build-from-source && \
    npm cache clean --force

# Apply all patches in app
RUN npm run postinstall

# Stage 2: Run
FROM node:20-alpine

WORKDIR /usr/src/app

# Copy app source and dependencies from builder stage
COPY . .
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules ./node_modules


EXPOSE 8080
CMD ["npm", "run", "start"]