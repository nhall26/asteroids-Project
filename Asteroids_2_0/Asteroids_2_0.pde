/******************************* //<>// //<>//
 Group 14 Asteroids
 Version 2.6
 #TODO#
 Improve Collision detection
 Fix enemy laser
 *******************************/
// initialise Variables to be used
// assign objects of classes
Spaceship player1;
// create dynamic arrays to store each of the following objects
ArrayList<bullet> bullets;
ArrayList<asteroid> asteroids;
ArrayList<alien> enemy;
ArrayList<Alaser> laser;
// tracks whether the player wishes to try again after death
boolean tryAgain = false;
// just used for the timer on the try again screen
int tryAgainCount = 4;
// store the amount of asteroids per round
int asteroidCount = 5;
// sets the time between each alien shot
int wait = 1000;
// stores the variable time
int time;
// stores the score the player should reach before an alien will spawn
int target = 1000;
// stores what round the player is currently on
int round = 1;
// tracks whether the user is currently on the Round Clear screen
boolean roundOver = false;
// tracks if the player has decided to move to the next round
boolean nextRound = false;
// just used for the timer on the next round screen
int nextRoundCount = 4;
boolean enemyExists;


void setup() {
  // set a canvas size of 800x800
  size(800, 800);
  frameRate(60);
  // initialise each array and object
  bullets = new ArrayList<bullet>();
  player1 = new Spaceship();
  asteroids = new ArrayList<asteroid>();
  enemy = new ArrayList<alien>();
  laser = new ArrayList<Alaser>();
  time = millis();
  
  for (int i = 0; i < asteroidCount; i++) {
    asteroids.add(new asteroid(30, 0, 800, 0, 800));
  }
}

void draw() {
  // black background
  background(0);
  //stroke(255,0,0);
  //line(0,height/2, width, height/2);
  //line(width/2,0, width/2, height);
  //text(player1.newPosition.x, 300, 40);
  //text(player1.newPosition.y, 450, 40);
  //text(bullets.size(), 300, 70);
  //print(enemy.heading.x);
  
  // run the main program while the player still has lives
  if (player1.lives >= 0) {
    // gernate the header
    header();
    // Update position
    player1.updatePos();  
    // check to see if the ship has exceeded the edges of the frame
    player1.edgeDetection();
    // render the ship
    player1.render();
    // if the player collides with the asteroids
    if (player1.collisionDetection(asteroids)) {
        // make the player die
        player1.death();
        // delay the screen for a moment
        delay(50);
        // reset the player
        player1.reset();
      } else if (player1.collisionDetection2(enemy)) {
        // if the player collides with the enemy ship, call the death function
        player1.death();
        // delay the screne a moment
        delay(50);
        // reset the player
        player1.reset();
        // set eth enemyExists variable to false
        enemyExists = false;
      } else if (player1.collisionDetection3(laser)) {
        // if the player collides with an enemy laser, call the death function
        player1.death();
        // delay the screne a moment
        delay(50);
        // reset the player
        player1.reset();
      }
    // generate asteroids
    for (int i = 0; i < asteroids.size(); i++) {
      asteroids.get(i).updatePos();
      asteroids.get(i).edgeDetection();
      asteroids.get(i).render();
    }
    // generate and update the enemy ship
    for (int i = 0; i < enemy.size(); i++) {
      enemy.get(i).updatePos();
      enemy.get(i).edgeDetection();
      enemy.get(i).render();
    }
    // generate and update the enemy laser
    for (int i = 0; i < laser.size(); i++) {
      laser.get(i).updatePos();
      laser.get(i).edgeDetection();
      laser.get(i).render();
      if (laser.get(i).counterLaser > 80){
          laser.remove(i);
          i--;
        }
    }
    if ((player1.score >= target) & !enemyExists) {
      enemy.add(new alien());
      enemyExists = true;
      target += 1000;   //Increment target by 1000 so that another enemy will spawn after another 1000 points.
    }
    if (enemyExists == true){
      if (millis() - time >= wait) {
        laser.add(new Alaser());
        time = millis();
      }
    }

    //ellipse(player1.newPosition.x, player1.newPosition.y, 5, 5);
    
    // display controls
    fill(255);
    textAlign(CENTER);
    text("Use Left and Right to rotate, Up to thrust and Space to fire!", 400, height-5);
    // turn or thrust the ship bassed in input
    if (keyPressed && roundOver == false) {
      if (key == CODED && keyCode == LEFT) {
        player1.turnShip(-0.06);
      } else if (key == CODED && keyCode == RIGHT) {
        player1.turnShip(0.06);
      } else if (key == CODED && keyCode == UP) {
        player1.thrust();
      }
    }
    // update each bullet that the player fires
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).updatePos();
      bullets.get(i).edgeDetection();
      bullets.get(i).render();
      // check if the bullets collide with anything or have travelled for a certain time
      if (bullets.get(i).collisionDetection(asteroids)) { // if any bullets i collides with any asteroids then remove bullets and i--
        bullets.remove(i); // remove bullet at index i
        i--; // deincrement i so that it is the same size as bullets array length
      } else if (bullets.get(i).collisionDetection2(enemy)) { // if any bullets i collides with any enemy then remove bullets and i--
        bullets.remove(i); // remove bullet at index i
        i--; //deincrement i so that it is the same size as bullets array length
        enemyExists = false;
      } else if (bullets.get(i).counter > 80){ // otherwise if bullets counter of bullets(i) is greater than 80 then remove bullet
        bullets.remove(i); // remove bullet at index i
        i--; // deincrement i so that it is the same size as bullets array length
      }
    }
    
    //If all asteroids and enemies have been destroyed, move on to next round.
    if (nextRound == true) {
      if (nextRoundCount > 0) {
        textSize(50);
        textAlign(CENTER);
        text("Starting in " + (nextRoundCount-1), width/2, height/2);
        delay(1000);
        nextRoundCount--;
      } else {
        roundOver = false;
        round += 1;
        asteroidCount += 2;  // Increase asteroid count so that the next round is harder.
        player1.position = new PVector(width/2, height/2);  // Reset player's position
        player1.velocity = new PVector(0, 0); // Reset the player's velocity
        player1.heading = 0;    //Reset the player's direction
        bullets = new ArrayList<bullet>();  // Remove bullets currently on screen
        laser = new ArrayList<Alaser>();  // Remove lasers currently on screen
        for (int i = 0; i < asteroidCount; i++) {
          asteroids.add(new asteroid(30, 0, 800, 0, 800));  // Spawn in new asteroids.
        }
        roundOver = false;
        nextRound = false;
        nextRoundCount = 4;
      }
    } else if (asteroids.size() == 0 && enemy.size() == 0) {
      roundOver = true;
      textSize(50);
      textAlign(CENTER);
      text("WELL DONE", width/2, height/2 - 100);
      text("You cleared Round " + str(round), width/2, height/2);
      text("Press any key to continue", width/2, height/2 + 100);
      if (keyPressed) {
        nextRound = true;
        }
    } 
  } 
  // if the payer hs no lives, display the following
  else if (tryAgain) {
    background(0);
    if (tryAgainCount > 0) {
      text("Starting in " + (tryAgainCount-1), width/2, height/2);
      delay(1000);
      tryAgainCount--;
    } else {
      // reset all of the arrays
      bullets = new ArrayList<bullet>();
      player1 = new Spaceship();
      asteroids = new ArrayList<asteroid>();
      enemy = new ArrayList<alien>();
      laser = new ArrayList<Alaser>();
      asteroidCount = 5;
      for (int i = 0; i < asteroidCount; i++) {
        asteroids.add(new asteroid(30, 0, 800, 0, 800));
      }
      time = millis();
      enemyExists = false;      
      tryAgainCount = 3;
      tryAgain = false;
      round = 1;
    }
  } else {
    // display the game over screen
    textSize(50);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2 - 100);
    text("Your score was " + str(player1.score), width/2, height/2);
    text("Press any key to try again.", width/2, height/2 + 100);
    if (keyPressed) {
      tryAgain = true;
    }
  }
}
// when the space bar is released, fire a bullet
void keyReleased() {
  if (key == ' ') {
    bullets.add(new bullet());
  }
}
// display the header
void header() {
  
  textSize(25);
  text("LIVES", 90, 40);
  strokeCap(SQUARE);
  stroke(255);
  strokeWeight(10);
  line(0, 100, width, 100);
  line(200, 0, 200, 100);
  textAlign(CENTER);
  text("Asteroids - COSC101", 500,40);
  text("ROUND: " + round, 350, 70);
  text("SCORE: " + player1.score, 650,70);
  // display the player ship for the amount of lives the player has
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

// begin the Spaceship class
class Spaceship {
  //initialise valuees to be used by spaceship
  PVector position, velocity, acceleration;  //create PVectors for motion
  float damping = 0.995;  //damping value allows the gradual slow down effect
  float topspeed = 6;    //set the topspeed of the ship
  float heading = 0;    //set the heading (direction) of the ship
  int size = 10;      //set the size of the bounding box containing the ship
  boolean thrusting = false;  // keeps track of whether the ship is thrusting (for visual purposes)
  int lives = 3; // Starting count of lives
  boolean die = false; // boolean to check dead, set to false to begin.
  // stores the position in relation to the original coordinate matrix
  PVector newPosition;
  int score = 0;    //tracks the current score of the player

  Spaceship() {  //the default spaceship object
    position = new PVector(width/2, height/2);  // sets the initial position to be center-screen
    velocity = new PVector();    //initialises the velocity vector
    acceleration = new PVector();  //initialises the acceleration vector
    newPosition = new PVector(0, 0);  // sets the position of the ship to be centre screen
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

  void turnShip(float angle) {  // rotate teh ship
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
    for (asteroid a : asteroids) {//for each asteroid in asteroids go through
      PVector dist = PVector.sub(a.position, position); //Check the distance between asteroid position and position of player
      if (dist.mag() < a.radius) { // if dist is in the radius of the player return true and breakup said asteroid
        a.breakUp(); //call breakup on asteroid
        return true; //return true
      }
    }  
    return false; // return true
  }
  
  boolean collisionDetection2(ArrayList<alien> enemy) {
    for (alien a : enemy) { // for each alien in enemy itterate through
      PVector dist = PVector.sub(a.position, position); // Get the distance between alien and position of player
      if (dist.mag() < a.radius) { // if dist between player and enemy is under the radius of the enemy then destroy alien and return true
        a.breakUp(); // call breakup on a of enemy
        return true; // return true
      }
    }
    return false; //return true
  }
  
  boolean collisionDetection3(ArrayList<Alaser> laser) {
    for (Alaser a : laser) { // itterate through for each alien laser
      PVector dist = PVector.sub(a.position, position); // if dist between player and enemy laser is under 2.5 then return true
      if (dist.mag() < 2.5) {
        return true; //return true
      }
    }
    return false; //return false
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
    stroke(255);    // set a white stroke
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

  void death() {  // decrement the lvies of the player and set die to true
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

// begin the bullet class
class bullet {
  PVector position, velocity, acceleration;  //create PVectors for motion
  float heading, angle;  // store the heading and angle
  int counter;  // store the distance counter
  
  // default contructor
  bullet() {
    heading = player1.heading;  // set the ehading to be the same ass player1's heading
    angle = heading - PI/2; // offset angle because ship is pointing vertical
    // set the position to be the same as player1's original position
    position = new PVector (player1.newPosition.x, player1.newPosition.y); // spawn at player x and y
    velocity = new PVector (cos(angle), sin(angle));  // assign values to the velocity vector
    velocity.mult(5); // multiple the values by 5
    counter = 0;  // set the counter to be 0
  }

  void updatePos() {         //update the motion of the object
    position.add(velocity);    //add the current velocity to the position of the bullet
    counter++;  // increment the counter
  }

  void edgeDetection() {  //detects if the bullets excceeds the frame edges.
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
  
  // collision detection for the bullets, same as ship collision
  boolean collisionDetection(ArrayList<asteroid> asteroids) {
    for (asteroid a : asteroids) {//for each asteroid in asteroids go through
      PVector dist = PVector.sub(a.position, position); // check the distance between asteroid and bullet.
      if (dist.mag() < a.radius) { // if bullet is inside the asteroid radius, then check for radius size
        a.breakUp(); // call asteroid breakup function
        if (a.radius > 15) {  // If radius > 15, the asteroid will break into two smaller asteroids instead of being destroyed
          player1.score += 50; // add 50 to player score
        } else {  // Otherwise, the asteroid is completely destroyed.
          player1.score += 100; // add 100 to player score
        }
        return true; // return true
      }
    }
    return false; //return false
  }
  // collision detection for bullets on enemy
  boolean collisionDetection2(ArrayList<alien> enemy) {
    for (alien a : enemy) { // for each enemy itterate through
      PVector dist = PVector.sub(a.position, position); // check the distance between bullet and enemy
      if (dist.mag() < a.radius) { // if bullet is inside the enemy radius then call breakup and add score
        a.breakUp(); // call breakup
        player1.score += 200; // add 200 to score
        return true; // return true
      }
    }
    return false; // return false
  }
  // remove bullet from the array
  void removeBullet() {
    bullets.remove(this); // removes this bullet from the array
  }
  // render the bulelts
  void render() {
    pushMatrix();  //saves current coordinate system to the stack
    translate(position.x, position.y);  //moves the coordinate system origin to the given points
    rotate(heading);  //rotate the bullet according to its current heading
    fill(255);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}

// begin the asteroid class
class asteroid {
  PVector position, velocity, acceleration;  // standard vectors for movement
  float heading, angle, radius;
  
  /* Take input of 5 floats, Radius of the asteroid = r, and use rand position to spawn asteroid between our b,c and d,e. 
  /  If default asteroid then anywhere on the map, else used for the split command spawn at the
  /  'split' asteroid position
  */
  asteroid(float r, float b, float c, float d, float e) {
    heading = random(-180, 180); // set the heading for our asteroid to move at.
    angle = heading; //- PI/2; // offset angle because ship is pointing vertical
    position = new PVector (random(b, c), random(d, e));
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(1.75);
    radius = r;
  }
  
  void updatePos() {         //update the motion of the object
    position.add(velocity);    //add the current velocity to the position of the ship
    //acceleration.mult(0);    //reset the acceleration to 0 by multiplication
  }

  void edgeDetection() {  //detects if the asteroid exceeds the frame edges.
    float buffer = 10;    //set the buffer to be the 10
    if (position.x > width + buffer) {  // if the x position is too far right
      position.x = -buffer;    // set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // if the x position is too far left
      position.x = width;  // set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // if the y position is too low
      position.y = -buffer+150;  // set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 150 < -buffer) {    // if y position is too high
      position.y = height;    // set the y position to be the bottom of the frame
    }
  }
  
  /* break a larger asteroid that is larger than 15 pixels into 2 pieces smaller asteroids at the old asteroids position and halve the radius and 
  /  remove the old asteroid, remove the old asteroid if it smaller equal to or smaller than 15 and spawn no new asteroids
  */
  void breakUp() {
    //if radius is larger than 15 then split otherwise just remove the asteroid.
    if (this.radius > 15){
      float b = this.radius / 2; // Take the radius and divide by 2 for creation of new asteroid.
      float c = this.position.x; // take the x position for use in the creation of new asteroids
      float d = this.position.y; // take the y position for use in the creation of new asteroids
      asteroids.add(new asteroid(b, c, c, d, d)); //creation of new asteroid with b, c, and d
      asteroids.add(new asteroid(b, c, c, d, d)); //creation of new asteroid with b, c, and d
      asteroids.remove(this); // remove old asteroid
    } else
    asteroids.remove(this); // remove asteroid if radius < 15 and spawn no new asteroids
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

// Begin the alien class
class alien {
  PVector position, velocity; //PVectors for motion
  float heading, angle, radius; //Store variables
  int size = 30;

  alien() {
    heading = random(-180, 180);
    angle = heading;
    position = new PVector (random(0, 800), random(0, 800));
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(3); // Sets the speed of the alien
    radius = 15; // Sets variable to use for shape creation
  }

  // Function to add the velocity to the position
  void updatePos() {
    position.add(velocity);
  }  
  
  // Function to remove the alien
  void breakUp() {
    enemy.remove(this);
  }
  
  // Function to spawn an alien, dependant on score
  void spawn() {
    if (player1.score >= target) {
      enemy.add(new alien());
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
    pushMatrix();  //Saves current coordinate system to the stack
    translate(position.x, position.y+size);  //Moves the coordinate system origin to the given points
    fill(0);  //Begins the creation of the shape for the alien
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
    popMatrix();  //Restores the previous coordinate system
  }
}

//Begin the Alaser Class
class Alaser {
  PVector position, velocity; //PVectors for motion
  int counterLaser;



  Alaser() {
    position = new PVector(enemy.get(0).position.x,enemy.get(0).position.y);  // Makes initial start position the (x,y) of the alien
    velocity = PVector.sub(player1.position, this.position);
    velocity.normalize();
    velocity.mult(5);
    counterLaser = 0;
  }

  //Function to add the velocity to the position
  void updatePos() {
    position.add(velocity);
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
    pushMatrix(); //Saves current coordinate system to the stack
    translate(position.x, position.y); //Moves the coordinate system origin to the given points
    fill(0);
    stroke(255);
    ellipse(0, 0, 5, 5); // Creates the shape
    popMatrix(); // Restores the previous coordinate system
  }
}