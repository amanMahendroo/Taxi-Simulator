class Cell {
  boolean state = false;
  PVector pos;
  Cell(int x, int y, int s) {
    pos = new PVector(x, y);
    if (s == 1) {
      state = true;
    }
  }
  
  void show() {
    fill(102);
    if (state) {
      fill(51);
    }
    stroke(255, 10);
    rect(pos.x, pos.y, width / gSize, height / gSize);
  }
}
