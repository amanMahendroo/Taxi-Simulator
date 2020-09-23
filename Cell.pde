class Cell {
  boolean road = false;
  boolean checked = false;
  int score;
  PVector pos;
  Cell(int x, int y, int s) {
    pos = new PVector(x, y);
    if (s == 1) {
      road = true;
    }
  }
  
  void show() {
    fill(102);
    if (road) {
      fill(51);
    }
    stroke(255, 10);
    rect(pos.x, pos.y, width / gSize, height / gSize);
  }
  
  PVector givePos() {
    return pos;
  }
}
