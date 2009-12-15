# You may add here your
# server {
#	...
server {
		listen 80;
		server_name simplecd.app-base.com www.simplecd.org simplecd.org;
		access_log /var/log/nginx/simplecd.app-base.com.access_log;
		error_log /var/log/nginx/simplecd.app-base.com.error_log warn;
		root /var/www/simplecd.app-base.com/;
        index           index.html;
		location / {
			include fastcgi_params;
			fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
			fastcgi_param PATH_INFO $fastcgi_script_name;
			fastcgi_pass 127.0.0.1:9001;
			fastcgi_cache webpy;
			fastcgi_cache_key $server_addr$request_uri;
			fastcgi_cache_valid any 1m;
			fastcgi_hide_header Set-Cookie;
		}
		location /static/ {
			if (-f $request_filename) {
				rewrite ^/static/(.*)$ /static/$1 break;
			}
		}
}
