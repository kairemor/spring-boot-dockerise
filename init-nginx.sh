sudo apt update
sudo apt install nginx
sudo ufw allow 'Nginx HTTP'
sudo systemctl restart nginx

while getopts ":s:n:" opt; do
  case $opt in
    s) server="$OPTARG"
    ;;
    n) app_name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

sudo touch /etc/nginx/conf.d/${app_name}.conf

echo "
server {
        listen 80;
        listen [::]:80;

        server_name example;

        location / {
             proxy_pass http://$server/;
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
             proxy_set_header X-Forwarded-Proto $scheme;
             proxy_set_header X-Forwarded-Port $server_port;
        }
}
"  | sudo tee -a /etc/nginx/conf.d/${app_name}.conf
