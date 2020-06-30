#!/bin/bash

echo "Checking database"
while [[ `echo "DB::connection()->getPdo();" | php artisan tinker` == *"SQLSTATE"* ]]
do
    echo -ne .
done
echo

php artisan migrate --seed --database=testing
php artisan key:generate 
php artisan migrate 
php artisan db:seed
php artisan serve --host 0.0.0.0
