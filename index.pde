void setup() {
  size(800, 800);
  land = new Grid();
  path = new Path();
  taxi = new Taxi();
  passengers = new Passenger[10];
}

Passenger passengers[];
int L = 0;

class Passenger {
  int x1, y1, x2, y2;
  Passenger() {
    do {
      x1 = floor(random(20));
      y1 = floor(random(20));
      x2 = floor(random(20));
      y2 = floor(random(20));
    } while (!land.grid[x1][y1].road || !land.grid[x2][y2].road);
  }
  
  void show() {
    noFill();
    stroke(255, 255, 0);
    rect(x1 * 40, y1 * 40, 40, 40);
    stroke(0, 255, 0);
    rect(x2 * 40, y2 * 40, 40, 40);
  }
}

Taxi taxi;
Path path;
Grid land;

int gSize = 20; 
boolean cur = true;

int x1 = 0, y1 = 0, x2 = 0, y2 = 0;

void draw() {
  background(51);
  land.show();
  taxi.run();
  
  if (L < 10 && random(300) < 1) {
    passengers[L] = new Passenger();
    ++L;
    sortPassengers();
  }
  
  for (int i = 0; i < passengers.length; ++i) {
    if (passengers[i] == null) {
      break;
    }
    passengers[i].show();
  }
}

void pick() {
  for (int i = 1; i < passengers.length; ++i) {
    passengers[i-1] = passengers[i];
  }
}

void sortPassengers() {
  // Write sorting code here...
}
