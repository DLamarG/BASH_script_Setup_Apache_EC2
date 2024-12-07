#!/bin/bash

# Update OS
sudo apt update -y && sudo apt upgrade -y

# Install Apache server
sudo apt install -y apache2

# Get public IP address of EC2 instance using instance metadata
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") \
&& REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region) \
&& INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id) \
&& IPv4=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

# Get date and time of server
DATE_TIME=$(date)

# Set all permissions
sudo chmod -R 777 /var/www/html

# Create a custom index.html file
echo "<html>
<body>
    <h1>This web server is launched from launch template to Learn DevOps</h1>
    <p>This instance is created at <b>$DATE_TIME</b></p>
    <p>This instance is running in <b>$REGION</b></p>
    <p>This instance ID is <b>$INSTANCE_ID</b></p>
    <p>This instance IPv4 is <b>$IPv4</b></p>
</body>
</html>" | sudo tee /var/www/html/index.html

# Start Apache server
sudo systemctl start apache2
sudo systemctl enable apache2