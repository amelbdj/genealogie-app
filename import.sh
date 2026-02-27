#!/bin/bash
# import.sh

sleep 10
php /var/www/html/scripts/import.php
exec apache2-foreground
