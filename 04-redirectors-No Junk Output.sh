echo Installing Nginx
yum install nginx -y &>/dev/null

echo Downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>/dev/null

cd /usr/share/nginx/html
rm -rf * &>/dev/null

echo Extracting Web Content
unzip /tmp/frontend.zip &>/dev/null

mv frontend-main/static/* . &>/dev/null
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>/dev/null

echo Starting Nginx Sevice
systemctl enable nginx &>/dev/null
systemctl restart nginx &>/dev/null