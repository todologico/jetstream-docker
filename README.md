[![Jetstream Docker](https://raw.githubusercontent.com/todologico/jetstream-docker/main/laravel-jet.jpg)](https://github.com/todologico/jetstream-docker)

##  Laravel Jetstream with Inertia (Vuejs) - Docker - Ready to Install  
### Laravel 11 - Jetstream 5 - MariaDB - phpMyAdmin

**Non-Production Installation:**  

Clone the repository.  

Once located in the /jetstream-docker directory, run the following command in the console, which will create the "db" (MariaDB volume) and "src" (Laravel code) directories and start the containers for the three services..

**mkdir -p src && mkdir -p db && docker-compose up -d**  

Accessing the Container with a Non-Root User (appuser):

**su appuser**  
**composer require laravel/jetstream**  
**php artisan jetstream:install inertia**  
**npm install**  
**npm run build**  
**php artisan migrate**    

The Laravel container is accessible at http://localhost:89/

The phpMyAdmin container is accessible at http://localhost:99/

Database Access Configuration in the .env File (Automatically Inserted by the Entrypoint File):

DB_CONNECTION=mysql  
DB_HOST=jetlar-db  
DB_PORT=3312  
DB_DATABASE=jetlar  
DB_USERNAME=jetlar  
DB_PASSWORD=00000000  

**Commands with PHP Artisan Inside the Container:**

When building the container, a non-root user (appuser) is created, which you need to log in with inside the container. This user belongs to the www-data group, so it can execute artisan commands.  

To create this user, the following is added to the Dockerfile:

ARG USER_NAME=appuser
ARG USER_UID=1000
RUN useradd -u $USER_UID -ms /bin/bash $USER_NAME
RUN usermod -aG 1000 $USER_NAME
RUN usermod -aG www-data $USER_NAME

To run commands, access the container and switch to the user by running:

**docker exec -it jetlar bash**  

Then, list all users to verify that your user is active:

**cat /etc/passwd** 

Switch to the non-root user:

**su appuser**  

Verify that you can access artisan:

**php artisan**  

Alternatively, you can do this directly from inside the container:  

**docker exec -it jetlar bash**  
**adduser appuser**  
**usermod -aG www-data appuser**  
**id nuevo_usuario**  

This should display:  

uid=1000(appuser) gid=1000(appuser) groups=1000(appuser),33(www-data)

--------------------------------------

DB Connectivity Tests with Tinker

**docker exec -it oncelar php artisan tinker**  
**use Illuminate\Support\Facades\DB; DB::connection()->getPdo();**  

You can also run migrations and rollbacks, which will be displayed via phpMyAdmin. Inside the container, with the non-root user (appuser), run:

**php artisan migrate**  

To roll back:

**php artisan migrate:rollback**  



