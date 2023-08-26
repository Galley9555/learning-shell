LOG_FILE=/tmp/frontend
echo Installing Nginx
yum install nginx -y &>>LOG_FILE
echo Status = $?

echo Downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG_FILE
echo Status = $?

cd /usr/share/nginx/html
rm -rf * &>>/tmp/frontend
echo Status = $?

echo Extracting Web Content
unzip /tmp/frontend.zip &>>LOG_FILE
echo Status = $?

mv frontend-main/static/* . &>>LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG_FILE
echo Status = $?

echo Starting Nginx Sevice
echo Status = $?

systemctl enable nginx &>>LOG_FILE
echo Status = $?

systemctl restart nginx &>>LOG_FILE
echo Status = $?