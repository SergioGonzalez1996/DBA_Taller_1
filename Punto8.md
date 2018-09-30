# Punto 8: Análisis de Artículos.  

Uno de los objetivos del taller es analizar algunos artículos en Internet creados con el fin de ayudar a las personas a entender como manejar mejor sus bases de datos. En este archivo usted podrá encontrar el análisis de cada uno de los integrantes del equipo.  

1.	https://blog.codinghorror.com/maybe-normalizing-isnt-normal/  
2.	https://blog.codinghorror.com/who-needs-stored-procedures-anyways/  
3.	http://highscalability.com/blog/2015/3/4/10-reasons-to-consider-a-multi-model-database.html  

El primer análisis fue por Sergio González, el segundo por Manuel Chaverra y el tercero por Juan Gómez.  

## 1.	Maybe Normalizing Isn’t Normal

El articulo publicado hace aproximadamente 10 años nos habla sobre la normalización, ¿es esta realmente necesaria? ¿los sistemas de base de datos bien diseñados están siempre normalizados?  

Pues la verdad sobre esas preguntas puede ser un poco controversial. La normalización, con toda seguridad, evitará unos cuantos problemas, casi tantos como los que quizás va a crear.  

En el ejemplo que el autor nos presenta sobre un modelo de base de datos de una red social genérica la cual esta totalmente normalizada, requiere al menos 6 Joins para mostrar toda la información de tan sólo 1 usuario, lo cual, no ayudará para nada al rendimiento de nuestro equipo, además de que un modelo completamente normalizado podría ser más difícil de entender y mas difícil de trabajar, eso sin contar que podría ser más lento.  

Posteriormente y a manera de comparación el autor nos muestra esa misma base de datos, pero completamente desnormalizada. Esto hará las Consultas mucho más simples y más rápidas, pero tendremos el problema de que habrá muchos espacios en blanco en nuestros datos y que tendremos gran cantidad de columnas repetidas, lo cual causará problemas con la integridad de nuestros datos.  

Para este punto, mucha gente se estaría preguntando: ¿entonces cual es la mejor solución para nuestra base de datos? El autor simplemente nos ha dicho que, en realidad, no importa.  

Lo que en realidad importa es cuantas filas tendrás en tu base de datos. No habrá una diferencia de rendimiento realmente notoria a menos de que tu base de datos tenga millones de filas. Una computadora simple de hoy en día fácilmente puede lidiar con una base de datos desnormalizada o normalizada sí la cantidad de datos no es tan abismal.   

En realidad, por lo que nos deberíamos preocupar no es “por que tan escalable será nuestro sistema” sí no en el como hacer que a la gente le importe. Para empezar, lo mejor sería hacer un diseño simple que nosotros podamos entender fácilmente y así trabajar con el siempre, lo cual, nos lleva a que podemos, parcialmente, desnormalizar donde tenga sentido y normalizar completamente donde no tenga.  

Muchas personas simplemente normalizan porque les han dicho que deben hacerlo, pero la realidad es que sólo se debería normalizar cuando los datos te lo indican.  

Incluso, al final el Autor nos dice que: “Normaliza hasta que duela, desnormaliza hasta que funcione”.  

## 2. Who Needs Stored Procedures, Anyways?

¿Son necesarios los procedimientos almacenados (a partir de este momento se mencionarán como PA) en la base de datos? Esta es, en esencia, la pregunta que el autor nos plantea en su artículo.  

En el artículo, el autor nos menciona, entre varias cosas, que típicamente los PA no pueden ser debuggeados desde el mismo IDE en donde estamos trabajando la interfaz de usuario, por lo que es necesario abrir nuestro administrador de base de datos y cargar los paquetes que conforman la base de datos para poder revisar que es lo que está causando problemas. Esto, visto desde el punto de vista del desarrollo, es poco productivo pues la transición entre diferentes IDEs y lenguajes hace que el proceso sea más lento. Sin mencionar que cuando estos problemas ocurren los PA no ofrecen la suficiente retroalimentación, por lo que, a menos que el PA esté enteramente codificado con los controles de excepciones precisos, obtendremos errores crípticos basados en la línea exacta en donde se encuentra el error.  

Los PA tampoco permiten pasar objetos, por lo que podría llegar a suceder que requiramos enormes cantidades de parámetros para poder poblar una fila de la tabla. De este modo, si requerimos llenar una fila de la tabla con más de 20 campos utilizando PA, deberemos ingresar más de 20 parámetros y en caso de que uno de estos parámetros esté incorrecto, sea cual sea la razón, obtendremos un error genérico de “bad call”, lo que significa que no sabremos que parámetros están equivocados, por lo que se deberán revisar manualmente uno por uno para descubrir el error.  

Los PA esconden la lógica del negocio, por lo que es imposible saber qué es lo que un PA está haciendo o qué tipo de valores me retornará; tampoco es posible ver el código fuente de estos (a menos que se cuente con el acceso apropiado) para poder corroborar si está haciendo lo que creemos que está haciendo.  

Sin embargo, no todo es malo alrededor de los PA pues algunos autores afirman que estos ayudan a aumentar el rendimiento, seguridad y accesibilidad al soporte de las bases de datos.  

Para los escenarios de uso del mundo actual, el autor considera a los PA tienen serias desventajas y muy pocos beneficios prácticos, por lo tanto, los PA pueden ser considerados como el “Assembly” de las bases de datos, por lo cual solo debería utilizarse para controlar las situaciones de rendimientos más críticas.

## 3. 10 Reasons To Consider A Multi-Model Database  

A pesar de la existencia de tantas opciones de bases de datos diferentes en el mercado, todas se enfrentan a una gran cantidad de problemas dentro de su infraestructura. Es por eso que el autor nos plantea la opción de la proliferación de bases de datos NoSQL y ser ajustados a un modelo particular, que pueden proporcionar un back-end único que expone múltiples modelos de datos y así omitir la fragmentación y ofrecen un back-end coherente y bien entendido, para algunos beneficios como:

### 1. Consolidación

Es cuando deciden como modelar y almacenar datos. Es complicado ya que existen muchas variables, como por ejemplo lenguajes de consultas, modelo de datos, motor de almacenamiento. Pero una base de datos de modelos múltiples admite diferentes tipos de datos para diferentes casos de uso y los consolida en una plataforma de forma que se transforma en un lenguaje de consulta, modelo de datos y motor de almacenamiento mucho mas flexible

### * Escalado De Rendimiento

Una aplicacion tiende a crecer con el tiempo, y la necesidad de rendimiento de la base de datos tambien aumenta. y los sistemas modelos multiples que desacoplan el lenguaje de consulta y el modelo de datos del almacen de datos permiten escalar independientemente, por lo tanto varias partes del back-end se pueden escalar con un mayor rendimiento.

### * Complejidad Operacional

El objetivo de la persistencia es utilizar el mejor componente, pero la simple integracion de esos sistemas es un desafio especialmente cuando se trata de mantener la consistencia de datos y la tolerancia a fallas, pero con el modelo multiples nos ofrece dividir esa complejidad solucionando problemas muchos mas complejos

### * Flexibilidad

Es incomodo meter muchos datos en un solo modelo de datos. el enfoque multimodelo implica mapear multiples modelos de datos y proporciona un mode. lado de datos flexible sin la complejidad de operar multiples almacenes de datos

### * Confiabilidad

La confiabilidad tambien es un problema cuando se ejecutan multiples bases de datos, la recuperacion de fallas de la maquina puede requerir horas y procesos muy pesados, el enfoque multimodelo ofrece una particion de las tareas coordinadas y aplicando menor tiempo

### * Consistencia de los datos

Este requisito puede ser dificil pero no imposible de lograr, sin embargo, un unico sistema de back-end que admite multiples modelos de datos basados en los requisitos de la aplicacion puede lograr el objetivo que reflejen un estado consistente.

### * Tolerancia a fallas

Integrar multiples sistemas que fueron diseñados para ejecutarse de forma independiente de modo que proporcionan tolerancia a fallas en todo el sistema en conjunto. entonces el subsistema tendra mucho tiempo y menos costoso.

### * Costo 

Al usar mas, se gasta mucho mas, con el modelo multimodelo se enfoca en fragmentar cada componente con un mantenimiento continuo, parches y correcciones de errores.  y con menos cosas que corregir menos costos tendra.

### * Transacciones

Un verdadero sistema multimodelo requiere transacciones para garantizar que los datos se almacenen, y casi todas las bases de datos NoSQL no ofrecen garantias transaccionales debido a sus diseños arquitectonicos. y garantiza que los datos sean coherentes en la base de datos

### * Mejores Aplicaciones

Intentar ejercutar diferentes bases de datos para alimentar una aplicacion puede ser una pesadilla pero al contrario usando bases de datos multimodelo. debido a que dirige el mercado de bases de datos transacciones compatibles con ACID, API de modelos multiples y motores de almacenamiento compartidos

