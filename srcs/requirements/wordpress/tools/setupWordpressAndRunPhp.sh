#!/bin/sh

#Go to the working directory
cd /var/www/html

#This if sentence should be true if wordpress was downloaded but not setted up.
if [ ! -f /var/www/html/wp-config.php ]; then

    #Download the Command line interface of Wordpress
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

    #Gives executing permissions to wp-cli.phar
    chmod +x wp-cli.phar

    #move the wp-cli.phar file to /usr/bin to have wp-phar in $PATH. Then rename it to wp.
    mv wp-cli.phar /usr/bin/wp

    #Execute wp to download the files.
    wp core download --allow-root

    #Manipulate the information inside wp-config-sample.php
    sed -i -r "s/database_name_here/$WORDPRESS_DB_NAME/1"   /var/www/html/wp-config-sample.php
    sed -i -r "s/username_here/$WORDPRESS_DB_USER/1"  /var/www/html/wp-config-sample.php
    sed -i -r "s/password_here/$WORDPRESS_DB_PASSWORD/1"    /var/www/html/wp-config-sample.php
    sed -i -r "s/localhost/$WORDPRESS_DB_HOST/1"    /var/www/html/wp-config-sample.php

    #Copy wp-config-sample.php file into wp-config.php
    cp wp-config-sample.php wp-config.php

    #Setting up wordpress
    var=1
    echo "CREATING USER IN DATABASE"
    while [ $var -lt 20 ]; do
        wp core install --url=$DOMAIN_NAME \
                        --title=$WORDPRESS_TITLE \
                        --admin_user=$WORDPRESS_DB_USER \
                        --admin_password=$WORDPRESS_DB_PASSWORD \
                        --admin_email=$WORDPRESS_DB_USER_EMAIL \
                        --skip-email \
                        --allow-root
        if [ $? -eq 0 ]; then
            echo ""
            echo "USER CREATED SUCCESSFULLY."
            break
        else
            echo ""
            echo "THE CONTAINER WITH THE DATABASE IS NOT READY YET. TRYING AGAIN AFTER 5 SECONDS. TRY NUMBER $var"
            var=$((var + 1))
            sleep 5
        fi
    done
    if [ $var -eq 20 ]; then
            echo ""
            echo "TOO MANY TIMES TRYING TO CONNECT TO THE DATABASE."
            exit 1
    fi
    #Create a user for wordpress
    wp user create  $WORDPRESS_DB_USER \
                    $WORDPRESS_DB_USER_EMAIL \
                    --role=author \
                    --user_pass=$WORDPRESS_DB_PASSWORD \
                    --allow-root

    #Install a theme
    wp theme install inspiro --activate --allow-root

    chown -R www-data:www-data /var/www/html

fi

#start PHP-FPM v8.1
php-fpm81 -F