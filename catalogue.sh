LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this Script as a Root User or Sudo User
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32mSUCCESS\e[0m"
  else
    echo -e Status = "\e[32mSUCCESS\e[0m"
    exit 1
  fi
}
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

echo "Downloading Catalogue Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "Clean Old App Content"
rm -rf catalogue &>>${LOG_FILE}
StatusCheck $?

echo "Extracting Catalogue Application Code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
StatusCheck $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

echo "Setup catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}



systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}


echo "Start Cataloge Service"
systemctl start catalogue &>>${LOG_FILE}
