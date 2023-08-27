LOG_FILE=/tmp/catalogue

echo "Setup NodeJS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
echo status = $?

echo "Install NodeJS"
yum install nodejs -y &>>${LOG_FILE}
echo status = $?

echo "Adding Roboshop Application User"
useradd roboshop &>>${LOG_FILE}
echo status =$?

echo "Downloading Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
echo status = $?

cd /home/roboshop

echo "Extracting Catalogue Application Code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
echo status = $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
echo status = $?

echo "Setup catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
echo status = $?


systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}


echo "Start Cataloge Service"
systemctl start catalogue &>>${LOG_FILE}
echo status = $?