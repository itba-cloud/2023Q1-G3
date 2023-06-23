# Cloud-TP3-Terraform: SMARTPAGER
Trabajo Práctico nro. 3 para la materia Cloud Computing 2023 1C - G3

## Módulos

### Módulo certificates

Módulo utilizado para la generación de un certificado SSL/TLS para el dominio. Se solicita el certificado y se generan los registros necesarios en Route 53, ya que el modo de validación es por DNS.
    
### Módulo dns

Módulo para crear los registros en Route 53 que exponen a la CDN.

### Módulo cdn

Módulo para la configuración de la CDN: CloudFront. Se definen los orígenes de datos: el sitio web estático (S3) y el API Gateway. También se definen políticas de caching y enrutamiento de tráfico.

### Módulo lambda

Módulo para definir las distintas funciones lambda que se utilizarán para manejar la lógica de la aplicación. Dado que se optó por una arquitectura serverless, el servicio de computo utilizado será AWS Lambda. Este módulo requiere diversas variables. Dentro de estas variables, algunas de entre ellas son propias de la función mientras que otras son necesarias para la integración con el API Gateway de donde serán accedidas. Asimismo, para generar las lambdas, se deben definir policies correspondientes. Para ello, se define un security group propio a las lambdas.

### Módulo api_gw 

Módulo para levantar el API Gateway que se encarga de exponer las funcionalidades de las distintas lambdas creadas a través de endpoints REST. Recibe los hashes de los recursos que utilizan los endpoints attachéados para que, en el caso de que cambien, se redeploye. Además, está configurado para que en caso de redeployar primero se levante la nueva versión y luego se borre la vieja, para llevar el tiempo de inactividad al mínimo y evitar errores.

### Módulo api_gw_lambda_integration
    
Módulo que se encarga de instanciar y attachear al API Gateway los endpoints que llaman a las lambdas.

### Módulo static_website

Módulo de configuración del sitio estático. Se utilizan 3 buckets en S3: 
www -> smartpager.com.ar -> logs

Los buckets son privados, utilizando la configuración determinada de bloqueo de acceso público de S3, que a partir de abril de 2023 Amazon aplica a todo bucket nuevo. Estos valores predeterminados son las prácticas recomendadas por Amazon para proteger los datos en S3.

Se configuro la definición de los buckets, junto con la subida de archivos. 

El sitio estático es únicamente accedido mediante la CDN, que accede al sitio estático a través del bucket www, que a su vez redirige los pedidos al bucket smartpager.com.ar que contiene los objetos del sitio. Para esto se utiliza el listado de origin access identity, dándole permiso de acceso a la CDN.

Para subir los archivos, el módulo recorre todos los archivos dentro de un path especificado y los sube a S3 con su MIME type correspondiente.
    
### Módulo vpc

El módulo se utiliza para definir los componentes de networking: VPC y subredes.

Se especifica un CIDR para la VPC, y se crean subredes en distintas Availability Zones teniendo en cuenta el mismo.


## Componentes

- **Route53 + ACM:** Implementados en los módulos dns y certificates respectivamente.

- **S3 - frontend:** Módulo static_website, utilizamos el módulo externo: 
[terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).

- **CloudFront:** Implementado en el módulo cdn propio.

- **Networking (VPC + SUBNETS):** Módulo vpc, utilizamos el módulo externo: [terraform-aws-modules/s3](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest).
 
- **Lambda:** Implementado con módulos propios api_gw_lambda_integration y lambda, implementamos las siguientes funcionalidades mockeadas: 
  - **GET /get_queue_size:** Devuelve el número de reservas dado un restaurant_name.
  - **GET /get_menu:** Devuelve el presigned url menú (public menú url) de un restaurant_name dado.
  - **GET /upload_menu:** Devuelve el presigned url de un restaurant dado para subir el menú. Deberia estar conectada con cognito para autenticar el request.
  - **POST /add_to_queue:** Simula la reserva de un cliente en un restaurant_name dado.


- **API Gateway:** Implementado en módulos api_gw y api_gw_lambda_integration, ambos propios.


![alt text](https://github.com/AgustinNaso/Cloud-TP3/blob/main/TP3-DIAGRAMA.png?raw=true)


## Funciones

- **slice:** se utiliza en el módulo VPC para obtener los primeros n nombres de AZs en la región, segun una variable de cantidad de AZs que se quieren usar. De esta forma se crea prográmaticamente, un listado de AZs segun la variable especificada.

- **cidrsubnet:** junto con un for, por cada AZ que se utilizará (calculado con el slice), se crea una subred privada utilizando el CIDR de la VPC y la posición en el listado de AZs. De esta forma en un solo ciclo se crea prográmaticamente segun las variables el CIDR de cada subred solicitada. Utilizado en el módulo VPC.

- **filemd5:** utilizado en el módulo static_website para obtener un hash del objeto a subir y asignarlo como su etag, valor utilizado para caching condicional. Si cambia el objeto cambiará su hash, por lo que su etag será distinto, indicando que la cache debe ser actualizada.

- **sha1:** utilizado en el módulo api_gw_lambda_integration para generar el hash de los recursos  attacheados al API Gateway para cada lambda con el fin poder redeployarlo en caso de que alguno de estos cambie. 

- **fileset:** se utiliza en el módulo static_website para recorrer el directorio de recursos para el sitio estático, obteniendo los archivos de una determinada extensión. Se utiliza con un for para iterar por todos los tipos de extensión.

- **flatten:** se utiliza en el módulo static_website para unificar la lista de listas de nombre, tipo de archivo en una única lista para trabajar más comodamente al subir los objetos.


## Meta-Argumentos

- **for_each:** Se utilizó este argumento para iterar por listas, como por ejemplo en la creacion de los CIDR para cada subred o en la subida de cada archivo en el directorio de recursos.

- **depends_on:** Se utilizó este argumento para el manejo de dependencias, como por ejemplo el record www respecto al record del dominio base en route 53, y en el api gateway para casos como la creacion de permisos de una lambda y la lambda en si.

- **lifecycle:** se utilizó este argumento para definir que recursos como el certificado en ACM o el API gateway se creen antes de destruirse (el default es que se destruyan primero y luego se creen), para prevenir asi posibles errores al recrear recursos que los referencian.


## Obteniendo el certificado para: smartpager.com.ar

 - Se compro el dominio smartpager.com.ar en el sitio donweb.com
 - Se le asignaron los NS records de la hosted zone creada en una de nuestras cuentas de AWS

![alt text](https://github.com/AgustinNaso/Cloud-TP3/blob/main/donweb.png?raw=true)

 - Se le asigno un certificado mediante ACM, levantando el mismo con terraform

![alt text](https://github.com/AgustinNaso/Cloud-TP3/blob/main/certificado.png?raw=true)

![alt text](https://github.com/AgustinNaso/Cloud-TP3/blob/main/smartpager.png?raw=true)



## Rúbrica

|  Alumno                |  Legajo  |  Participación  |
|------------------------|----------|-----------------|
|  Gastón De Schant      |  60755   |       25%       |
|  Federico Gustavo Rojas|  60239   |       25%       |
|  Brittany Lin          |  60355   |       25%       |
|  Agustín Naso          |  60065   |       25%       |


