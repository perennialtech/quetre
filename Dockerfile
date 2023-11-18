FROM node:alpine3.17
WORKDIR /app

# Update and install necessary packages
RUN apk update && apk add git

# Clone the repository
RUN git clone https://github.com/zyachel/quetre .

# Install pnpm
RUN npm i -g pnpm
RUN pnpm install

# Create a new user and group 'quetre' with UID and GID of 10001
RUN addgroup -g 10001 quetre && adduser -u 10001 -G quetre -S quetre

# Change the ownership of the /app directory to the new user
RUN chown -R quetre:quetre /app

# Switch to non-root user
USER quetre

EXPOSE 3000

CMD ["pnpm", "start"]
