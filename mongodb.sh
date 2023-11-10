LOG_FILE=/tmp/mongod

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

echo "Setting MongoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status = $?

echo "Installing MongoDB Server"
yum install -y mongodb-org
echo status = $?

echo "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status = $?

echo "Starting MongoDB Service"
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
echo status = $?

echo "Downloading MongoDB Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
echo status = $?

cd /tmp

echo "Extracting Schema Files"
unzip mongodb.zip &>>$LOG_FILE
echo status = $?

cd mongodb-main

echo "Load Catologue Service Schema"
mongo < catalogue.js &>>$LOG_FILE
echo status = $?

echo "Load User Service Schema"
mongo < users.js &>>$LOG_FILE
echo status = $?