/* Flocking Simulator made with basic Craig Reynold's Boids program 
 * Inspired by The Nature of Code - Daniel Shiffman
 * Concepts Implemented from https://natureofcode.com/book/
 *
 * Click the mouse to add a Boid
 * Control the Wind Direction using UP, DOWN, LEFT and RIGHT arrow keys and their combinations.  
 *
 */




Flock f; 
void setup() {
  size(1000, 800);
  f = new Flock();
  for (int i = 0; i < 150; i++) {
    f.addboid(new Boid(random(width),random(height)));
  }
}
void draw() {
  background(23);
  f.render();
}


// Add Boids with Mouse Click
void mousePressed() {
  f.addboid(new Boid(mouseX,mouseY));
}
