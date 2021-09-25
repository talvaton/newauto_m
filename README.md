# Выкатывание

Для выкатывания на сервер, необходимо:

* git pull
* rails assets:precompile RAILS_ENV=carso
* rails tmp:cache:clear RAILS_ENV=carso
* rails server:restart

# Обновление цен

В админке:

* Делаем изменения в ценах
* rails prices:export

На сервере делаем
* rails prices:import

# Установка под Windows

* Скачать и установить MySQL Server для Windows (MySQL Installer)
* Скачать и установить RailsInstaller
* Скачать и установить RubyInstaller + DevKit 2.5.3
* Перезагрузить Windows
* Сделать git pull или git clone
* В Gemfile поставить версию Ruby 2.5.3
* Сделать gem install bundler
* Сделать bundle install
* Сделать gem uninstall bcrypt
* Сделать gem install bcrypt --platform=ruby
* Положить master.key в директорию /config
* Запустить MySQL Server (если запускается вручную)
- Запустить консоль MySQL и выполнить команды:
- CREATE USER 'salon_web'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
- GRANT ALL PRIVILEGES ON \*.\* TO 'salon_web'@'localhost';
* Скачать и установить ImageMagick для Windows
* Перезагрузить Windows
* Запустить MySQL Server (если запускается вручную)
* Сделать rails db:create, rails db:migrate, rails db:seed (rails db:create RAILS_ENV=salon_dev)
 вкл/выкл dev cache -> rails dev:cache

CERTBOT

certbot certonly --dry-run -d carso.ru - test


```
sudo certbot --authenticator webroot --installer nginx \
  --webroot-path /var/www/carso-ruby/public \ -d astrakhan.carso.ru \
-d belarus.carso.ru \
-d belgorod.carso.ru \
-d bryansk.carso.ru \
-d chehov.carso.ru \
-d chelyabinsk.carso.ru \
-d cherepovec.carso.ru \
-d ekaterinburg.carso.ru \
-d irkutsk.carso.ru \
-d ivanovo.carso.ru \
-d izhevsk.carso.ru \
-d kaluga.carso.ru \
-d kazakhstan.carso.ru \
-d kazan.carso.ru \
-d kirov.carso.ru \
-d kolomna.carso.ru \
-d kostroma.carso.ru \
-d krasnodar.carso.ru \
-d krasnoyarsk.carso.ru \
-d kursk.carso.ru \
-d lipeck.carso.ru \
-d nizhniy-novgorod.carso.ru \
-d novgorod.carso.ru \
-d novosibirsk.carso.ru \
-d obninsk.carso.ru \
-d omsk.carso.ru \
-d orel.carso.ru \
-d orenburg.carso.ru \
-d penza.carso.ru \
-d perm.carso.ru \
-d peterburg.carso.ru \
-d podolsk.carso.ru \
-d pskov.carso.ru \
-d rostov.carso.ru \
-d ryazan.carso.ru \
-d carso.ru \
-d samara.carso.ru \
-d saransk.carso.ru \
-d saratov.carso.ru \
-d serpuhov.carso.ru \
-d smolensk.carso.ru \
-d sochi.carso.ru \
-d stavropol.carso.ru \
-d syktyvkar.carso.ru \
-d tagil.carso.ru \
-d tambov.carso.ru \
-d tomsk.carso.ru \
-d tolyatti.carso.ru \
-d tula.carso.ru \
-d tver.carso.ru \
-d tyumen.carso.ru \
-d ufa.carso.ru \
-d ulyanovsk.carso.ru \
-d vladimir.carso.ru \
-d volgograd.carso.ru \
-d vologda.carso.ru \
-d voronezh.carso.ru \
-d www.carso.ru \
-d yaroslavl.carso.ru \
-d balashiha.carso.ru \
-d voskresensk.carso.ru \
-d dolgoprudniy.carso.ru \
-d domodedovo.carso.ru \
-d dubna.carso.ru \
-d egorievsk.carso.ru \
-d zhukovskiy.carso.ru \
-d klin.carso.ru \
-d korolev.carso.ru \
-d krasnogorsk.carso.ru \
-d lobnya.carso.ru \
-d lyubertsy.carso.ru \
-d mytishchi.carso.ru \
-d naro-fominsk.carso.ru \
-d noginsk.carso.ru \
-d odintsovo.carso.ru \
-d pushkino.carso.ru \
-d ramenskoe.carso.ru \
-d reutov.carso.ru \
-d sergiev-posad.carso.ru \
-d stupino.carso.ru \
-d himki.carso.ru \
-d elektrostal.carso.ru
```

sudo certbot --authenticator webroot --installer nginx \
  --webroot-path /var/www/carso-staging/current/public \ -d carso.ru \
 -d www.carso.ru \
 -d astrakhan.carso.ru \
 -d balashiha.carso.ru \
 -d belarus.carso.ru \
 -d belgorod.carso.ru \
 -d bryansk.carso.ru \
 -d cheboksary.carso.ru \
 -d chehov.carso.ru \
 -d chelyabinsk.carso.ru \
 -d cherepovets.carso.ru \
 -d ekaterinburg.carso.ru \
 -d himki.carso.ru \
 -d irkutsk.carso.ru \
 -d ivanovo.carso.ru \
 -d izhevsk.carso.ru \
 -d kaluga.carso.ru \
 -d kazakhstan.carso.ru \
 -d kazan.carso.ru \
 -d kirov.carso.ru \
 -d kolomna.carso.ru \
 -d kostroma.carso.ru \
 -d krasnodar.carso.ru \
 -d krasnoyarsk.carso.ru \
 -d kursk.carso.ru \
 -d lipetsk.carso.ru \
 -d nn.carso.ru \
 -d novgorod.carso.ru \
 -d novosibirsk.carso.ru \
 -d obninsk.carso.ru \
 -d omsk.carso.ru \
 -d orekhovozuevo.carso.ru \
 -d orel.carso.ru \
 -d orenburg.carso.ru \
 -d penza.carso.ru \
 -d perm.carso.ru \
 -d podolsk.carso.ru \
 -d pskov.carso.ru \
 -d rostov.carso.ru \
 -d ryazan.carso.ru \
 -d samara.carso.ru \
 -d saransk.carso.ru \
 -d saratov.carso.ru \
 -d serpuhov.carso.ru \
 -d sevastopol.carso.ru \
 -d simferopol.carso.ru \
 -d smolensk.carso.ru \
 -d sochi.carso.ru \
 -d spb.carso.ru \
 -d stavropol.carso.ru \
 -d syktyvkar.carso.ru \
 -d tagil.carso.ru \
 -d tolyatti.carso.ru \
 -d tomsk.carso.ru \
 -d tula.carso.ru \
 -d tver.carso.ru \
 -d tyumen.carso.ru \
 -d ufa.carso.ru \
 -d ulyanovsk.carso.ru \
 -d vladimir.carso.ru \
 -d volgograd.carso.ru \
 -d vologda.carso.ru \
 -d voronezh.carso.ru \
 -d yaroslavl.carso.ru \
 
 
sudo certbot --nginx -d carso.ru  -d www.carso.ru  -d astrakhan.carso.ru  -d balashiha.carso.ru  -d belarus.carso.ru  -d belgorod.carso.ru  -d bryansk.carso.ru  -d cheboksary.carso.ru  -d chehov.carso.ru  -d chelyabinsk.carso.ru  -d cherepovets.carso.ru  -d ekaterinburg.carso.ru  -d himki.carso.ru  -d irkutsk.carso.ru  -d ivanovo.carso.ru  -d izhevsk.carso.ru  -d kaluga.carso.ru  -d kazakhstan.carso.ru  -d kazan.carso.ru  -d kirov.carso.ru  -d kolomna.carso.ru  -d kostroma.carso.ru  -d krasnodar.carso.ru  -d krasnoyarsk.carso.ru  -d kursk.carso.ru  -d lipetsk.carso.ru  -d nn.carso.ru  -d novgorod.carso.ru  -d novosibirsk.carso.ru  -d obninsk.carso.ru  -d omsk.carso.ru  -d orekhovozuevo.carso.ru  -d orel.carso.ru  -d orenburg.carso.ru  -d penza.carso.ru  -d perm.carso.ru  -d podolsk.carso.ru  -d pskov.carso.ru  -d rostov.carso.ru  -d ryazan.carso.ru  -d samara.carso.ru  -d saransk.carso.ru  -d saratov.carso.ru  -d serpuhov.carso.ru  -d sevastopol.carso.ru  -d simferopol.carso.ru  -d smolensk.carso.ru  -d sochi.carso.ru  -d spb.carso.ru  -d stavropol.carso.ru  -d syktyvkar.carso.ru  -d tagil.carso.ru  -d tolyatti.carso.ru  -d tomsk.carso.ru  -d tula.carso.ru  -d tver.carso.ru  -d tyumen.carso.ru  -d ufa.carso.ru  -d ulyanovsk.carso.ru  -d vladimir.carso.ru  -d volgograd.carso.ru  -d vologda.carso.ru  -d voronezh.carso.ru 
 
 
 
 
 
 
 
 
 
 
 carso.ru www.carso.ru astrakhan.carso.ru balashiha.carso.ru belarus.carso.ru belgorod.carso.ru bryansk.carso.ru cheboksary.carso.ru chehov.carso.ru chelyabinsk.carso.ru cherepovets.carso.ru ekaterinburg.carso.ru himki.carso.ru irkutsk.carso.ru ivanovo.carso.ru izhevsk.carso.ru kaluga.carso.ru kazakhstan.carso.ru kazan.carso.ru kirov.carso.ru kolomna.carso.ru kostroma.carso.ru krasnodar.carso.ru krasnoyarsk.carso.ru kursk.carso.ru lipetsk.carso.ru nn.carso.ru novgorod.carso.ru novosibirsk.carso.ru obninsk.carso.ru omsk.carso.ru orekhovozuevo.carso.ru orel.carso.ru orenburg.carso.ru penza.carso.ru perm.carso.ru podolsk.carso.ru pskov.carso.ru rostov.carso.ru ryazan.carso.ru samara.carso.ru saransk.carso.ru saratov.carso.ru serpuhov.carso.ru sevastopol.carso.ru simferopol.carso.ru smolensk.carso.ru sochi.carso.ru spb.carso.ru stavropol.carso.ru syktyvkar.carso.ru tagil.carso.ru tolyatti.carso.ru tomsk.carso.ru tula.carso.ru tver.carso.ru tyumen.carso.ru ufa.carso.ru ulyanovsk.carso.ru vladimir.carso.ru volgograd.carso.ru vologda.carso.ru voronezh.carso.ru yaroslavl.carso.ru
 
 
 
 old NS
 ns1.adminvps.ru
 ns2.adminvps.net
 
 
 ---------------------------------------------
 
 
 upstream carso_staging {
   server unix:///var/www/carso_staging/shared/tmp/sockets/puma.sock;
 }
 
 #upstream carso_production {
 #  server unix:///var/www/marketoff_production/shared/tmp/sockets/puma.sock;
 #}
 
 server {
        listen         80;
        server_name    carso.ru *.carso.ru;
        return         301 https://$host$request_uri;
 }
 
 server {
     server_name carso.ru www.carso.ru; # astrakhan.carso.ru balashiha.carso.ru belarus.carso.ru belgorod.carso.ru bryansk.carso.ru cheboksary.carso.ru chehov.carso.ru chelyabinsk.carso.ru cherepovets.carso.ru ekaterinburg.carso.ru himki.carso.ru irkutsk.carso.ru ivanovo.carso.ru izhevsk.carso.ru kaluga.carso.ru kazakhstan.carso.ru kazan.carso.ru kirov.carso.ru kolomna.carso.ru kostroma.carso.ru krasnodar.carso.ru krasnoyarsk.carso.ru kursk.carso.ru lipetsk.carso.ru nn.carso.ru novgorod.carso.ru novosibirsk.carso.ru obninsk.carso.ru omsk.carso.ru orekhovozuevo.carso.ru orel.carso.ru orenburg.carso.ru penza.carso.ru perm.carso.ru podolsk.carso.ru pskov.carso.ru rostov.carso.ru ryazan.carso.ru samara.carso.ru saransk.carso.ru saratov.carso.ru serpuhov.carso.ru sevastopol.carso.ru simferopol.carso.ru smolensk.carso.ru sochi.carso.ru spb.carso.ru stavropol.carso.ru syktyvkar.carso.ru tagil.carso.ru tolyatti.carso.ru tomsk.carso.ru tula.carso.ru tver.carso.ru tyumen.carso.ru ufa.carso.ru ulyanovsk.carso.ru vladimir.carso.ru volgograd.carso.ru vologda.carso.ru voronezh.carso.ru yaroslavl.carso.ru;
 
     root /var/www/carso_staging/current/public;
 
     listen 3000;
     #listen 3000 ssl http2;
     #listen 9999 ssl http2 default_server; # managed by Certbot
 
     #listen 443 ssl; # managed by Certbot
     #listen 443 ssl http2;
     rewrite ^/(.*)/$ /$1 permanent;
 
     gzip on;
     gzip_http_version 1.1;
     gzip_vary on;
     gzip_comp_level 6;
     gzip_proxied any;
     gzip_types text/plain text/css application/json application/javascript application/x-javascript text/javascript text/xml application/xml application/rss+xml application/atom+xml application/rdf+xml image/svg+xml;
 
 
    # ssl_certificate /etc/letsencrypt/live/autosalon-m.ru/fullchain.pem; # managed by Certbot
    # ssl_certificate_key /etc/letsencrypt/live/autosalon-m.ru/privkey.pem; # managed by Certbot
    # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
 
    # location ~ [A-Z] { return 307 $scheme://$host$my_uri_to_lowercase; }
 
      location / {
 
       proxy_pass https://carso_staging;
       proxy_set_header Host $host:3000;
       proxy_set_header Host $host;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-Ssl on;
     }
 
 
 }
 
 server{
     error_page 497 301 =307 https://www.$host$request_uri;
     return 301 https://$host$request_uri;
     listen 443;
     server_name carso.ru;
 }


-----------------------------------------------------

upstream carso_staging {
  server unix:///var/www/carso_staging/shared/tmp/sockets/puma.sock;
}

#upstream carso_production {
#  server unix:///var/www/marketoff_production/shared/tmp/sockets/puma.sock;
#}

#server {
     #  listen         80;
     #  server_name    carso.ru;
     # return         301 http://$host$request_uri;
#}

server {
   listen 80 default_server;

    server_name carso.ru;
    return 301 http://$host$request_uri;

    root /var/www/carso_staging/current/public;

    #listen 3000 ssl http2;
    #listen 9999 ssl http2 default_server; # managed by Certbot

    listen 443 ssl http2; # managed by Certbot

    rewrite ^/(.*)/$ /$1 permanent;

    gzip on;
    gzip_http_version 1.1;
    gzip_vary on;
    gzip_comp_level 6;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/javascript text/xml application/xml application/rss+xml application/atom+xml application/rdf+xml image/svg+xml;


   # ssl_certificate /etc/letsencrypt/live/autosalon-m.ru/fullchain.pem; # managed by Certbot
   # ssl_certificate_key /etc/letsencrypt/live/autosalon-m.ru/privkey.pem; # managed by Certbot
   # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
   # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

   # location ~ [A-Z] { return 307 $scheme://$host$my_uri_to_lowercase; }

location /.well-known {
    root /var/www/carso_staging/current/public;
}

     location / {

      proxy_pass http://carso_staging;
      #proxy_set_header Host $host:3000;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Ssl on;
    }


}

#server{
    #error_page 497 301 =307 https://www.$host$request_uri;
  #  return 301 http://$host$request_uri;
    #listen 443;
   # listen 80;
   # server_name carso.ru;
#}



-----------
sudo certbot --nginx -d carso.ru  -d www.carso.ru  -d astrakhan.carso.ru  -d balashiha.carso.ru  -d belarus.carso.ru  -d belgorod.carso.ru  -d bryansk.carso.ru  -d cheboksary.carso.ru  -d chehov.carso.ru  -d chelyabinsk.carso.ru  -d cherepovets.carso.ru  -d ekaterinburg.carso.ru  -d himki.carso.ru  -d irkutsk.carso.ru  -d ivanovo.carso.ru  -d izhevsk.carso.ru  -d kaluga.carso.ru  -d kazakhstan.carso.ru  -d kazan.carso.ru  -d kirov.carso.ru  -d kolomna.carso.ru  -d kostroma.carso.ru  -d krasnodar.carso.ru  -d krasnoyarsk.carso.ru  -d kursk.carso.ru  -d lipetsk.carso.ru  -d nn.carso.ru  -d novgorod.carso.ru  -d novosibirsk.carso.ru  -d obninsk.carso.ru  -d omsk.carso.ru  -d orekhovozuevo.carso.ru  -d orel.carso.ru  -d orenburg.carso.ru  -d penza.carso.ru  -d perm.carso.ru  -d podolsk.carso.ru  -d pskov.carso.ru  -d rostov.carso.ru  -d ryazan.carso.ru  -d samara.carso.ru  -d saransk.carso.ru  -d saratov.carso.ru  -d serpuhov.carso.ru  -d sevastopol.carso.ru  -d simferopol.carso.ru  -d smolensk.carso.ru  -d sochi.carso.ru  -d spb.carso.ru  -d stavropol.carso.ru  -d syktyvkar.carso.ru  -d tagil.carso.ru  -d tolyatti.carso.ru  -d tomsk.carso.ru  -d tula.carso.ru  -d tver.carso.ru  -d tyumen.carso.ru  -d ufa.carso.ru  -d ulyanovsk.carso.ru  -d vladimir.carso.ru  -d volgograd.carso.ru  -d vologda.carso.ru  -d voronezh.carso.ru


voskresensk.carso.ru dolgoprudniy.carso.ru domodedovo.carso.ru dubna.carso.ru egorievsk.carso.ru korolev.carso.ru krasnogorsk.carso.ru lobnya.carso.ru lyubertsy.carso.ru mytishchi.carso.ru naro-fominsk.carso.ru noginsk.carso.ru odintsovo.carso.ru pushkino.carso.ru ramenskoe.carso.ru reutov.carso.ru sergiev-posad.carso.ru stupino.carso.ru tambov.carso.ru elektrostal.carso.ru


----------------
sudo certbot --server https://acme-v02.api.letsencrypt.org/directory -d *.carso.ru -d carso.ru --manual --preferred-challenges dns-01 certonly

потом он тебе там предложит в днс написать текст. Пишешь его - и всё
иногда 2 раза просит