#!/bin/bash
# import.sh
echo "Pause de 10s pour laisser Mongo démarrer..."
sleep 10
php /var/www/html/scripts/import.php
exec apache2-foreground