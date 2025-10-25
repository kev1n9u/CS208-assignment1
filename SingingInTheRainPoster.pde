class Circle {
  float x, y;    
  float diameter; 
  int r, g, b;   
  int target = 240; 
  int lastUpdate; 
  int updateInterval; 
  long spawnTime; 
 
  Circle(float x, float y, float diameter) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.r = 100;   
    this.g = 100;   
    this.b = 100;  // the default color of every raindrop, make sure r=g=b to make a "grey" color
    this.lastUpdate = millis();
    this.updateInterval = (int)random(20, 41); // the speed of color changing
    this.spawnTime = millis(); 
  }

  void update() {
    int currentTime = millis();
    if (currentTime - lastUpdate >= updateInterval) {
      if (r < target) r += 2;
      if (g < target) g += 2;
      if (b < target) b += 2;  // raindrop changing color through time 
      lastUpdate = currentTime;
    }
  }
  
  void display() {
    noStroke(); 
    fill(r, g, b);
    ellipse(x, y, diameter, diameter);
  }

  boolean isComplete() {
    return r >= target && g >= target && b >= target;
  }
}

ArrayList<Circle> circles = new ArrayList<Circle>(); 
ArrayList<Circle> pendingSubCircles = new ArrayList<Circle>();
int lastSpawnTime = 0;     
int spawnInterval;           
PFont myFont1, myFont2, myFont3, myFont4;

void setup() {
  size(960, 1280);
  background(240); 
  myFont1 = createFont("Cooper Black", 32);
  myFont2 = createFont("Harlow Solid Italic", 32);
  myFont3 = createFont("Felix Titling", 32);
  myFont4 = createFont("Algerian", 32);
}

void draw() {
  background(240);
  int currentTime = millis();
  if (currentTime - lastSpawnTime >= spawnInterval) {
    int numCircles = (int)random(1, 4); // how many raindrops at a time, the bigger the heavier the rain is
    for (int i = 0; i < numCircles; i++) {
      float x = random(width);
      float y = random(height);
      float size = random(40, 120); // raindrop sizes, the bigger the heavier the rain is
      Circle mainCircle = new Circle(x, y, size);
      circles.add(mainCircle);
      
      if (size / 2 > 40) {
        createPendingSubCircles(mainCircle); // big raindrop smash smaller raindrop
      }
    }
    lastSpawnTime = currentTime;
    spawnInterval = (int)random(100, 201); // raindrop frequency, the smaller the heavier
  }

  checkAndSpawnSubCircles();
  for (int i = circles.size() - 1; i >= 0; i--) {
    Circle c = circles.get(i);
    c.update();
    c.display();
    if (c.isComplete()) {
      circles.remove(i);
    }
  }
  textFont(myFont1);
  fill(0);
  textSize(300);
  text("S", 175, 450);
  textSize(100);
  text("INGING", 365,390);
  textSize(60);
  fill(50);
  text("IN THE", 415,450);
  textSize(200);
  fill(0);
  text("RAIN", 205,600);
  textSize(20);
  text("TM", 765,600);
  
  textFont(myFont2);
  fill(0);
  textSize(40);
  text("Gene", 150, 70);
  text("Donald",375, 70);
  text("Debbie", 675, 70);
  
  textFont(myFont3);
  fill(0);
  textSize(50);
  text("KELLY", 125, 125);
  text("OCONNOR",300, 125);
  text("REYNOLDS", 600, 125);
  
  textFont(myFont4);
  fill(0);
  textSize(25);
  text("11 Apr 1952", 400, 800);
}

void createPendingSubCircles(Circle mainCircle) {
  int subCircleCount = (int)random(1, 4);
  float mainRadius = mainCircle.diameter / 2;
  float subRadius = mainRadius / 4;
  float subDiameter = subRadius * 2;
  long delay = (long)random(500, 1001); // the delay of small drops ccaused by big drops
  long spawnTime = mainCircle.spawnTime + delay;
  for (int j = 0; j < subCircleCount; j++) {
    float angle = random(TWO_PI); // random angle of small drops
    float distanceMultiplier = random(1.3, 2.0); // the distance of small drops to the big drop
    float distance = mainRadius * distanceMultiplier;
    float subX = mainCircle.x + cos(angle) * distance;
    float subY = mainCircle.y + sin(angle) * distance;
    subX = constrain(subX, subRadius, width - subRadius);
    subY = constrain(subY, subRadius, height - subRadius);
    Circle subCircle = new Circle(subX, subY, subDiameter);
    subCircle.spawnTime = spawnTime; 
    pendingSubCircles.add(subCircle);
  }
}

void checkAndSpawnSubCircles() {
  long currentTime = millis();
  for (int i = pendingSubCircles.size() - 1; i >= 0; i--) {
    Circle subCircle = pendingSubCircles.get(i);
    if (currentTime >= subCircle.spawnTime) {
      circles.add(subCircle);
      pendingSubCircles.remove(i);
    }
  }
}

void keyPressed() {
  if (key == 'f' || key == 'F') { 
    noLoop();
  } else if (key == 'g' || key == 'G') { 
   loop();
  }
}
