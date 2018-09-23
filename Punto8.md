## Punto 8: Análisis de Artículos.  

Uno de los objetivos del taller es analizar algunos artículos en Internet creados con el fin de ayudar a las personas a entender como manejar mejor sus bases de datos. En este archivo usted podrá encontrar el análisis de cada uno de los integrantes del equipo.  

1.	https://blog.codinghorror.com/maybe-normalizing-isnt-normal/  
2.	https://blog.codinghorror.com/who-needs-stored-procedures-anyways/  
3.	http://highscalability.com/blog/2015/3/4/10-reasons-to-consider-a-multi-model-database.html  

El primer análisis fue por Sergio González, el segundo por Manuel Chaverra y el tercero por Juan Gómez. Los encontrará a continuación:  

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