// class Describing Single Boid
//Toggle The Alignment, Seperation and Cohesion at void flock() 
// Change wind magnitude in void update()

class Boid {  

  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  float r;
  PVector position;  // Midpoint of the Triangle's Base 
  PVector velocity;
  PVector acceleration;

  Boid(float x, float y) {
    position = new PVector(x, y);
    acceleration = new PVector(0, 0);
    velocity =  PVector.random2D();

    r = 10;
    maxspeed = 6;
    maxforce = 0.04;
  }
  void flock(ArrayList<Boid> boids) {
    PVector seperation = separate(boids);   // Separation
    PVector alignment = align(boids);      // Alignment
    PVector cohed = cohesion(boids);   // Cohesion

    seperation.mult(3.5);  //Modulate magnitude here
    alignment.mult(1.0);
    cohed.mult(0.5);

    applyForce(seperation);
    applyForce(alignment);
    applyForce(cohed);
  }

  void render(ArrayList<Boid> boids) {
    flock(boids);
    update();
    walls();
    display();
  }
  void display() {

    float theta = velocity.heading() + radians(90);  // Rotating boid to velocity
    pushMatrix();  //Enable 2D transformations on each boid
    translate(position.x, position.y);
    rotate(theta);
    fill(255, 255, 0, 200);
    stroke(255);

    // Drawing shape
    beginShape(TRIANGLES);
    vertex(0, -2*r);
    vertex(-r, 2*r);
    vertex(r, 2*r);
    endShape();

    popMatrix();
  }

  void update() {  //Vector Changes
    // Update velocity
    acceleration.add(Wind(0.06));
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    // Update Location
    position.add(velocity);
    //Reset Acceleration
    acceleration.mult(0);

  }

  // Teleporting on the Borders
  void walls() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  //To use for Alignment, Seperation and Cohesion

  void applyForce(PVector force) {  
    //Assuming Unit Mass
    acceleration.add(force);
  }

  // Calculate Steering Force
  // Alignment, Seperation and Cohesion will be applied using steer
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  //Approach Direction
    desired.setMag(maxspeed);  // Scale to maximum speed
    // Steering force drives Velocity to Approach Direction 
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  
    return steer;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 50.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);

      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep Count
      }
    }

    if (count > 0) {
      steer.div((float)count);
    }


    if (steer.mag() > 0) {
      steer.setMag(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment

  PVector align (ArrayList<Boid> boids) {
    float neighbourdist = 70;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbourdist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, velocity);  
      steer.limit(maxforce);    // Calculating Average Velocity in Neighbourhood
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion

  PVector cohesion (ArrayList<Boid> boids) {
    float neighbourdist = 40;
    PVector sum = new PVector(0, 0);   
    int count = 0;
    for (Boid other : boids) {// Accumulate all positions
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbourdist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }
  
 PVector Wind(float windmag){
   PVector windy = new PVector(0,0);
    if(keyCode == UP) windy.add(new PVector(0,1));
    if(keyCode == DOWN) windy.add(new PVector(0,-1)); 
    if(keyCode == LEFT) windy.add(new PVector(1,0)); 
    if(keyCode == RIGHT) windy.add(new PVector(-1,0)); 
      
    windy.setMag(-windmag);
    return windy;      
  }
}
