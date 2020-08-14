# picking an alpine build to minimize size and guard against root execution
FROM node:14-alpine

# needed to build gpy'd dependencies
RUN apk add --no-cache --virtual .gyp \
        python \
        make \
        g++

RUN apk add --no-cache openssl
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /bin/www
WORKDIR /bin/www
RUN chown -R node:node /bin/www

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
USER node
COPY package.json ./
COPY package-lock.json ./
RUN npm install --silent

#or this if setting a custom UID
#ARG RUNUSER
#ARG RUNUID
#RUN addgroup -g $RUNUID -S $RUNUSER && adduser -u $RUNUID -S $RUNUSER -G $RUNUSER
#RUN mkdir -p /home/$RUNUSER
#RUN chown $RUNUSER:$RUNUSER /home/$RUNUSER
#RUN chown -R $RUNUSER:$RUNUSER /app

#add app
COPY . ./

# let's fly
CMD [ "npm", "start" ]
