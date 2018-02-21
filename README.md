**Este repositorio forma parte del taller del Meetup de WordPress Zaragoza celebrado el 21/02/2018 en Etopia**

# Creacion de la imagen para wordpress

1. Clonar el repositorio en una carpeta temporal para compilar la imagen de docker
2. Copiar el script wp_init a /usr/local/bin/wp_init
3. Dar permisos de ejecución chmod +x /usr/local/bin/wp_init
4. Compilar con el comando docker build . -t repositorio/apache-php:7.1
5. Situarnos en un nuevo directorio de nuestro servidor web para ejecutar el wordpress
6. Iniciar el proyecto con el comando wp_init
7. Seguimos las instrucciones y deberiamos tener un wordpress funcionando localmente.

# Proximas ejecuciones

Solo nos tendriamos que situar en la carpeta del nuevo proyecto y usar el comando wp_init