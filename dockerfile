FROM node:alpine

WORKDIR /usr/app

#update package
RUN apk add --update nodejs npm
RUN apk add --update npm
RUN apk add --update openssh
RUN apk add --update git

#DIRECTORY WITH KEYS FILES + create
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/id_rsa
RUN touch /root/.ssh/id_rsa.pub

RUN touch /root/.ssh/known_hosts

RUN ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts

#keys need to be read-writable only by us
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa.pub

#COPY KEYS FROM FOLDER
COPY ./KEYS/id_rsa.pub /root/.ssh/id_rsa.pub
COPY ./KEYS/id_rsa /root/.ssh/id_rsa

RUN chmod 400 /root/.ssh/id_rsa.pub
RUN chmod 400 /root/.ssh/id_rsa

#the SSH configuration file may not exist
RUN touch /root/.ssh/config
RUN chmod 700 /root/.ssh/config

#If you use a new host - it generates new key
RUN echo $'Host git \n HostName github.com \n AddKeysToAgent yes \n PreferredAuthentications publickey \n IdentityFile /root/.ssh/id_rsa' > /root/.ssh/config
RUN git clone "git@github.com:KacperKi/Simple-web.git" .

RUN npm install

CMD ["npm", "start"]