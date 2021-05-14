#!/bin/bash

echo export DB_HOST="mongodb://30.0.30.30:27017/posts" | sudo tee -a /etc/profile
. /etc/profile
cd /home/ubuntu/app/
#cd app
sudo -E npm install
#node seeds/seed.js
sudo -E pm2 start app.js
