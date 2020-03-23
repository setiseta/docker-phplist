FROM php:apache
LABEL MAINTAINER="seti@setadesign.net"

ENV PHPLISTVERSION="3.5.2"
ENV DB_HOST="db"
ENV DB_NAME="phplist"
ENV DB_USER="phplist"
ENV DB_PASSWORD="securepwd"
ENV TESTMODE="1"
ENV BOUNCE_PROTOCOL="pop"
ENV MAIL_HOST="localhost"
ENV MAIL_USER="newsletter@example.com"
ENV MAIL_PASSWORD="newsletterPassword"
ENV POP_PORTSETTINGS="110/pop3"
ENV SMTP_PORT="587"
ENV SMTP_SECURE="auto"
ENV LANGUAGE="english"
ENV LANGUAGE_SHORT="en"
ENV EMBEDEXTERNALIMAGES="true"

RUN curl -o /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    && chmod uga+x /usr/local/bin/install-php-extensions && sync \
    && install-php-extensions imap gettext mysqli gd

RUN curl -L https://sourceforge.net/projects/phplist/files/phplist/${PHPLISTVERSION}/phplist-${PHPLISTVERSION}.tgz/download -o /tmp/phplist-${PHPLISTVERSION}.tgz \
    && cd /tmp \
    && tar xf /tmp/phplist-${PHPLISTVERSION}.tgz phplist-${PHPLISTVERSION}/public_html/lists \
    && mv phplist-${PHPLISTVERSION}/public_html/lists/* /var/www/html/ \
    && mv phplist-${PHPLISTVERSION}/public_html/lists/.htaccess /var/www/html/ \
    && cd /var/www/html

RUN sed -i "s/\$database_host = .*;/\$database_host = getenv('DB_HOST');/g" config/config.php \
    && sed -i "s/\$database_name = .*;/\$database_name = getenv('DB_NAME');/g" config/config.php \
    && sed -i "s/\$database_user = .*;/\$database_user = getenv('DB_USER');/g" config/config.php \
    && sed -i "s/\$database_password = .*;/\$database_password = getenv('DB_PASSWORD');/g" config/config.php \
    && sed -i "s/define('PHPMAILERHOST', '');/define\('PHPMAILERHOST', getenv('MAIL_HOST'));/g" config/config.php \
    && sed -i "s/define('TEST', 1);/define\('TEST', getenv('TESTMODE'));/g" config/config.php \
    && sed -i "s/\$bounce_protocol = .*;/\$bounce_protocol = getenv('BOUNCE_PROTOCOL');/g" config/config.php \
    && echo "" >> config/config.php \
    && echo "/*" >> config/config.php \
    && echo "SMTP SETTINGS" >> config/config.php \
    && echo "*/" >> config/config.php \
    && echo "\$phpmailer_smtpuser = getenv('MAIL_USER');" >> config/config.php \
    && echo "\$phpmailer_smtppassword = getenv('MAIL_PASSWORD');" >> config/config.php \
    && echo "define('PHPMAILERPORT', getenv('SMTP_PORT'));" >> config/config.php \
    && echo "define('PHPMAILER_SECURE', getenv('SMTP_SECURE'));" >> config/config.php \
    && echo "" >> config/config.php \
    && echo "/*" >> config/config.php \
    && echo "POP SETTINGS" >> config/config.php \
    && echo "*/" >> config/config.php \
    && echo "\$bounce_mailbox_host = getenv('MAIL_HOST');" >> config/config.php \
    && echo "\$bounce_mailbox_user = getenv('MAIL_USER');" >> config/config.php \
    && echo "\$bounce_mailbox_password = getenv('MAIL_PASSWORD');" >> config/config.php \
    && echo "\$bounce_mailbox_port = getenv('POP_PORTSETTINGS');" >> config/config.php \
    && echo "" >> config/config.php \
    && echo "// Pageroot Settings" >> config/config.php \
    && echo "\$pageroot = '';" >> config/config.php \
    && echo "// Language Settings" >> config/config.php \
    && echo "\$language_module = getenv('LANGUAGE');" >> config/config.php \
    && echo "\$default_system_language = getenv('LANGUAGE_SHORT');" >> config/config.php \
    && echo "" >> config/config.php \
    && echo "/*" >> config/config.php \
    && echo "Div SETTINGS" >> config/config.php \
    && echo "*/" >> config/config.php \
    && echo "define('EMBEDEXTERNALIMAGES', getenv('EMBEDEXTERNALIMAGES'));" >> config/config.php

VOLUME /var/www/html/images