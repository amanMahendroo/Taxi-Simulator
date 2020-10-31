class minNode {
  int i;
  int j;
  int c;
  minNode(int _i, int _j, int _c) {
    i = _i;
    j = _j;
    c = _c;
  }
}

class Path {
  int step = 0;
  int[] start = {0, 0};
  int[] end = {0, 0};
  minNode[] checking;
  int checkingLength;
  boolean found = false;
  Cell[] path;
  int[][] neighbors = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
  
  Path() {
    checking = new minNode[100];
    path = new Cell[100];
  }
  
  boolean cellComp(int x1, int y1, int x2, int y2) {
    return (x1 == x2) && (y1 == y2);
  }
  
  void resetScores() {
    for (int i = 0; i < land.grid.length; ++i) {
      for (int j = 0; j < land.grid.length; ++j) {
        land.grid[i][j].score = 1000;
        land.grid[i][j].checked = false;
      }
    }
    step = 0;
    found = false;
    checkingLength = 1;
  }
  
  Cell[] retrace(int _i, int _j) {
    Cell[] t_path = new Cell[400];
    minNode cur = new minNode(_i, _j, 0);
    int count = 0;
    
    while (!cellComp(cur.i, cur.j, start[0], start[1])) {
      t_path[count] = new Cell(cur.i, cur.j, 1);
      minNode temp = new minNode(cur.i, cur.j, 0);
      int a = cur.i, b = cur.j;
      if (a + 1 < gSize && a + 1 >= 0 && b < gSize && b >= 0) {
        if (land.grid[a+1][b].score < land.grid[temp.i][temp.j].score) {
          temp.i = a+1;
          temp.j = b;
        }
      }
      if (a - 1 < gSize && a - 1 >= 0 && b < gSize && b >= 0) {
        if (land.grid[a-1][b].score < land.grid[temp.i][temp.j].score) {
          temp.i = a-1;
          temp.j = b;
        }
      }
      if (a < gSize && a >= 0 && b + 1 < gSize && b + 1 >= 0) {
        if (land.grid[a][b+1].score < land.grid[temp.i][temp.j].score) {
          temp.i = a;
          temp.j = b+1;
        }
      }
      if (a < gSize && a >= 0 && b - 1 < gSize && b - 1 >= 0) {
        if (land.grid[a][b-1].score < land.grid[temp.i][temp.j].score) {
          temp.i = a;
          temp.j = b-1;
        }
      }
      ++count;
      cur = temp;
    }
    
    Cell[] finPath = new Cell[400];
    
    for (int i = 0; i < count; ++i) {
      finPath[i] = t_path[count-i-1];
    }
    
    return finPath;
  }
  
  Cell[] getPath(float x1, float y1, float x2, float y2) {
    resetScores();
    
    start[0] = floor(x1/40);
    start[1] = floor(y1/40);
    end[0] = floor(x2/40);
    end[1] = floor(y2/40);
    
    checking[0] = new minNode(start[0], start[1], step);
    land.grid[0][0].score = step;    
    
    while (!found) {
      // execute 1 iteration
      ++step;
      
      for (int i = 0; i < checkingLength; ++i) {
        if (cellComp(checking[i].i, checking[i].j, end[0], end[1])) {
          found = true;
          Cell[] path = retrace(checking[i].i, checking[i].j);
          return path;
        }
      }
      minNode[] buffer = new minNode[100];
      int k = 0;
      for (int i = 0; i < checkingLength; ++i) {
        land.grid[checking[i].i][checking[i].j].score = step;
        land.grid[checking[i].i][checking[i].j].checked = true;
        for (int j = 0; j < neighbors.length; ++j) {
          int a = checking[i].i + neighbors[j][0];
          int b = checking[i].j + neighbors[j][1];
          if (a >= 0 && a < gSize && b >= 0 && b < gSize) {
            if (!land.grid[a][b].checked && land.grid[a][b].road && land.grid[a][b].score == 1000) {
              buffer[k] = new minNode(a, b, step);
              ++k;
            }
          }
        }
      }
      for (int i = 0; i < buffer.length; ++i) {
        checking[i] = buffer[i];
      }
      checkingLength = k;
    }
    Cell[] x = {new Cell(-1, -1, 1)};
    return x;
  }
}
