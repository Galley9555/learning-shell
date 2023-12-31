LOG_FILE=/tmp/mongodb

source Common.sh

echo "Setting MongoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
StatusCheck $?

echo "Installing MongoDB Server"
yum install -y mongodb-org
StatusCheck $?

echo "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatusCheck $?

echo "Starting MongoDB Service"
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
StatusCheck $?

echo "Downloading MongoDB Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /tmp

echo "Extracting Schema Files"
unzip -o mongodb.zip &>>$LOG_FILE
StatusCheck $?

cd mongodb-main

echo "Load Catologue Service Schema"
mongo < catalogue.js &>>$LOG_FILE
StatusCheck $?

echo "Load User Service Schema"
mongo < users.js &>>$LOG_FILE
StatusCheck $?