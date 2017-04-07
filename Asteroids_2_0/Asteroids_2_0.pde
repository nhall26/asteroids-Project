/* //<>//
 # Group 14 Asteroids #
 ---------------------------------------
 Version 2.7
 ------------------------------------------
 Authors: 
     Sam Williamson
     Name
     Name
     Name
 ------------------------------------------
 Purpose: 
        "To work in your teams to develop 
 your own version of the asteroids game 
 using the Processing environment.
 ------------------------------------------
 How To Run:
        Simply click the "Run" button above
 to compile the game, it will open in a
 large window.
 ------------------------------------------
 Controls:
       UP - Thrust/Move Forward
       LEFT - Rotate the ship anticlockwise
       RIGHT - Rotate the ship clockwise
       SPACE - Fire projectile
 ------------------------------------------
 # TODO #
 Improve Collision detection
 ------------------------------------------

*/
 
// Initialise Variables to be used
// Assign objects of classes
Spaceship player1;
// Create dynamic arrays to store each of the following objects
ArrayList<bullet> bullets;
ArrayList<asteroid> asteroids;
ArrayList<alien> enemy;
ArrayList<Alaser> laser;
// Tracks whether the player wishes to try again after death
boolean tryAgain = false;
// Just used for the timer on the try again screen
int tryAgainCount = 4;
// Store the amount of asteroids per round
int asteroidCount = 5;
// Sets the time between each alien shot
int wait = 1000;
// Stores the variable time
int time;
// Stores the score the player should reach before an alien will spawn
int target = 1000;
// Stores what round the player is currently on
int round = 1;
// Tracks whether the user is currently on the Round Clear screen
boolean roundOver = false;
// Tracks if the player has decided to move to the next round
boolean nextRound = false;
// Just used for the timer on the next round screen
int nextRoundCount = 4;
boolean enemyExists;

void setup() {
  /* 
      Function:
        Initial setup function
      Author:
        Group effort
      Description:
        Initialises required arrays, creates and populates them
        Also creates the canvas.      
  */
  // Set a canvas size of 800x800
  size(800, 800);
  frameRate(60);
  // Initialise each array and object
  bullets = new ArrayList<bullet>();
  player1 = new Spaceship();
  asteroids = new ArrayList<asteroid>();
  enemy = new ArrayList<alien>();
  laser = new ArrayList<Alaser>();
  time = millis();
  
  for (int i = 0; i < asteroidCount; i++) {
    asteroids.add(new asteroid(30, 0, 800, 0, 800, false));
  }
}

void draw() {
  /* 
      Function:
        Draw function
      Author:
        Group effort, foundations laid by Sam.
      Description:
        Draws everything in the program
        Perform the majority of the game while the player has lives as follows
          1 - Update each object first with new parameters
          2 - Check the new position to see if it needs to wrap around the edges
          3 - Render the object
          4 - Check for collisions
          5 - Repeat for "x" amount of objects
  */
  // Black background
  background(0);
  // Run the main program while the player still has lives
  if (player1.lives >= 0) {
    // Gernate the header
    header();
    // Update position
    player1.updatePos();  
    // Check to see if the ship has exceeded the edges of the frame
    player1.edgeDetection();
    // Render the ship
    player1.render();
    // If the player collides with the asteroids
    if (player1.collisionDetection(asteroids)) {
        // Make the player die
        player1.death();
        // Delay the screen for a moment
        delay(50);
        // Reset the player
        player1.reset();
      } else if (player1.collisionDetection2(enemy)) {
        // If the player collides with the enemy ship, call the death function
        player1.death();
        // Delay the screne a moment
        delay(50);
        // Reset the player
        player1.reset();
        // Set eth enemyExists variable to false
        enemyExists = false;
      } else if (player1.collisionDetection3(laser)) {
        // If the player collides with an enemy laser, call the death function
        player1.death();
        // Delay the screne a moment
        delay(50);
        // Reset the player
        player1.reset();
      }
    // Generate asteroids
    for (int i = 0; i < asteroids.size(); i++) {
      asteroids.get(i).updatePos();
      asteroids.get(i).edgeDetection();
      asteroids.get(i).render();
    }
    // Generate and update the enemy ship
    for (int i = 0; i < enemy.size(); i++) {
      enemy.get(i).updatePos();
      enemy.get(i).edgeDetection();
      enemy.get(i).render();
    }
    // Generate and update the enemy laser
    for (int i = 0; i < laser.size(); i++) {
      laser.get(i).updatePos();
      laser.get(i).edgeDetection();
      laser.get(i).render();
      if (laser.get(i).counterLaser > 80){ // If laser counter > 80 thhen remove laser
          laser.remove(i); // Remove laser at index (i)
          i--; // Deincrement i so that it is the same length as laser size
        }
    }
    if ((player1.score >= target) & !enemyExists) {
      enemy.add(new alien());
      enemyExists = true;
      target += 1000;   //Increment target by 1000 so that another enemy will spawn after another 1000 points.
    }
    
    if (enemyExists == true) {
      if (millis() - time >= wait) {
        laser.add(new Alaser());
        time = millis();
      }
    }
    
    // Display controls
    fill(255);
    textAlign(CENTER);
    text("Use Left and Right to rotate, Up to thrust and Space to fire!", 400, height-5);
    // Turn or thrust the ship bassed in input
    if (keyPressed && roundOver == false) {
      if (key == CODED && keyCode == LEFT) {
        player1.turnShip(-0.06);
      } else if (key == CODED && keyCode == RIGHT) {
        player1.turnShip(0.06);
      } else if (key == CODED && keyCode == UP) {
        player1.thrust();
      }
    }
    
    // Update each bullet that the player fires
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).updatePos();
      bullets.get(i).edgeDetection();
      bullets.get(i).render();
      // Check if the bullets collide with anything or have travelled for a certain time
      if (bullets.get(i).collisionDetection(asteroids)) { // If any bullets i collides with any asteroids then remove bullets and i--
        bullets.remove(i); // Remove bullet at index i
        i--; // Deincrement i so that it is the same size as bullets array length
      } else if (bullets.get(i).collisionDetection2(enemy)) { // If any bullets i collides with any enemy then remove bullets and i--
        bullets.remove(i); // Remove bullet at index i
        i--; // Deincrement i so that it is the same size as bullets array length
        enemyExists = false;
      } else if (bullets.get(i).counter > 80){ // Otherwise if bullets counter of bullets(i) is greater than 80 then remove bullet
        bullets.remove(i); // Remove bullet at index i
        i--; // Deincrement i so that it is the same size as bullets array length
      }
    }
    
    //If all asteroids and enemies have been destroyed, move on to next round.
    if (nextRound == true) {
      background(0);
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
          asteroids.add(new asteroid(30, 0, 800, 0, 800, true));  // Spawn in new asteroids.
        }
        roundOver = false;
        nextRound = false;
        nextRoundCount = 4;
      }
    } else if (asteroids.size() == 0 && enemy.size() == 0) {
      background(0);
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
  // If the payer hs no lives, display the following
  else if (tryAgain) {
    background(0);
    if (tryAgainCount > 0) {
      text("Starting in " + (tryAgainCount-1), width/2, height/2);
      delay(1000);
      tryAgainCount--;
    } else {
      // Reset all of the arrays
      bullets = new ArrayList<bullet>();
      player1 = new Spaceship();
      asteroids = new ArrayList<asteroid>();
      enemy = new ArrayList<alien>();
      laser = new ArrayList<Alaser>();
      asteroidCount = 5;
      for (int i = 0; i < asteroidCount; i++) {
        asteroids.add(new asteroid(30, 0, 800, 0, 800, false));
      }
      time = millis();
      enemyExists = false;      
      tryAgainCount = 3;
      tryAgain = false;
      round = 1;
    }
  } else {
    // Display the game over screen
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
// When the space bar is released, fire a bullet
void keyReleased() {
  if (key == ' ') {
    bullets.add(new bullet());
  }
}
// Display the header
void header() {
  /* 
      Function:
        Header function
      Author:
        Predominantly Sam
      Description:
        Displays the top header which shows lives, score and title
  */
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
  // Display the player ship for the amount of lives the player has
  for (int i = 0; i < player1.lives; i++) {
    noFill();
    strokeWeight(2);
    beginShape();          // Draw a complex shape
    vertex(50+i*30, 75);    // Lower left vertex
    vertex(60+i*30, 70);       // Lower mid vertex
    vertex(70+i*30, 75);     // Lower right vertex
    vertex(60+i*30, 55);    // Upper mid vertex
    endShape(CLOSE);       // Finished creating shape
  }
}

// Begin the Spaceship class
class Spaceship {
  /* 
      Function:
        Spaceship class
      Author:
        Predominantly Sam, collision detection added by 
      Description:
        Creates a Spaceship object that is used to represent the player
        Used an object oriented approach due to previous familiarity with
        object-oriented languages. Starting the program like this has
        resulted in the final project as most classes are loosely based
        off of this one.
  */
  
  // Initialise valuees to be used by spaceship
  PVector position, velocity, acceleration;  // Create PVectors for motion
  float damping = 0.995;  // Damping value allows the gradual slow down effect
  float topspeed = 6;    // Set the topspeed of the ship
  float heading = 0;    // Set the heading (direction) of the ship
  int size = 10;      // Set the size of the bounding box containing the ship
  boolean thrusting = false;  // Keeps track of whether the ship is thrusting (for visual purposes)
  int lives = 3; // Starting count of lives
  boolean die = false; // Boolean to check dead, set to false to begin.
  // Stores the position in relation to the original coordinate matrix
  PVector newPosition;
  int score = 0;    // Tracks the current score of the player

  Spaceship() {  // The default spaceship object
    position = new PVector(width/2, height/2);  // Sets the initial position to be center-screen
    velocity = new PVector();    // Initialises the velocity vector
    acceleration = new PVector();  // Initialises the acceleration vector
    newPosition = new PVector(0, 0);  // Sets the position of the ship to be centre screen
  }

  void updatePos() {         // Update the motion of the object
    velocity.add(acceleration);  // Add acceleration values to the velocity vector
    velocity.mult(damping);    // Multiply the velocity values by the damping value
    velocity.limit(topspeed);  // Limit the velocity to the topspeed variable
    position.add(velocity);    // Add the current velocity to the position of the ship
    acceleration.mult(0);    // Reset the acceleration to 0 by multiplication
  }

  void applyForce(PVector force) {  // Apply the necessary amount of force
    PVector f = force;  // Get the values in the force vector and store them in the f vector
    acceleration.add(f);      // Add the values in th ef vector to those in acceleration
  }

  void turnShip(float angle) {  // Rotate teh ship
    heading += angle;
  }

  void thrust() {
    float angle = heading - PI/2; // Offset angle because ship is pointing vertical
    PVector force = new PVector(cos(angle), sin(angle)); // Converts the polar coordinate to cartesian
    force.mult(0.1);     // Multiply the force values by 0.1
    applyForce(force);   // Call the applyForce function
    thrusting = true;    // Set thrusting to true
  }

  void edgeDetection() {  // Detects if the ship excceeds the frame edges.
    float buffer = size*2;    // Set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // If the x position is too far right
      position.x = -buffer;    // Set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // If the x position is too far left
      position.x = width;  // Set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // If the y position is too low
      position.y = -buffer+125;  // Set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y-125 < -buffer) {    // If y position is too high
      position.y = height;    // Set the y position to be the bottom of the frame
    }
  }

  boolean collisionDetection(ArrayList<asteroid> asteroids) {
    for (asteroid a : asteroids) {// For each asteroid in asteroids go through
      PVector dist = PVector.sub(a.position, position); // Check the distance between asteroid position and position of player
      if (dist.mag() < a.radius) { // If dist is in the radius of the player return true and breakup said asteroid
        a.breakUp(); // Call breakup on asteroid
        return true; // Return true
      }
    }  
    return false; // Return true
  }
  
  boolean collisionDetection2(ArrayList<alien> enemy) {
    for (alien a : enemy) { // For each alien in enemy itterate through
      PVector dist = PVector.sub(a.position, position); // Get the distance between alien and position of player
      if (dist.mag() < a.radius) { // If dist between player and enemy is under the radius of the enemy then destroy alien and return true
        a.breakUp(); // Call breakup on a of enemy
        return true; // Return true
      }
    }
    return false; // Return true
  }
  
  boolean collisionDetection3(ArrayList<Alaser> laser) {
    for (Alaser a : laser) { // Itterate through for each alien laser
      PVector dist = PVector.sub(a.position, position); // If dist between player and enemy laser is under 2.5 then return true
      if (dist.mag() < 2.5) {
        return true; // Return true
      }
    }
    return false; // Return false
  }

  void render() {  // Render the ship
    pushMatrix();  // Saves current coordinate system to the stack
    translate(position.x, position.y+size);  // Moves the coordinate system origin to the given points
    rotate(heading);  // Rotate the ship according to its current heading    
    if (thrusting) {  
      stroke(255, 0, 0);  // Set a red stroke
      strokeWeight(0.5);  // Set teh stroke weight
      fill(249, 160, 27);  // Fill with a red/orange colour
      beginShape();  // Start creating the booster flame
      vertex(-size+2.5, size-4);  // All the vertexes of the complex shape
      vertex(-size+5, size+3.5);
      vertex(-size+8.75, size-0.25);
      vertex(1.25, size+8.5);
      vertex(3.75, size-0.25);
      vertex(6.25, size+3.5);
      vertex(size-2.5, size-4);
      endShape();        // Finish creating the shape
    }
    fill(0);  // Fill black (that way the flame doesn't start in the shape)
    stroke(255);    // Set a white stroke
    strokeWeight(2);  // Set teh stroke weight
    beginShape();          // Draw a complex shape
    vertex(-size, size);    // Lower left vertex
    vertex(0, -size);       // Upper mid vertex
    vertex(size, size);     // Lower right vertex
    vertex(0, size*3/5);    // Lower mid vertex
    endShape(CLOSE);       // Finished creating shape
    newPosition = new PVector(position.x + sin(heading) * size, position.y+size + cos(heading) * -size);
    popMatrix();           // Restores the previous coordinate system
    thrusting = false;     // Set thrusting to false
  }

  void death() {  // Decrement the lvies of the player and set die to true
    lives--;
    die = true;
  }

  void reset() {
    delay(1000);
    position = new PVector(width/2, height/2);  // Sets the initial position to be center-screen
    velocity = new PVector();    // Initialises the velocity vector
    acceleration = new PVector();  // Initialises the acceleration vector
    die = false;
  }
}

// Begin the bullet class
class bullet {
  /* 
      Function:
        Bullet class
      Author:
        Predominantly Sam, Collision detection added by 
      Description:
        Creates a bullet object that is used to represent the player's
        projectiles. This class is very similar to the Spaceship class
        but doesn't include acceleration due to the projectiles not
        needing to slow down as they simply disappear.
  */
  PVector position, velocity;  // Create PVectors for motion
  float heading, angle;  // Store the heading and angle
  int counter;  // Store the distance counter
  
  // Default contructor
  bullet() {
    heading = player1.heading;  // Set the ehading to be the same ass player1's heading
    angle = heading - PI/2; // Offset angle because ship is pointing vertical
    // Set the position to be the same as player1's original position
    position = new PVector (player1.newPosition.x, player1.newPosition.y); // Spawn at player x and y
    velocity = new PVector (cos(angle), sin(angle));  // Assign values to the velocity vector
    velocity.mult(5); // Multiple the values by 5
    counter = 0;  // Set the counter to be 0
  }

  void updatePos() {         // Update the motion of the object
    position.add(velocity);    // Add the current velocity to the position of the bullet
    counter++;  // Increment the counter
  }

  void edgeDetection() {  // Detects if the bullets excceeds the frame edges.
    float buffer = 10;    // Set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // If the x position is too far right
      position.x = -buffer;    // Set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // If the x position is too far left
      position.x = width;  // Set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // If the y position is too low
      position.y = -buffer+125;  // Set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 110 < -buffer) {    // If y position is too high
      position.y = height;    // Set the y position to be the bottom of the frame
    }
  }
  
  // Collision detection for the bullets, same as ship collision
  boolean collisionDetection(ArrayList<asteroid> asteroids) {
    for (asteroid a : asteroids) {// For each asteroid in asteroids go through
      PVector dist = PVector.sub(a.position, position); // Check the distance between asteroid and bullet.
      if (dist.mag() < a.radius) { // If bullet is inside the asteroid radius, then check for radius size
        a.breakUp(); // Call asteroid breakup function
        if (a.radius > 15) {  // If radius > 15, the asteroid will break into two smaller asteroids instead of being destroyed
          player1.score += 50; // Add 50 to player score
        } else {  // Otherwise, the asteroid is completely destroyed.
          player1.score += 100; // Add 100 to player score
        }
        return true; // Return true
      }
    }
    return false; // Return false
  }
  // Collision detection for bullets on enemy
  boolean collisionDetection2(ArrayList<alien> enemy) {
    for (alien a : enemy) { // For each enemy itterate through
      PVector dist = PVector.sub(a.position, position); // Check the distance between bullet and enemy
      if (dist.mag() < a.radius) { // If bullet is inside the enemy radius then call breakup and add score
        a.breakUp(); // Call breakup
        player1.score += 200; // Add 200 to score
        return true; // Return true
      }
    }
    return false; // Return false
  }
  // Remove bullet from the array
  void removeBullet() {
    bullets.remove(this); // Removes this bullet from the array
  }
  // Render the bulelts
  void render() {
    pushMatrix();  // Saves current coordinate system to the stack
    translate(position.x, position.y);  // Moves the coordinate system origin to the given points
    rotate(heading);  // Rotate the bullet according to its current heading
    fill(255);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}

// Begin the asteroid class
class asteroid {
  /* 
      Function:
        Asteroid class
      Author:
        Foundations by Sam, expanded by  
      Description:
        Creates an Asteroid object that generates and perforsm all of the
        functions that the asteroid takes in the game. Sam laid the
        foundation by first implementing the asteroids and developing the
        movement of each using sin and cos. A random number is generated
        between 1 and 2 for large asteroids, and 3 and 4 for small
        asteroids. This number determines what shape the asteroid should
        take.
  */
  PVector position, velocity;  // Standard vectors for movement
  float heading, angle, radius;
  int asteroidType;
  boolean smallAsteroid;
  
  /* Take input of 5 floats, Radius of the asteroid = r, and use rand position to spawn asteroid between our b,c and d,e. 
  /  If default asteroid then anywhere on the map, else used for the split command spawn at the
  /  'split' asteroid position
  */
  asteroid(float r, float b, float c, float d, float e, boolean small) {
    heading = random(-180, 180); // Set the heading for our asteroid to move at.
    angle = heading; //- PI/2; // Offset angle because ship is pointing vertical
    position = new PVector (random(b, c), random(d, e));
    while (position.x > (player1.position.x - 50) && position.x < (player1.position.x + 50)) {
      b += 10;
      c += 10;
      position.x = random(b,c);
    }
    while (position.y > (player1.position.y - 50) && position.y < (player1.position.y + 50)) {
      d += 10;
      e += 10;
      position.y = random(d,e);
    }
    velocity = new PVector (cos(angle), sin(angle));
    velocity.mult(1.75);
    if (small) {
      asteroidType = int(random(3,5));
    } else {
      asteroidType = int(random(1,3));
    }
    radius = r;
  }
  
  void updatePos() {         // Update the motion of the object
    position.add(velocity);    // Add the current velocity to the position of the ship
  }

  void edgeDetection() {  // Detects if the asteroid exceeds the frame edges.
    float buffer = 10;    // Set the buffer to be the 10
    if (position.x > width + buffer) {  // If the x position is too far right
      position.x = -buffer;    // Set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // If the x position is too far left
      position.x = width;  // Set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // If the y position is too low
      position.y = -buffer+150;  // Set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 150 < -buffer) {    // If y position is too high
      position.y = height;    // Set the y position to be the bottom of the frame
    }
  }
  
  /* break a larger asteroid that is larger than 15 pixels into 2 pieces smaller asteroids at the old asteroids position and halve the radius and 
  /  remove the old asteroid, remove the old asteroid if it smaller equal to or smaller than 15 and spawn no new asteroids
  */
  void breakUp() {
    // If radius is larger than 15 then split otherwise just remove the asteroid.
    if (this.smallAsteroid == false && radius > 15){
      float b = this.radius / 2; // Take the radius and divide by 2 for creation of new asteroid.
      float c = this.position.x; // Take the x position for use in the creation of new asteroids
      float d = this.position.y; // Take the y position for use in the creation of new asteroids
      asteroids.add(new asteroid(b, c, c, d, d, true)); // Creation of new asteroid with b, c, and d
      asteroids.add(new asteroid(b, c, c, d, d, true)); // Creation of new asteroid with b, c, and d
      asteroids.remove(this); // Remove old asteroid
    } else
    asteroids.remove(this); // Remove asteroid if radius < 15 and spawn no new asteroids
  }

  void render() {
    pushMatrix();  // Saves current coordinate system to the stack
    translate(position.x, position.y);  // Moves the coordinate system origin to the given points
    rotate(heading);  // Rotate the ship according to its current heading
    fill(0);
    stroke(255);
    if (asteroidType == 1) {
      beginShape();
      vertex(-24, 0);
      vertex(-24, -24);
      vertex(-12, -48);
      vertex(12, -48);
      vertex(36, -24);
      vertex(42, 0);
      vertex(18, 0);
      vertex(18, 24);
      vertex(12, 30);
      vertex(-6, 30);
      vertex(-12, 24);
      endShape(CLOSE);
    } else if (asteroidType == 2) {
      beginShape();
      vertex(-42, 0);
      vertex(-42, -30);
      vertex(0, -30);
      vertex(-12, -48);
      vertex(12, -48);
      vertex(42, -36);
      vertex(42, -24);
      vertex(18, -12);
      vertex(48, 12);
      vertex(36, 30);
      vertex(18, 12);
      vertex(-18, 42);
      endShape(CLOSE);
    } else if (asteroidType == 3) {
      beginShape();
      vertex(-8, 0);
      vertex(-8, -8);
      vertex(-4, -16);
      vertex(4, -16);
      vertex(12, -8);
      vertex(14, 0);
      vertex(6, 0);
      vertex(6, 8);
      vertex(4, 10);
      vertex(-2, 10);
      vertex(-4, 8);
      endShape(CLOSE);
    } else if (asteroidType == 4) {
      beginShape();
      vertex(-14, 0);
      vertex(-14, -10);
      vertex(0, -10);
      vertex(-4, -16);
      vertex(4, -16);
      vertex(14, -12);
      vertex(14, -8);
      vertex(6, -4);
      vertex(16, 4);
      vertex(12, 10);
      vertex(6, 4);
      vertex(-6, 14);
      endShape(CLOSE);
    }
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

  void edgeDetection() {  // Detects if the ship excceeds the frame edges.
    float buffer = size*2;    // Set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // If the x position is too far right
      position.x = -buffer;    // Set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // If the x position is too far left
      position.x = width;  // Set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // If the y position is too low
      position.y = -buffer+175;  // Set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y < -buffer + 175) {    // If y position is too high
      position.y = height;    // Set the y position to be the bottom of the frame
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
  void edgeDetection() {  // Detects if the ship excceeds the frame edges.
    float buffer = 10;    // Set the buffer to be the size of the shape * 2
    if (position.x > width + buffer) {  // If the x position is too far right
      position.x = -buffer;    // Set the x position to be the negative buffer (-20)
    } else if (position.x < -buffer) {  // If the x position is too far left
      position.x = width;  // Set the x position to be the width of the canvas
    }
    if (position.y > height + buffer) {  // If the y position is too low
      position.y = -buffer+125;  // Set the y position to be the top of the frame (125 just makes it appear nicer)
    } else if (position.y - 110 < -buffer) {    // If y position is too high
      position.y = height;    // Set the y position to be the bottom of the frame
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