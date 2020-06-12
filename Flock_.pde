import java.util.Iterator;

// Flock of Boids 

class Flock {
  ArrayList<Boid> Boids;

  Flock() {
    Boids = new ArrayList<Boid>();
  }
  
  void addboid(Boid b) {
    Boids.add(b);
  }

  void render() {
    Iterator<Boid> it =
      Boids.iterator();
    while (it.hasNext()) {
      Boid b = it.next();
      b.render(Boids);
    }
  }
}
