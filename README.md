# docker-phplist
Docker Container with phplist

## Environements(with default value):
- DB_HOST="db"
- DB_NAME="phplist"
- DB_USER="phplist"
- DB_PASSWORD="securepwd"
- TESTMODE="1"
  - Set to "0" to activate Mailing
- BOUNCE_PROTOCOL="pop"
- MAIL_HOST="localhost"
- MAIL_USER="newsletter@example.com"
- MAIL_PASSWORD="newsletterPassword"
- POP_PORTSETTINGS="110/pop3"
- SMTP_PORT="587"
- SMTP_SECURE="auto"
- LANGUAGE="english"
- LANGUAGE_SHORT="en"
- EMBEDEXTERNALIMAGES="true"

## docker-compose example (with jwilder nginx not in same compose):
- network 'frontend' is where nginx reverse proxy connects
- network 'mail' is where mail system is, if its not on docker remove it.
- you may need to change permissions on data/images.

```
version: '2'
services:
  db:
    image: mariadb
    restart: always
    environment:
      - "MYSQL_ROOT_PASSWORD=mysecurerootpwd"
      - "MYSQL_DATABASE=phplist"
      - "MYSQL_USER=phplist"
      - "MYSQL_PASSWORD=securepwd"
    volumes:
      - ./data/mysql:/var/lib/mysql

  phplist:
    image: seti/phplist
    restart: always
    environment:
      - "VIRTUAL_HOST=myphplistdomain.example.com"
      - "LETSENCRYPT_HOST=myphplistdomain.example.com"
      - "LETSENCRYPT_EMAIL=me@example.com"
      - "DB_PASSWORD=securepwd"
      - "MAIL_HOST=mail.example.com"
      - "MAIL_USER=newsletter@example.com"
      - "MAIL_PASSWORD=mysecurenewslettermailpassword"
      - "LANGUAGE=german"
      - "LANGUAGE_SHORT=de"
      - "TESTMODE=0"
    volumes:
      - ./data/images:/var/www/html/images
    networks:
      - default
      - frontend
      - mail

networks:
  frontend:
    external: true
  mail:
    external: true
```
