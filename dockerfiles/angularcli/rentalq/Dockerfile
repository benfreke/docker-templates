FROM node:8.7.0

USER node

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

ENV PATH=$PATH:/home/node/.npm-global/bin

RUN npm install -g @angular/cli@1.1.3 && npm install -g @angular/core

CMD ["node"]