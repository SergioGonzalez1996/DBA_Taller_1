# Punto 8: Análisis de Artículos.  

Uno de los objetivos del taller es analizar algunos artículos en Internet, esta vez, enfocados a que cualquier persona sin estar en el medio pueda entender de qué se trata. 

1.	https://eng.uber.com/mysql-migration/  
2.	http://highscalability.com/blog/2017/12/11/netflix-what-happens-when-you-press-play.html
3.	https://medium.com/advisability/tarjetas-credito-rappi-714e75166f7a
4.	https://blog.timescale.com/why-sql-beating-nosql-what-this-means-for-future-of-data-time-series-database-348b777b847a

## 1.	Why Uber Engineering Switched from Postgres to MySQL

Todos conocemos el servicio que Uber nos ofrece, y aunque parezca facil hay un mundo detras de todo eso, anteriormente ellos usaban Postgres para la persistencia de datos, pero ya ha cambiado mucho, y es que con esta arquitectura encontraban muchas limitaciones, como dificultad para ctualizar a nuevas versiones o incluso tuvieron problemas con la corrupcion de las tablas, y es que cuando uno busca implementar una Base de datos almenos deberia de realizar unas tareas claves, como es la insercion de datos, o la capacidad para hacer cambios o incluso la eliminacion de un dato, y es por esto que Uber tuvo muchos problemas con Postgres uno por ejemplo tenian problemas cuando iban a escribir unos cuantos bytes se convertia en algo muy costoso por que primero tenia que escribir una nueva tupla, luego que actualice el indice de la clave principal, despues que actualice el nodo del arbol,  y todo esto para ingresar un solo registro de unos cuantos bytes entonces lo que principalmente era una actualizacion se convirtieron en 3 o 4. esto por un lado ahora con la corrupcion de datos, las replicas en postgres 9.2 tuvieron cambios de linea de tiempo incorrecta, lo que provoco que una inconsistencia en los datos, se dieron cuenta por que hicieron una consulta para traer dos registros pero devolvian dos tuplas cada una con dos filas distintas de datos, y esto fue un problema muy grande por que no se podia ver facilmente a cuantas filas afecto, y los resultados duplicados devueltos de la base de datos hicieron que la logica de la aplicacion fallara en varios casos, pero luego pudieron solucionar el problema corrigiendo el error y sincronizando las tablas con un maestro. Ahora despues de todo lo que paso, empezaron con la arquitectura de MySQL que es una herramienta super importante para los nuevos proyectos de almacenamiento de Uber, y es que MYSQL es el mas popular, una de las diferencias mas importantes es que mientras Postgres mapea directamente los registros de indice a las ubicaciones, InnoDB mantiene una estructura secundaria, en vez de mantener un puntero a la ubicacion, por lo tanto un secundario en MySQL asocia claves de indice con claves primarias, y claramente se puede ver las ventajas de cada uno, ahora MySQL tambien soporta multiples modos de replicacion diferentes, que son basada en declaraciones y suele ser la mas compacta, en MySQL solo el indice primario tiene un puntero a las compensaciones de filas, y finalmente la arquitectura de MySQL hace que sea mas facil, y eso que entre otras ventajas es que centraron la arquitectura en la parte buena de Postgres y la unieron con la de MySQL y gracias a esto pues hacen que se desempeñe siginificativamente. en conclusion Postgres sirvio bien en los primeros dias de Uber, pero a medida que el camino fue avanzando se encontraron con uns problemas muy importantes, hoy en dia tienen algunas instancias de Postgres heredadas, pero la mayoria de la base de datos estan construidas sobre MySQL, o en algunos casos tambien en bases de datos NoSQL, en general estan bastantes contentos con MySQL y es posible que en el futuro tengan muchos mas desarrollos y que historias mas contarnos.



Opinion critica: 
Pienso que Uber es una compañia muy grande, y esta bien que algunas compañias al comienzo de sus dias cometan algunos errores, y es que es lo mas comun, y tambien es bueno que se aprendan de esos errores y se mejoren las cosas, pero pienso que no deberian de depender 100% de una base de datos especifica, osea que por que Postgres no funciono con ellos y MySQL si, se tienen que centrar en MySQL, no me parece, por que el dia de mañana van a seguir creciendo y creciendo y algun dia su logica de negocio puede dar algun cambio y depronto MySQL ya no va ser tan rentable pero que va pasar, hasta la fecha tenian todo en MySQL, y cambiar todo eso que tenian para alguna otra que se acomode a sus necesidades va a ser algo tedioso, entonces mi opinion es deberian de dividir todo lo que tienen en varias Bases de datos que se acomoden especificamente a lo que necesitan, ademas creo que seria mas optimo.


## 2.	Netflix: What Happens When You Press Play?

Netflix es una plataforma que proporciona peliculas y series a miembros que pagan mensualmente una suscripcion. suena sencillo pero es una empresa enorme, a nivel global y tienen muchos miembros, muchos videos y mucho dinero. Aparte de esto hay una infraestructura enorme que orquesta infinidades de cosas cuando presionas "Play", y ademas es un servicio que es mejor que funcione, por que si no, los miembros infelices se dan de baja. Entonces la pregunta es, ¿que sucede detras, cuando presionas play?. Netflix le paga a AWS y Open Connect para que ellos les alquilen muchos servidores donde pueden guardar las peliculas y las series, tambien pagan servidores para guardar la informacion personal de cada uno de sus miembros, ademas de eso tambien pagan por una base de datos en donde almacenan mucha informacion de gustos de peliculas, donde y cuando viste una pelicula, que pelicula viste y dejaste de ver, esta y mucha mas informacion la guardan para planear sus estrategias de negocio, y esto es conocido como Big data, Netflix ofrece sus servicios en todo el mundo pero los servidores los tiene en 3 regiones estrategicas, no quieren espandir mas regiones por que es demaciado costoso mantenerlas, y ellos dicen que estas 3 son suficientes, ademas que sin querer queriendo descubrieron un metodo para no dejar de transmitir en caso de que algo fallara, y es que si tu estas viendo una pelicula y se caen los servidores de la region donde estabas conectado, automaticamente tus dispositivos se enlazan a una de las otras dos regiones, y asi podras disfrutar de netflix sin experimentar ninguna falla, ademas de esto netflix personaliza imagenes de las peliculas, y recogen un monton de datos de las imagenes que mas recibieron clicks, y dejan esta imagen de portada de la pelicula. todo esto y mucho mas lo hacen como estrategia para que tu sigas viendo series y peliculas y sigas pagando tu membresia mes a mes, ahora cuando quieres ver una pelicula hay un intermediario que analiza que el video este en optimas condiciones, y no falten cuadros de imagenes, o que la imagen sea de alta calidad, pero que pasa cuando muchos usuarios estan haciendo esa misma peticion al mismo tiempo?, pues netflix maneja algo llamado paralelismo, se explica muy bien con el siguiente ejemplo, Digamos que tienes cien perros sucios que necesitan lavado. ¿Cual seria mas rapido, una persona lavando a los perros uno tras otro? ¿O seria mas rapido contratar cien lavadores de perros y lavarlos todo al mismo tiempo?. Obviamente, es mas rapido tener cien lavadores de perros trabajando al mismo tiempo. Eso es paralelismo. Y es por eso que Netflix usa muchos servidores. Necesitan muchos servidores para procesar estos enormes archivos de video en paralelo. y el resultado es un video claro, nitido y acorde a lo que el usuario esta pagando, como muchas empresas Netflix empezo desde abajo, rentando DVD pero a medida que iba pasando el tiempo supieron que el futuro era estar en internet, entregar videos de forma virtual, cometieron muchos errores pero supieron aprender rapido de ellos y a diseñar metodos y estrategias que hoy por hoy los han llevado a ser una de las plataformas con mas horas de video reproducidas en un dia. eso sin contar que fisicamente es grande y es que si vemos los servidores que tiene en AWS, son muchos, muchos cables, muchos ISPs y IXPs, pero ellos no se tienen que preocupar por nada de eso por que para eso ellos estan pagando, ellos solo se preocupan por entregar videos online a miembros que pagan por ello, y pues hasta el momento les ha funcionado muy bien.

Opinion critica: Esta bien que usen 3 regiones para ofrecer su servicio a todo el mundo, y esta bien que en cada una de esas regiones se guarde la misma informacion en diferentes servidores para garantizar que no se pierdan, o que si el servicio te falla en una region te conectes a otra y esa otra tenga toda tu informacion tambien, pero creo que asi consumen mucho recurso y no optimizan bien las cosas, y es que estan multiplicando todo por 3. Yo pensaria que si tuvieran un servidor central en donde este entregue la informacion que se requiere seria mucho mas optimo, ademas el recopilar informacion de los gustos de pelicula, o cuando y donde y por que vemos una pelicula o no vemos otra pelicula, me parece que es algo que se puede prestar para muchas cosas, pienso que la informacion de que pelicula veo es personal y nadie mas deberia de saberlo, se que es un tema demaciado polemico pero es mi punto de vista.


## 3.	Fallas graves en la seguridad de tarjetas de crédito y credenciales en Rappi

Este año, cerca al 20 de septiembre fue solucionada una grave falla en la seguridad de las tarjetas de crédito y en las credenciales de Rappi que tardo 61 días en solucionarse. ¿Pero de que iban estás fallas?

Aparentemente, era posible obtener datos parciales de las tarjetas de crédito y había fallas de seguridad para el inicio de sesión en la aplicación. Por lo tanto, agentes externos podían usar las tarjetas de créditos para hacer compras no autorizadas.

Todo comenzó con reportes por Twitter de usuarios de diferentes países que reportaban la aplicación por ser insegura ya que habían realizado compras de pedidos a su nombre por valores de hasta $1,000,000 pesos colombianos, pedidos que obviamente ellos no habían realizado.

Es por eso por lo que siempre que hablamos de compras por internet se nos dan algunos concejos, como buscar un candado en la barra de navegación o la palabra “Seguro”, cualquier cosa que nos pueda indicar que la página cuenta con protocolos de protección a nuestros datos… Pero para las tarjetas de créditos, esto es un poco más complicado.

Debido a que existe la necesidad de estandarizar y mejorar la protección sobre los datos se creó una alianza entre los mayores emisores de tarjetas de créditos del mundo, dicha alianza publica creo el estándar PCI DSS (Que por sus siglas en ingles significa, “estándar de seguridad de datos en las industrias de pago”), así que todos los comercios que acepten tarjetas deberán usar dicho estándar. 

¿Y cómo es eso de la certificación en PCI DSS?

Esta se puede conseguir por autoevaluación, el cual es preferido por la mayoría, o por contratar un tercero consultor, aunque el primero depende de la cantidad de transacciones anuales (hasta 6 millones de transacciones anules). Existen 4 niveles de PCI y dependiendo de las transacciones anuales se asignará un nivel. Pero no es tan fácil, también se debe llenar un cuestionario que dependerá de como funcionen los servidores de comercio respecto a las tarjetas.

La mayoría de los comercios opta por autoevaluarse y no tocar ni procesar los datos de las tarjetas de crédito, para estos fines prefieren usar servicios de terceros de procesadores de pagos para que ellos se encarguen de todo este proceso de realizar cargos y reembolsos. De esta forma los datos nunca pasarán por el servidor de comercio y el procesador de pago se encargará de notificar al comercio cuando un pago es exitoso.

Dato curioso: De acuerdo con Rappi, sólo en Bogotá tienen 10mil transacciones al día, eso daría más o menos 4 millones anuales, lo cual indica que deberán tener mínimo un nivel 2 de PCI, o quizás mayor. 

Regresando al caso de Rappi, tenemos que estos usan servicios de Spreedly, el cual es un servicio de procesamiento de pagos y almacenamiento con estándar PCI de Nivel 1. Este funciona mediante “Tokenización”, generando identificadores (llamados tokens) los cuales consisten en que el procesador de pagos, siguiendo altísimos estándares de seguridad, guardará de forma segura los datos de nuestra tarjeta, en un compartimiento seguro, que no es accesible por el comercio y devolverá un identificador único (token) que luce, como un código alfanumérico (tipo H7FdKWKPOPhepzxS4MfUuvTDHxr). Rappi recibe ese identificador para almacenarlo y asociarlo con la cuenta. 

Los identificadores (tokens) es único dentro del compartimento y no tiene validez fuera de él. Sólo usando una contraseña podemos realizar operaciones con ellos. Sí por alguna razón Rappi fuera vulnerado no pasará gran cosa puesto que ellos no tienen los datos completos de la tarjeta. 

Cuando se hace una transacción, Rappi, usando su contraseña del compartimiento seguro envía ese identificador y la operación a su procesador de pagos para hacerlo sobre la tarjeta asociada al token. De esta forma, se harán operaciones y cargos a una tarjeta sin conocer todos los datos y sin solicitarlos siempre.

Sin embargo, la contraseña del compartimiento debe ser muy bien protegida. Sí alguien la conoce podrá realizar cargos arbitrarios sobre las tarjetas almacenadas y conocer información parcial de la tarjeta y el dueño. Esto era lo que Rappi no estaba haciendo bien.

¿Entonces cuáles eran las fallas?

Pues bien, Rappi optó por incluir los datos de las tarjetas en sus servidores, aunque estos posteriormente fueran enviados al procesador de pagos incrementa la exposición de los datos y pone mayor exigencia para los cuestionarios de PCI. Rappi no usó los mecanismos recomendados por procesador de pago.

Pero dejando eso de lado, Rappi también cometió graves fallas en el código. No usaron métodos recomendados de recolección de tarjetas, por lo cual, violaron todos los cuestionarios y nivel de estándar PCI, lo cual se advierte ampliamente en la documentación del procesador de pagos. 

En resumidas cuentas, estaban haciendo solicitudes para agregar tarjetas al compartimiento seguro, con un método diseñado exclusivamente para servidores protegidos… Pero lo hacían desde el navegador de sus clientes. Es por ello por lo que incluían credenciales del compartimiento en el código de la pagina web, estando expuesto a cualquier persona que cargué la pagina web.

El problema radica en que esas credenciales permiten conocer información de todas las tarjetas almacenadas, así como los identificadores y realizar cargos u otras operaciones sobre ellas. Como si fuera poco, en su código también incluían credenciales privadas para iniciar sesión en Facebook y otras cuentas.

Cualquier persona podría simplemente entrar a su sitió web, pulsar clic derecho en cualquier lugar en blanco, hacer clic en “Inspeccionar”, ir a la pestaña “sources” y encontrar toda esta información, que supone, debe ser privada.

¿Qué datos se podían conocer con la información que se podía obtener?

Con los datos que se obtenían antes, se podía conocer mucha información y realizar varías operaciones con todas las tarjetas almacenadas en el compartimiento seguro, tales como los últimos 4 números de la tarjeta, los primeros 6, el correo electrónico del usuario, nombres, apellidos, año y mes de expiración de la tarjeta de crédito, direcciones, ciudad, país, zip code y demás.

¿Cómo se pudo explotar estas fallas?

Sólo con unas cuantas solicitudes al procesador de pagos por parte de un atacante quien previamente notó este falló, se puede obtener los identificadores de todas las tarjetas almacenadas, así como datos parciales de los clientes. 

Debido a la mala arquitectura y malas prácticas de Rappi un atacante pudo ejecutar un tipo de ataque sobre las tarjetas de créditos. Luego, con un identificador válido podría asociarlo con el que representa la tarjeta de crédito de un tercero y realizar transacciones desde su cuenta u otra, con cargo a la tarjeta de esta persona.

Aunque los Identificadores no están diseñados para no ser adivinados fácilmente, obtener identificadores validos no sería difícil ya que la página de Rappi incluía las credenciales del compartimiento seguro, donde se obtenía prácticamente toda la información necesaria.

A la final, ¿cómo se solucionó el problema?

Como ya lo hemos dicho, Rappi solucionó el problema tardo 61 días en solucionar la falla. 42 días para eliminar las credenciales de un archivo de su página y 19 días más, puesto no habían cambiado las credenciales antiguas y el atacante aún podía tener acceso al compartimento seguro, seguir obteniendo identificadores y hacer más recargos sobre las tarjetas.

¿Y ahora que hace Rappi con las tarjetas?

Pues, en general, modifico la arquitectura del procesamiento de tarjetas para seguir las exigencias del estándar PCI DSS.


## 4.	Why SQL is beating NoSQL, and what this means for the future of data

Después de muchos años de que SQL fuera dado por muerto, hoy, esta haciendo un regreso. ¿Cómo es eso? ¿Qué efecto tendrá en la comunidad de datos?

Antes de comenzar, aclaremos que es SQL: Structured Query Language, o en español: Lenguaje de Consulta Estructurada. 

Desde los inicios de la computación hemos estado almacenando gran cantidad de datos, incluso buscando y pidiendo más espacio para almacenar nuestros datos, más capacidad de procesamiento y más capacidad de análisis. Eso provoco que en la década pasada los desarrolladores preferirían optar por otras alternativas, puesto que con SQL no era posible escalar el sistema con los datos en gran crecimiento, lo cual hizo que los sistemas NoSQL sugieran. 

Aún así, el día de hoy SQL esta resurgiendo. Casi todos los mayores proveedores de la nube están volviendo a ofrecer base de datos relacionales, como amazon, Google cloud o azure. 

Parte 1.

Para entender por qué SQL está volviendo tenemos que ver cómo y por qué se diseñó.

Para eso tenemos que regresar a los 70s, cuando una investigación de IBM sobre base de datos relacionales nació. En esos tiempos son lenguajes de consultas confiaban en complejos algoritmos matemáticos. Se dieron cuenta de que estos lenguajes de programación serían un cuello de botella, así que se dieron a la tarea de crear uno que fuera más accesible a los usuarios sin una enseñanza formal en matemática o programación de computadores. 

Sólo pensemos en esto: hace tanto tiempo, antes de que el internet fuera algo, antes de la PC, se dieron cuenta que el éxito de la industria dependerá más de los usuarios. Ellos querían un lenguaje de consulta fácil de leer en ingles que haría mejor la administración y manipulación de la base de datos y ese resultado fue SQL. 

SQL se introdujo por primera vez en 1974, poco a poco probó ser demasiado popular mientras cada vez se creaban más motores de base de datos relacionales como Oracle, SQL Server, MySQL y otros más tomaron la industria. Por aquel entonces, SQL se volvió el dominante.

Parte 2. No hay respuesta de NoSQL.

Mientras se hacía SQL, no se dieron cuenta que otro grupo en California estaba trabajando en otro proyecto similar que daría vida a ARPANET, el cual nació en 1969. Y todo está bien con SQL, hasta que se inventó la Web, en 1989. 

El Internet creció rápidamente por todo el mundo en incontables formas, pero creo un problema para las comunidades de datos: muchas fuentes creando mucho volumen de datos. Mientras el internet crecía, la comunidad se dio cuenta de que las bases de datos relacionales (SQL) no podrían soportar toda esta nueva carga.

Ya para los 2000, se crearon más motores de base no relaciones (NoSQL) como MapReduce, Bigtable, Dynamo y MongoDB. Debido a que estos sistemas nuevos, estaban escritos desde 0, evitaban el SQL, lo cual llevo al surgimiento del movimiento NoSQL.

Aún con sus ventajas, los desarrolladores se dieron cuenta que no tener SQL era un poco limitante. Cada base de datos NoSQL tenía su propio lenguaje de programación, lo que implica más lenguajes para aprender, más dificultades a integrar la base de datos a las aplicaciones y además de que esos lenguajes NoSQL, al ser nuevos, no estaban del todo desarrollados. Incluso algunos intentaron hacer lenguajes similares al SQL, lo cual fue contra producente, puesto no se sabía que era soportado y que no.

Parte 3. Regreso del SQL.

Entonces llego lo que llamaron NewSQL. Nuevas bases de datos escalables que aceptan y se integran totalmente al SQL. Lentamente, las comunidades SQL comenzaron a revivir, añadiendo algunas características necesarias para el paradigma actual y mejorando el soporte para particionamiento y replicación.

A manera de ejemplo, algunas compañías que desarrollaban en TimeScaleDB que pensaron usar completamente el NoSQL tuvieron tantos problemas creando su propio lenguaje de programación y adaptando todo a sus necesidades que terminaron por regresar a SQL, comentando que “un nuevo mundo de posibilidades se abrió frente a ellos”.

Vivimos en un mundo donde los datos se están convirtiendo en el 	recurso con más valor, como resultado de ello, hemos visto la explosión de cantidad de herramientas especializadas para las bases de datos, con fines de analizar o procesar información. 
Y así, es como SQL se ha convertido en una interfaz mundial, que prácticamente podemos comprar con el protocolo IP. Pero en efecto, SQL es mucho más que IP, por que los datos son analizados por humano, puesto ese fue el propósito de los creadores de SQL, hacer que fuera leíble.

SQL no es perfecto, por su lenguaje es conocido por casi todos en este entorno y mientras que hay ingenieros trabajando en más lenguajes de programación con interfaces más naturales, esos lenguajes, estarán conectados a SQL.

SQL regreso.

No sólo por que usar NoSQL puede ser incomodo, no sólo por que aprender nuevos lenguajes para nuevos motores de bases de datos es difícil, no sólo porque los estándares son algo bueno, si no por que el mundo está lleno de datos que nos rodean día a día. Al inicio nos fiábamos de nuestros sentidos para procesar información y ahora nuestros sistemas son lo suficientemente inteligentes para ayudarnos. Cada vez tenemos más datos para medir nuestro mundo y más complejidad en nuestros sistemas para almacenar, procesar analizar y  visualizar esos datos que sólo seguirán creciendo. 
