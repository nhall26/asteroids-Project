/******************************* //<>// //<>// //<>//
 Group 14 Asteroids
 Version 2.1
 #TODO#
 Collision detection
 Round counter
 Asteroids based on round no.
 *******************************/

Spaceship player1;
ArrayList<bullet> bullets;
ArrayList<asteroid> asteroids;
ArrayList<alien> enemy;
ArrayList<Alaser> laser;
boolean tryAgain = false;
int tryAgainCount = 4;
int asteroidCount = 5;
int alienCount = 1;
int laserCount = 1;
int time;
int wait = 10000;
boolean enemyexists;


void setup() {
  size(800, 800);
  frameRate(60);
  bullets = new ArrayList<bullet>();
  player1 = new Spaceship();
  asteroids = new ArrayList<asteroid>();
  enemy = new ArrayList<alien>();
  laser = new ArrayList<Alaser>();
  time = millis();

  for (int i = 0; i < asteroidCount; i++) {
    asteroids.add(new asteroid());
  }
}

void draw() {
  background(0);
  //stroke(255,0,0);
  //line(0,height/2, width, height/2);
  //line(width/2,0, width/2, height);
  text(player1.newPosition.x, 300, 40);
  text(player1.newPosition.y, 450, 40);
  text(bullets.size(), 300, 70);
  text("LIVES", 90, 40);
  //print(enemy.heading.x);

  for (int i = 0; i < asteroids.size(); i++) {
    asteroids.get(i).updatePos();
    asteroids.get(i).edgeDetection();
    asteroids.get(i).render();
  }
  for (int i = 0; i < enemy.size(); i++) {
    enemy.get(i).updatePos();
    enemy.get(i).edgeDetection();
    enemy.get(i).render();
  }
  for (int i = 0; i < laser.size(); i++) {
    laser.get(i).updatePos();
    laser.get(i).edgeDetection();
    laser.get(i).render();
    if (laser.get(i).counterLaser > 80){
        laser.remove(i);
        i--;
      }
  }
  if (millis() - time >= wait) {
    enemy.add(new alien());
    enemyexists = true;
    time = millis();
  }
  if (enemyexists == true){
    laser.add(new Alaser());
  }


  if (player1.lives >= 0) {

    header();
    player1.updatePos();  // Update position
    player1.edgeDetection();  // check to see if the ship has exceeded the edges of the frame
    player1.render();    // render the ship  
    if (player1.collisionDetection(asteroids)) {
        player1.death();
        delay(50);
        player1.reset();
      } else if (player1.collisionDetection2(enemy)) {
        player1.death();
        delay(50);
        player1.reset();
        enemyexists = false;
      }

    //ellipse(player1.newPosition.x, player1.newPosition.y, 5, 5);

    fill(255);
    text("left right arrows to turn, up arrow to thrust", 10, height-5);
    if (keyPressed) {    // Turn or thrust the ship depending on what key is pressed
      if (key == CODED && keyCode == LEFT) {
        player1.turnShip(-0.06);
      } else if (key == CODED && keyCode == RIGHT) {
        player1.turnShip(0.06);
      } else if (key == CODED && keyCode == UP) {
        player1.thrust();
      } else if (key == CODED && keyCode == DOWN) {
        player1.death();
        delay(50);
        player1.reset();
      }
    }

    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).updatePos();
      bullets.get(i).edgeDetection();
      bullets.get(i).render();
      if (bullets.get(i).collisionDetection(asteroids)) {
        bullets.remove(i);
        i--;
      } else if (bullets.get(i).collisionDetection2(enemy)) {
        bullets.remove(i);
        i--;
        enemyexists = false;
      } else if (bullets.get(i).counter > 80){
        bullets.remove(i);
        i--;
      }
    }
  } else if (tryAgain) {
    background(0);
    if (tryAgainCount > 0) {
      text("Starting in " + (tryAgainCount-1), width/2, height/2);
      delay(1000);
      tryAgainCount--;
    } else { //if(tryAgainCount < 0) {
      player1.lives = 3;
      tryAgainCount = 3;
      tryAgain = false;
    }
  } else {
    textSize(50);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
    text("Press any key to try again.", width/2, height/2 + 100);
    if (keyPressed) {
      tryAgain = true;
    }
  }
}
/*
void keyPressed() {
 if (key == CODED && keyCode == LEFT) {
 player1.turnShip(-0.06);
 } else if (key == CODED && keyCode == RIGHT) {
 player1.turnShip(0.06);
 } else if (key == CODED && keyCode == UP) {
 player1.thrust();
 } else if (key == CODED && keyCode == DOWN) {
 player1.death();
 delay(50);
 player1.reset();
 }
 }*/

void keyReleased() {
  if (key == ' ') {
    bullets.add(new bullet());
  }
}

void header() {
  strokeCap(SQUARE);
  stroke(255);
  strokeWeight(10);
  line(0, 100, width, 100);
  line(200, 0, 200, 100);
  textSize(25);
  textAlign(CENTER);

  for (int i = 0; i < player1.lives; i++) {
    noFill();
    strokeWeight(2);
    beginShape();          // draw a complex shape
    vertex(50+i*30, 75);    //lower left vertex
    vertex(60+i*30, 70);       //lower mid vertex
    vertex(70+i*30, 75);     //lower right vertex
    vertex(60+i*30, 55);    //upper mid vertex
    endShape(CLOSE);       //finished creating shape
  }
}

class Spaceship {
  PVector position, velocity, acceleration;  //create PVectors for motion
  float damping = 0.995;  //damping value allows the gradual slow down effect
  float topspeed = 6;    //set the topspeed of the ship
  float heading = 0;    //set the heading (direction) of the ship
  int size = 10;      //set the size of the bounding box containing the ship
  boolean thrusting = false;  //keeps track of whether the ship is thrusting (for visual purposes)
  int lives = 3;
  boolean die = false;
  int r = 255;
  int g = 255;
  int b = 255;
  PVector newPosition;


  Spaceship() {  //the default spaceship object
    position = new PVector(width/2, height/2);  // sets the initial position to be center-screen
    velocity = new PVector();    //initialises the velocity vector
    acceleration = new PVector();  //initialises the acceleration vector
    newPosition = new PVector(0, 0);
  } 

  void setStrokeColour(int red, int green, int blue) {
    r = red;
    g = green;
    b = blue;
  }

  void updatePos() {         //update the motion of the object
    velocity.add(acceleration);  //add acceleration values to the velocity vector
    velocity.mult(damping);    //multiply the velocity values by the damping value
    velocity.limit(topspeed);  //limit the velocity to the topspeed variable
    position.add(velocity);    //add the current velocity to the position of the ship
    acceleration.mult(0);    //reset the acceleration to 0 by multiplication
  }

  void applyForce(PVector force) {  //apply the necessary amount of force
    PVector f = force.get();  //get the values in the force vector and store them in the f vector
    acceleration.add(f);      // add the values in th ef vector to those in acceleration
  }

  void turnShip(float angle) {
    heading += angle;
  }

  void thrust() {
    float angle = heading - PI/2; // offset angle because ship is pointing vertical
    PVector force = new PVector(cos(angle), sin(angle)); // converts the polar coordinate to cartesian
    force.mult(0.1);     //multiply the force values by 0.1
    applyForce(force);   //call the applyForce function
    thrusting = true;    //set thrusting to true
  }

  void edgeDetection() {  //detects if the ship excceeds the frame edges.
    float buffer = size*2;    //set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // if the x position is too far right
      position.x = -buffer;    // set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // if the x position is too far left
      position.x = width;  // set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // if the y position is too low
      position.y = -buffer+125;  // set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y-125 < -buffer) {    // if y position is too high
      position.y = height;    // set the y position to be the bottom of the frame
    }
  }

  boolean collisionDetection(ArrayList<asteroid> asteroids) {
    for (asteroid a : asteroids) {
      PVector dist = PVector.sub(a.position, position);
      if (dist.mag() < a.radius) {
        a.breakUp();
        return true;
      }
    }  
    return false;
  }
  boolean collisionDetection2(ArrayList<alien> enemy) {
    for (alien a : enemy) {
      PVector dist = PVector.sub(a.position, position);
      if (dist.mag() < a.radius) {
        a.breakUp();
        return true;
      }
    }
    return false;
  }

  void render() {  // render the ship
    pushMatrix();  //saves current coordinate system to the stack
    translate(position.x, position.y+size);  //moves the coordinate system origin to the given points
    rotate(heading);  //rotate the ship according to its current heading    
    if (thrusting) {  
      stroke(255, 0, 0);  // set a red stroke
      strokeWeight(0.5);  //set teh stroke weight
      fill(249, 160, 27);  // fill with a red/orange colour
      beginShape();  // start creating the booster flame
      vertex(-size+2.5, size-4);  // all the vertexes of the complex shape
      vertex(-size+5, size+3.5);
      vertex(-size+8.75, size-0.25);
      vertex(1.25, size+8.5);
      vertex(3.75, size-0.25);
      vertex(6.25, size+3.5);
      vertex(size-2.5, size-4);
      endShape();        // finish creating the shape
    }
    fill(0);  // fill black (that way the flame doesn't start in the shape)
    stroke(r, g, b);    // set a white stroke
    strokeWeight(2);  //set teh stroke weight
    beginShape();          // draw a complex shape
    vertex(-size, size);    //lower left vertex
    vertex(0, -size);       //upper mid vertex
    vertex(size, size);     //lower right vertex
    vertex(0, size*3/5);    //lower mid vertex
    endShape(CLOSE);       //finished creating shape
    newPosition = new PVector(position.x + sin(heading) * size, position.y+size + cos(heading) * -size);
    popMatrix();           //restores the previous coordinate system
    thrusting = false;     // set thrusting to false
  }

  void death() {
    lives--;
    die = true;
  }

  void reset() {
    delay(1000);
    position = new PVector(width/2, height/2);  // sets the initial position to be center-screen
    velocity = new PVector();    //initialises the velocity vector
    acceleration = new PVector();  //initialises the acceleration vector
    die = false;
  }
}

class bullet {
  PVector position, velocity, acceleration;  //create PVectors for motion
  float heading, angle;
  int counter;
  int timeout = 48;

  bullet() {
    heading = player1.heading;
    angle = heading - PI/2; // offset angle because ship is pointing vertical
    position = new PVector (player1.newPosition.x, player1.newPosition.y);
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(5);
    counter = 0;
  }

  void updatePos() {         //update the motion of the object
    position.add(velocity);    //add the current velocity to the position of the ship
    //acceleration.mult(0);    //reset the acceleration to 0 by multiplication
    counter++;
  }
  void updateTime() {
    time = time + 1;
  }

  void edgeDetection() {  //detects if the ship excceeds the frame edges.
    float buffer = 10;    //set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // if the x position is too far right
      position.x = -buffer;    // set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // if the x position is too far left
      position.x = width;  // set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // if the y position is too low
      position.y = -buffer+125;  // set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 110 < -buffer) {    // if y position is too high
      position.y = height;    // set the y position to be the bottom of the frame
    }
  }

  boolean collisionDetection(ArrayList<asteroid> asteroids) {
    for (asteroid a : asteroids) {
      PVector dist = PVector.sub(a.position, position);
      if (dist.mag() < a.radius) {
        a.breakUp();
        return true;
      }
    }
    return false;
  }
  boolean collisionDetection2(ArrayList<alien> enemy) {
    for (alien a : enemy) {
      PVector dist = PVector.sub(a.position, position);
      if (dist.mag() < a.radius) {
        a.breakUp();
        return true;
      }
    }
    return false;
  }

  void removeBullet() {
    bullets.remove(this);
  }


  void render() {
    pushMatrix();  //saves current coordinate system to the stack
    translate(position.x, position.y);  //moves the coordinate system origin to the given points
    rotate(heading);  //rotate the ship according to its current heading
    fill(255);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}

class asteroid {
  PVector position, velocity, acceleration;
  float heading, angle, radius;

  asteroid() {
    heading = random(-180, 180);
    angle = heading; //- PI/2; // offset angle because ship is pointing vertical
    position = new PVector (random(0, 800), random(0, 800));
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(1.75);
    radius = 15;
  }

  void updatePos() {         //update the motion of the object
    position.add(velocity);    //add the current velocity to the position of the ship
    //acceleration.mult(0);    //reset the acceleration to 0 by multiplication
  }

  void edgeDetection() {  //detects if the asteroid excceeds the frame edges.
    float buffer = 10;    //set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // if the x position is too far right
      position.x = -buffer;    // set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // if the x position is too far left
      position.x = width;  // set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // if the y position is too low
      position.y = -buffer+125;  // set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 110 < -buffer) {    // if y position is too high
      position.y = height;    // set the y position to be the bottom of the frame
    }
  }

  void breakUp() {
    asteroids.remove(this);
  }

  void render() {
    pushMatrix();  //saves current coordinate system to the stack
    translate(position.x, position.y);  //moves the coordinate system origin to the given points
    rotate(heading);  //rotate the ship according to its current heading
    fill(255);
    ellipse(0, 0, radius*2, radius*2);
    popMatrix();
  }
}  

class alien {
  PVector position, velocity ;
  float heading, angle, radius;
  int size = 30;
  PVector newPosition;

  alien() {
    heading = random(-180, 180);
    position = new PVector (random(0, 800), random(0, 800));
    angle = heading;
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(3);
    radius = 15;
    newPosition = new PVector (0, 0);
  }

  void updatePos() {
    position.add(velocity);
  }   
  void breakUp() {
    enemy.remove(this);
  }
  void spawn() {
    if (millis() - time >= wait) {
      enemy.add(new alien());
      time = millis();
    }
  }

  void edgeDetection() {  //detects if the ship excceeds the frame edges.
    float buffer = size*2;    //set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // if the x position is too far right
      position.x = -buffer;    // set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // if the x position is too far left
      position.x = width;  // set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // if the y position is too low
      position.y = -buffer+125;  // set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y-125 < -buffer) {    // if y position is too high
      position.y = height;    // set the y position to be the bottom of the frame
    }
  }

  void render() {
    pushMatrix();
    translate(position.x, position.y+size);
    fill(0);
    stroke(255, 255, 255);
    beginShape();
    vertex(size/2-15, size*1/5-45);
    vertex(size*3/5-15, size*2/5-45);
    vertex(size*3/4-15, size*3/5-45);
    vertex(size-15, size*3/4-45);
    vertex(size*3/4-15, size*9/10-45);
    vertex(size/2-15, size-45);
    vertex(size*1/4-15, size*9/10-45);
    vertex(0-15, size *3/4-45);
    vertex(size*1/4-15, size*3/5-45);
    vertex(size*2/5-15, size*2/5-45);
    endShape(CLOSE);
    beginShape();
    vertex(size/2-15, size*2/5-45);
    vertex(size*3/5-15, size*3/5-45);
    vertex(size*2/5-15, size*3/5-45);
    endShape(CLOSE);
    line(0-15, size*3/4-45, size-15, size*3/4-45);
    ellipse(size/2-15, size*8/15-45, 2, 2);
    newPosition = new PVector(position.x + sin(heading) * size, position.y+size + cos(heading) * -size);
    popMatrix();
  }
}

class Alaser {
  PVector position, velocity, heading;
  float  angle ;
  PVector newPosition;
  int counterLaser;



  Alaser() {
    heading = new PVector(sin(player1.position.x), cos(player1.position.y));
    position = new PVector(enemy.get(0).newPosition.x,enemy.get(0).newPosition.y);
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(5);
    counterLaser = 0;
  }

  void updatePos() {
    position.add(heading);
    counterLaser++;
  }
  void edgeDetection() {  //detects if the ship excceeds the frame edges.
    float buffer = 10;    //set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // if the x position is too far right
      position.x = -buffer;    // set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // if the x position is too far left
      position.x = width;  // set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // if the y position is too low
      position.y = -buffer+125;  // set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 110 < -buffer) {    // if y position is too high
      position.y = height;    // set the y position to be the bottom of the frame
    }
  }
  void render() {
    pushMatrix();
    translate(position.x, position.y);
    fill(0);
    stroke(255, 255, 255);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}