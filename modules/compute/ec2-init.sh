#!bin/bash

# update system
apt update -y

# Install nginx server
apt install nginx -y

# replace default index.html with custom message
bash -c 'cat > /var/www/html/index.html' <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: #282c34;
            color: #61dafb;
        }
        h1 {
            color: #ffd700;
        }
    </style>
</head>
<body>
    <h1>Public Application Load Balancer</h1>
    <p>If you see this page, it means the public application load balancer has been deployed successfully.</p>
    <p>It is now accesible at: https://test.istla.online.</p>
</body>
</html>
EOL

# restart nginx to apply index.html changes
systemctl restart nginx

