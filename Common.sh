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

NODEJS() {
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

  echo "Downloading ${COMPONENT} Application Code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

  cd /home/roboshop

  echo "Clean Old App Content"
  rm -rf ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?

  echo "Extracting ${COMPONENT} Application Code"
  unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
  StatusCheck $?


  mv user-main ${COMPONENT}
  cd /home/roboshop/${COMPONENT}

  echo "Install NodeJS Dependencies"
  npm install &>>${LOG_FILE}
  StatusCheck $?

  echo "Update SystemD Service LOG_FILE"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  StatusCheck $?

  echo "Setup ${COMPONENT} Service"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
  StatusCheck $?

  systemctl daemon-reload &>>${LOG_FILE}
  systemctl enable ${COMPONENT} &>>${LOG_FILE}

  echo "Start ${COMPONENT} Service"
  systemctl start ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?

  }