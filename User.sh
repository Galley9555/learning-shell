LOG_FILE=/tmp/user

source Common.sh

echo "Setup NodeJS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?


echo "Install NodeJS"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo "Adding Roboshop Application User"
 useradd roboshop &>>${LOG_FILE}
 StatusCheck $?
fi

echo "Downloading User Application Code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "Clean Old App Content"
rm -rf user &>>${LOG_FILE}
StatusCheck $?

echo "Extracting user Application Code"
unzip /tmp/user.zip &>>${LOG_FILE}
StatusCheck $?


mv user-main user
cd /home/roboshop/user

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

echo "Update SystemD Service LOG_FILE"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service
StatusCheck $?

echo "Setup user Service"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
StatusCheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}

echo "Start user Service"
systemctl start user &>>${LOG_FILE}
StatusCheck $?

