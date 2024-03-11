# ------ Builder stage ------
FROM node:lts-alpine AS builder

ENV NODE_ENV=production
WORKDIR /app

RUN apk add --no-cache git
RUN corepack enable
RUN git clone --depth 1 https://github.com/zyachel/quetre.git . && rm -rf .git .github ./*.md .gitignore .eslintrc.json quetre.service .env.example
RUN pnpm install
RUN pnpm run sass:build

# ------ Final image ------
FROM node:lts-alpine

ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /app /app

# Create a non-root user `quetre` and set ownership
RUN addgroup -g 1001 -S quetre && \
    adduser -u 1001 -S quetre -G quetre && \
    chown -R quetre:quetre /app

# Switch to non-root user
USER quetre

EXPOSE 3000

CMD ["node", "server.js"]
