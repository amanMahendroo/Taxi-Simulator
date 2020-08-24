void setup() {
  size(800, 800);
  land = new Grid();
}

int gSize = 20; 
Grid land;
boolean cur = true;

void draw() {
  background(51);
  land.show();
  fill(255);
  ellipse(width / 2, height / 2, 5, 5);
}
