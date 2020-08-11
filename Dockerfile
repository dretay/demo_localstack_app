# picking an alpine build to minimize size and guard against root execution
FROM node:14-alpine

RUN apk add --no-cache openssl
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# create app dir
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app

# copy package.json AND package-lock.json over
COPY package*.json ./

USER node

# install dependencies (maybe one day this will be a layer?)
RUN npm install

# copy over src
COPY --chown=node:node . .

# this is the port we've bound to
EXPOSE 3000


# let's fly
CMD [ "npm", "start" ]
