/*
 * Autores: Alyson Melissa Sánchez Serratos - A01771843
 *          Carlos Alberto Mejía Vergara - A01364028
 *          Julieta Itzel Pichardo Meza - A01369630
 *          
 * Fecha de Creación: 23/11/2024
 *
 * Descripción: Este código visualiza un campo de flujo de viento en un mapa global utilizando Processing. 
 *              Los datos de viento son cargados desde un archivo JSON, interpolados y representados 
 *              visualmente mediante partículas que simulan la dirección y magnitud del viento. 
 *              El programa incluye funcionalidades como interpolación bilineal y asignación de colores
 *              según la intensidad del viento.
 *
 * Dependencias: Archivo JSON con datos de viento ("wind_conditions.json") y una imagen del mapa del mundo ("world_map.png").
 * 
 * Parámetros principales:
 * - Cantidad de partículas que se deseen visualizar: 30,000
 * - Resolución del mapa: Escala ajustada a las dimensiones del lienzo.
 */

JSONArray json; // Datos JSON del archivo de condiciones de viento.
JSONObject componentX_Object; // Objeto JSON que contiene los datos de la componente X del viento.
JSONObject componentY_Object; // Objeto JSON que contiene los datos de la componente Y del viento.
JSONArray componentX_Data, componentY_Data;  // Datos de las componentes X e Y del viento.
JSONObject windConditions_header; // Metadatos del archivo JSON de donde se rescatan las dimensiones del campo.
int rows, columns, numberPoints; // Dimensiones del campo de viento y número total de puntos (partículas) en el campo.

float XScale, YScale; // Factores de escala para ajustar el campo al tamaño de la ventana.
ArrayList<Particle> particles = new ArrayList<Particle>(); // Lista de partículas que se desean activar.
ArrayList<Particle> totalParticles = new ArrayList<Particle>(); // Lista de partículas totales en todo el campo.
int numberParticles;  // Número total de partículas que se animarán.
PImage mapImage;


/**
 * Configuración inicial del programa. Aquí se define el tamaño de la ventana,
 * la carga de datos del viento y el calculo de las escalas.
 */
void setup() {
  size(1400, 700); // Definición de la resolución del mapa.
  numberParticles = 30000; // Definición del número de partículas que se desean animar.
  loadWindData("wind_conditions.json");
  computeScale();
  mapImage = loadImage("world_map.png");
}


/**
 * Bucle principal que renderiza el mapa y actualiza la animación.
 */
void draw() {
  image(mapImage, 0, 0, width, height); // Dibuja el mapa de fondo.
  for (Particle p : particles) {
    p.run(); // Actualiza y dibuja cada partícula.
  }
  
  colorMap();  // Dibuja puntos coloreados en la imagen del mapa que representan la magnitud del viento.
}


/**
 * Colorea la imagen del mapa por secciones en donde cada color representa 
 * la magnitud en cada sección en específico del viento.
 */
void colorMap() {
  smooth(); // Suaviza los bordes al dibujar.
  
  for (int i = 0; i < numberPoints; i++) {
    // Mapea las coordenadas de la cuadrícula de viento (initial_position.x y initial_position.y) 
    // a coordenadas dentro del espacio de la ventana gráfica (de píxeles). 
    int mapX = int(map(totalParticles.get(i).initial_position.x, 0, columns, 0, width)); 
    int mapY = int(map(totalParticles.get(i).initial_position.y, 0, rows, 0, height)); 
    float magnitude = totalParticles.get(i).constant_magnitude; // Obtiene la magnitud de la partícula.
    color c = getWindColor(magnitude); // Calcula el color basado en la magnitud del viento.
    int size = int(map(magnitude, 0, 20, 5, 15));  // Ajusta el tamaño del punto coloreado según la magnitud.
    
    noStroke(); // Desactiva el contorno
    fill(c, 120); // Color semi-transparente para que se observen las partículas de aire y no solo el mapa pintado.
    ellipse(mapX, mapY, size, size);
  }
}


/**
 * Calcula las escalas de ajuste basadas en las dimensiones del mapa.
 */
void computeScale() {
  XScale = (float) width / columns; // Escala horizontal.
  YScale = (float) height / rows;  // Escala vertical.
}


/**
 * Carga y procesa datos del archivo JSON.
 */
void loadWindData(String fileName) {
  json = loadJSONArray(fileName); 
  componentX_Object = json.getJSONObject(0);
  componentY_Object = json.getJSONObject(1);
  windConditions_header = componentX_Object.getJSONObject("header");  // Metadatos.
  
  // Extrae dimensiones y cantidad de puntos del mapa a partir del header.
  rows = windConditions_header.getInt("ny");
  columns = windConditions_header.getInt("nx");
  numberPoints = windConditions_header.getInt("numberPoints");
  
  componentX_Data = componentX_Object.getJSONArray("data");
  componentY_Data = componentY_Object.getJSONArray("data");
  
  // Procesa las componentes X e Y de cada punto y genera su partícula correspondiente.
  processVectors(componentX_Data, componentY_Data); 
}


/**
 * Procesa los vectores del viento y genera partículas.
 */
void processVectors(JSONArray componentX_Data, JSONArray componentY_Data) {
  int currentParticles = 0; // Contador de partículas generadas.
  
  // Bucle que recorre todos los puntos del campo de viento.
  for (int i = 0; i < numberPoints; i++) {
    // Obtiene el valor de la componente X del viento en el punto i desde el JSONArray.
    float componentX = componentX_Data.getFloat(i);
    // Obtiene el valor de la componente Y del viento en el punto i desde el JSONArray.
    float componentY = componentY_Data.getFloat(i);
    // Calcula la magnitud del viento en el punto i usando las componentes X e Y.
    float magnitude = computeMagnitude(componentX, componentY);
    // Calcula el ángulo de dirección del viento en el punto i usando las componentes X e Y.
    float angle = computeAngle(componentX, componentY);
    // Crea un vector de dirección a partir del ángulo calculado.
    PVector direction = new PVector(cos(angle), sin(angle));
    
    // Calcula la posición en el campo para este punto, basado en el índice i.
    PVector position = computePosition(i);
   // Agrega una nueva partícula a la lista totalParticles con la posición, magnitud y dirección calculada.
    totalParticles.add(new Particle(position, magnitude, direction)); 
    
     // Genera partículas con posiciones aleatorias si aún no se ha alcanzado el número deseado de partículas 
     // que se desean animar.
    if (currentParticles < numberParticles) {
      // Genera posiciones aleatorias dentro de los límites del campo.
      float randomX = random(columns);
      float randomY = random(rows);
      
      // Calcula la magnitud y el ángulo de viento para la nueva posición aleatoria.
      float randomMagnitude = computeMagnitude(randomX, randomY);
      float randomAngle = computeAngle(randomX, randomY);
      
      // Crea la dirección aleatoria del viento utilizando el ángulo calculado.
      PVector randomDirection = new PVector(cos(randomAngle), sin(randomAngle));  
      // Crea un vector con la nueva posición aleatoria.
      PVector randomPosition = new PVector(randomX, randomY);
      
      // Agrega una nueva partícula aleatoria a la lista de partículas que se desean animar, con la posición, magnitud y dirección aleatoria.
      particles.add(new Particle(randomPosition, randomMagnitude, randomDirection));  
      
      // Incrementa el contador de partículas generadas que se desean animar.
      currentParticles += 1;
    }
  }
}


/**
* Función para calcular la magnitud del viento a partir de las componentes X e Y.
*/
float computeMagnitude(float componentX, float componentY) {
   // Calcula la magnitud del viento usando el teorema de Pitágoras: sqrt(X^2 + Y^2)
  return sqrt(pow(componentX, 2) + pow(componentY, 2)); // Devuelve la magnitud (intensidad) del viento.
}


/**
* Función para calcular el ángulo del viento a partir de las componentes X e Y.
*/
float computeAngle(float componentX, float componentY) {
  // Calcula el ángulo en radianes del viento.
  return atan2(componentY, componentX);
}


/**
* Función para calcular la posición en el campo o matriz de puntos basada en el índice de un punto.
*/
PVector computePosition(int index) {
  // Calcula la posición en el eje X usando el índice modulo el número de columnas.
  float x = (index % columns);
  // Calcula la posición en el eje Y usando la división del índice entre el número de columnas.
  float y = (index / columns);
  return new PVector(x, y); // Retorna la posición en la matriz como un vector de 2D (x, y).
}


/**
* Función para obtener el vector de viento en el punto i.
*/
PVector getWindData(int i) {
  // Obtiene la componente X del viento en el punto i del JSONArray.
  float u = componentX_Data.getFloat(i);
  
  // Obtiene la componente Y del viento en el punto i del JSONArray.
  float v = componentY_Data.getFloat(i);
  
  // Devuelve un vector 2D con las componentes u (X) y v (Y) del viento en el punto i.
  return new PVector(u, v); 
}


/**
* Interpola el viento en un punto (x, y) dado utilizando una interpolación 
* bilineal sobre una matriz de componentes x e y del viento de tamaño nx x ny. 
*/
PVector interpolate(float x, float y, int nx, int ny) {
  // Define un factor de suavizado para el resultado de la interpolación. 
  // Este valor reduce la magnitud de la interpolación resultante para evitar fluctuaciones bruscas.
  float smoothFactor = 0.35;
  
  // x0 y y0 representan las coordenadas enteras más cercanas hacia abajo de los valores de x e y, respectivamente.
  int x0 = floor(x);
  int y0 = floor(y);  
  
  
  // x1 y y1 son las coordenadas del siguiente punto a la derecha y arriba en la matriz. Estas coordenadas se limitan por el tamaño de la matriz (nx, ny)
  int x1 = min(x0 + 1, nx - 1);
  int y1 = min(y0 + 1, ny - 1);

  // Obtiene los datos de viento (vectores u, v) de los cuatro puntos que rodean el punto (x, y).
  PVector g00 = getWindData(y0 * nx + x0); // Datos de viento en la posición (x0, y0).
  PVector g10 = getWindData(y0 * nx + x1); // Datos de viento en la posición (x1, y0).
  PVector g01 = getWindData(y1 * nx + x0); // Datos de viento en la posición (x0, y1).
  PVector g11 = getWindData(y1 * nx + x1); // Datos de viento en la posición (x1, y1).
  
  // Realiza una interpolación bilineal entre los cuatro puntos obtenidos y utilizando las distancias relativas (x - x0, y - y0)
  PVector interpolated = bilinearInterpolateVector(x - x0, y - y0, g00, g10, g01, g11);
  // Aplica el factor de suavizado al vector interpolado para hacer la transición más suave.
  interpolated.mult(smoothFactor);
  
  return interpolated;
 }


/*
* Realiza la interpolación bilineal de un vector 2D (componente u y v, que representan 
* el viento en las direcciones X y Y), a partir de cuatro puntos vecinos. También devuelve 
* la magnitud del vector interpolado.
*/
PVector bilinearInterpolateVector(float x, float y, PVector g00, PVector g10, PVector g01, PVector g11) {
  // Calcula los coeficientes para la interpolación bilineal en los ejes X y Y.
  
  /*
  Este valor describe cuán cerca está el punto (x,y) del borde izquierdo de la celda, es decir,
  del punto (x0,y0). Si x está muy cerca de x0, el valor de rx será casi 1, y 
  esto indica que el valor en (x0,y0) tiene más peso en el cálculo de la interpolación. 
  Si x está cerca de x1, el valor de rx será pequeño (cerca de 0), lo que significa que el valor 
  de (x1,y0) tendrá más influencia.
  */
  float rx = 1 - x;
  
  /*
  Este valor describe cuán cerca está el punto (x,y) del borde inferior de la celda, 
  es decir, del punto (x0,y0). Si y está cerca de y0, entonces ry será casi 1, lo 
  que significa que el valor en el punto (x0,y0)(x_0, y_0)(x0,y0) tendrá mayor 
  peso en la interpolación. Si y está cerca de y1, el valor de ry será pequeño, lo 
  que indica que el valor de (x0,y1) influirá más.
  */
  float ry = 1 - y;
  
  // Calcula los pesos para los cuatro puntos (g00, g10, g01, g11).
  // Cada peso determina cuánta influencia tendrá cada uno de los puntos vecinos en el resultado final.
  float a = rx * ry, b = x * ry, c = rx * y, d = x * y;
  
  // Multiplica las componentes u y v de cada punto por su peso correspondiente.
  float u = g00.x * a + g10.x * b + g01.x * c + g11.x * d;
  float v = g00.y * a + g10.y * b + g01.y * c + g11.y * d;

  return new PVector(u, v, sqrt(u * u + v * v)); // Devolvemos el vector + magnitud
}

color getWindColor(float magnitude) {
  color colorMap;  // Declaración de la variable colorMap que almacenará el color resultante basado en la magnitud
  
  // Primer rango de magnitudes: de azul a verde, cuando la magnitud está entre 0 y 5
  colorMap = color(map(magnitude, 0, 5, 0, 0), // El componente rojo (R) se mantiene en 0 para toda la gama.
              map(magnitude, 0, 5, 0, 255), // El componente verde (G) varía de 0 a 255 según la magnitud.
              map(magnitude, 0, 5, 255, 0)); // El componente azul (B) varía de 255 a 0, de modo que de azul pasa a verde.
              
  // Si la magnitud está entre 5 y 7, cambia de verde a amarillo
  if (magnitude > 5 && magnitude <= 7) {
    colorMap = color(map(magnitude, 5, 7, 0, 255), // El componente rojo (R) varía de 0 a 255, de verde a amarillo.
              map(magnitude, 5, 7, 255, 255), // El componente verde (G) permanece en 255 (amarillo).
              map(magnitude, 5, 7, 0, 0)); // El componente azul (B) sigue siendo 0 (amarillo).
  } 
  // Si la magnitud está entre 7 y 10, cambia de amarillo a rojo
  else if (magnitude > 7 && magnitude <= 10) {
    colorMap = color(map(magnitude, 7, 10, 255, 255), // El componente rojo (R) permanece en 255 (rojo).
              map(magnitude, 7, 10, 255, 0), // El componente verde (G) disminuye de 255 a 0 (de amarillo a rojo).
              map(magnitude, 7, 10, 0, 0)); // El componente azul (B) sigue siendo 0 (rojo).
  }
  
  return colorMap;  // Devuelve el color calculado basado en la magnitud.
}




/////////////////////////////////////////////////////////////////////////

class Particle {
  // Atributos de la clase Particle.
  PVector position, initial_position, initial_direction, previous_position, direction, vel;
  float magnitude, initial_magnitude, constant_magnitude, lifespan, initial_lifespan, birthTime;
  color col;

  // Constructor de la clase Particle. Inicializa todos los atributos de la partícula.
  Particle(PVector position, float magnitude, PVector direction) {
    // Se inicializan las posiciones iniciales y actuales de la partícula.
    this.position = position; 
    this.initial_position = new PVector(position.x, position.y); // Guarda la posición inicial
    this.previous_position = new PVector(position.x, position.y); // Guarda la posición anterior
    this.direction = direction; 
    this.initial_direction = new PVector(direction.x, direction.y); // Guarda la dirección inicial
    this.magnitude = magnitude;
    this.initial_magnitude = magnitude; // Guarda la magnitud inicial
    this.constant_magnitude = interpolate(position.x, position.y, columns, rows).z; // Magnitud interpolada basada en la posición actual
    this.initial_lifespan = 100; // Se establece un tiempo de vida inicial para la partícula
    this.birthTime = millis(); // Marca el momento de nacimiento (inicio) de la partícula en milisegundos
    this.lifespan = initial_lifespan; // Asigna el tiempo de vida actual igual al inicial
  }
  
  // Método principal que ejecuta las acciones de la partícula.
  void run() {
    checkEdges(); // Verifica si la partícula ha salido de los límites
    updatePreviousPosition(); // Actualiza la posición anterior de la partícula
    move(); // Mueve la partícula según el viento interpolado
    display(); // Muestra la partícula en la pantalla
    updateLifespan(); // Actualiza la vida útil de la partícula
  }

  // Método que mueve la partícula basada en el viento interpolado.
  void move() {
    // Obtiene el viento interpolado en la posición actual de la partícula.
    PVector wind = interpolate(position.x, position.y, columns, rows);
    
    this.magnitude = wind.z; // Actualiza la magnitud de la partícula con la magnitud del viento.
    // Actualiza las posiciones de la partícula sumando el viento a la posición actual.
    this.position.x += wind.x;
    this.position.y += wind.y;
    
    // Calcula la transparencia de la partícula en función de su magnitud, a menor magnitud, mayor transparencia.
    int alphaValue = int(map(magnitude, 0, 10, 50, 255)); // Mapea la magnitud a un rango de 50 a 255 para la transparencia
    // Asigna un color gris a la partícula, ajustado por la transparencia calculada.
    this.col = color(240, 240, 220, alphaValue); 
  }
  
  // Método que actualiza el tiempo de vida de la partícula.
  void updateLifespan() {
    // Calcula el tiempo transcurrido desde que la partícula nació.
    float elapsedTime = millis() - birthTime; 
    // Resta el tiempo transcurrido al tiempo de vida inicial.
    lifespan = initial_lifespan - elapsedTime;
    
    // Si la partícula ha llegado al final de su vida útil, reinicia la partícula.
    if (lifespan <= 0) {
        resetParticle(); 
    }
  }

  // Método que actualiza la posición anterior de la partícula para su uso en la animación.
  void updatePreviousPosition() {
    // Establece la posición anterior igual a la posición actual de la partícula.
    previous_position.set(position);
  }

  // Método que reinicia la partícula con nuevas propiedades aleatorias.
  void resetParticle() {
    // Asigna posiciones aleatorias dentro de los límites.
    float randomX = random(columns);
    float randomY = random(rows);

    // Calcula la magnitud y el ángulo aleatorio basado en la nueva posición.
    float randomMagnitude = computeMagnitude(randomX, randomY);
    float randomAngle = computeAngle(randomX, randomY);
    PVector randomDirection = new PVector(cos(randomAngle), sin(randomAngle)); // Calcula la nueva dirección
    PVector randomPosition = new PVector(randomX, randomY); // Establece la nueva posición
    
    // Reinicia las propiedades de la partícula.
    this.position.set(randomPosition); // Establece la nueva posición
    this.previous_position.set(randomPosition); // Establece la nueva posición anterior
    this.magnitude = randomMagnitude; // Establece la nueva magnitud
    this.direction.set(randomDirection); // Establece la nueva dirección
    this.birthTime = millis(); // Reinicia el tiempo de nacimiento de la partícula
    this.lifespan = initial_lifespan; // Reinicia el tiempo de vida
  }

  // Método que verifica si la partícula ha salido de los límites y la reinicia si es necesario.
  void checkEdges() {
    if (position.x < 0 || position.x > columns || position.y < 0 || position.y > rows) {    
      resetParticle(); // Reinicia la partícula si está fuera de los límites
    }
  }

  // Método que dibuja la partícula en la pantalla.
  void display() {
    stroke(col); // Establece el color del borde de la partícula (color con transparencia)
    strokeWeight(2); // Establece el grosor del borde de la partícula
 
    // Calcular el primer punto de control para la curva de Bézier
    // Este punto se encuentra en una posición intermedia entre el punto anterior (previous_position) y el punto actual (position)
    // Se utiliza un 70% de la distancia entre estos puntos, lo que hace que la curva "tienda" a acercarse más al punto actual
    float controlX1 = previous_position.x * XScale + (position.x - previous_position.x) * 0.7;
    float controlY1 = previous_position.y * YScale + (position.y - previous_position.y) * 0.7;
    
    // Calcular el segundo punto de control para la curva de Bézier
    // Este punto también está entre el punto anterior y el punto actual, pero en la dirección opuesta
    // Se usa un 70% de la distancia entre los puntos, lo que hace que la curva "tienda" a acercarse más al punto anterior
    float controlX2 = position.x * XScale - (position.x - previous_position.x) * 0.7;
    float controlY2 = position.y * YScale - (position.y - previous_position.y) * 0.7;

    
    // Dibuja la curva de Bezier entre la posición anterior y la posición actual de la partícula, mostrando su trayectoria.
    curve(previous_position.x * XScale, previous_position.y * YScale, 
          controlX1, controlY1, 
          controlX2, controlY2, 
          position.x * XScale, position.y * YScale);
  }
}
