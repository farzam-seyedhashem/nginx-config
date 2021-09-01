#mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/$1.conf
#echo "==================================================================="
#echo "create $1 config"
#echo "==================================================================="
#cp /etc/nginx/conf.d/$1.conf /etc/nginx/conf.d/admin.$1.conf
#echo "==================================================================="
#echo "create admin.$1 config"
#echo "==================================================================="
#cp /etc/nginx/conf.d/$1.conf /etc/nginx/conf.d/ap.$1.conf
#echo "==================================================================="
#echo "create admin.$1 config"
#echo "==================================================================="
rm -rf /etc/nginx/conf.d/*
echo "==================================================================="
echo "all conf file deleted"
echo "==================================================================="
cat > /etc/nginx/conf.d/$1.conf <<EOL
server {
    listen       80;
    server_name  $1 www.$1;

    location / {
         proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}


server {
    if (\$host = www.$1) {
        return 301 http://\$host\$request_uri;
    } # managed by Certbot


    if (\$host = $1) {
        return 301 http://\$host\$request_uri;
    } # managed by Certbot


    listen       80;
    server_name  $1 www.$1;
    return 404; # managed by Certbot
}
EOL
echo "==================================================================="
echo "create $1 config"
echo "==================================================================="
cat > /etc/nginx/conf.d/admin.$1.conf <<EOL
server {
    listen       80;
    server_name  admin.$1;

    location / {
        proxy_pass http://127.0.0.1:3002;
        proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}
server {
    if (\$host = admin.$1) {
        return 301 http://\$host\$request_uri;
    } # managed by Certbot

    listen       80;
    server_name  admin.$1;
    return 404; # managed by Certbot
}
EOL
echo "==================================================================="
echo "create admin.$1 config"
echo "==================================================================="
cat > /etc/nginx/conf.d/api.$1.conf <<EOL
server {
    listen       80;
    server_name  api.$1;

    location / {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
server {
    if (\$host = api.$1) {
        return 301 http://\$host\$request_uri;
    } # managed by Certbot

    listen       80;
    server_name  api.$1;
    return 404; # managed by Certbot
}
EOL
echo "==================================================================="
echo "create api.$1 config"
echo "==================================================================="
nginx -t
systemctl restart nginx
echo "==================================================================="
echo "configuration succeed"
echo "==================================================================="
setsebool httpd_can_network_connect on
setsebool httpd_can_network_connect on -P
echo "==================================================================="
echo "handle 13 permission nginx"
echo "==================================================================="
