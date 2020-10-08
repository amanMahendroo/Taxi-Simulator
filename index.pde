void setup() {
  size(800, 800);
  land = new Grid();
  path = new Path();
  taxi = new Taxi();
}

Taxi taxi;
Path path;
Grid land;
Cell[] testPath = new Cell[400];

int gSize = 20; 
boolean cur = true;

int x1 = 0, y1 = 0, x2 = 0, y2 = 0;

void draw() {
  background(51);
  land.show();
  taxi.run();
  
  for (int i = 0; i < testPath.length; ++i) {
    if(testPath[i] == null) {
      break;
    }
    fill(0, 255, 0);
    circle(40 * testPath[i].pos.x + 20, 40 * testPath[i].pos.y + 20, 5);
  }
}

void mousePressed() {
  if (x2 == 0) {
    if (x1 == 0) {
      x1 = mouseX;
      y1 = mouseY;
      return;
    }
    x2 = mouseX;
    y2 = mouseY;
    return;
  }
  testPath = path.getPath(x1, y1, x2, y2);
  taxi.addPath(testPath);
  x1 = 0;
  x2 = 0;
}
