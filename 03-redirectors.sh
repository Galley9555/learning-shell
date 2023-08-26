echo Installing Nginx
yum install nginx -y &>>/tmp/frontend
echo Status = $?

echo Downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend
echo Status = $?

cd /usr/share/nginx/html
rm -rf * &>>/tmp/frontend
echo Status = $?

echo Extracting Web Content
unzip /tmp/frontend.zip &>>/tmp/frontend
echo Status = $?

mv frontend-main/static/* . &>>/tmp/frontend
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend
echo Status = $?

echo Starting Nginx Sevice
echo Status = $?

systemctl enable nginx &>>/tmp/frontend
echo Status = $?

systemctl restart nginx &>>/tmp/frontend
echo Status = $?