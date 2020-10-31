class Taxi {
  PVector pos;  // position of taxi in real time
  PVector prev_pos;  // position of taxi in previous cell
  float cur_angle;  // angle the image isto be alligned to
  PImage taxi_img;  // storing the .png image
  PVector c;  // current alignment of taxi
  PVector n;  // next alignment of taxi
  int it;  // iterator for one cell to another movement
  int path_it;  // iterator for the whole paths progress
  PVector[] path; // stores path
  
  Taxi()
  {
    path = new PVector[41];
    pos = new PVector(20.0,20.0);
    prev_pos = new PVector();
    cur_angle = HALF_PI;
    c = new PVector(1.0, 0.0);
    n = new PVector(0.0, 0.0);
    it = 0;
    path_it = 0;
    imageMode(CENTER);
    taxi_img = loadImage("taxi1.png");
  }
  
  void addPath(Cell[] new_path)  //  gives a new path to taxi to move on
  {
    int len;
    for(len=0; new_path[len]!=null; len++);
    if(len==0)
      return;
    path = new PVector[len-1];
    for(int i=1; i<len; i++)
    {
      path[i-1] = new PVector();
      path[i-1].x = new_path[i].givePos().x - new_path[i-1].givePos().x;
      path[i-1].y = new_path[i].givePos().y - new_path[i-1].givePos().y;
    }
    n = (path.length!=0)? path[0] : n;
    c.x = new_path[0].givePos().x - int(pos.x/40);
    c.y = new_path[0].givePos().y - int(pos.y/40);
    pos.x = pos.x + c.x*20;
    pos.y = pos.y + c.y*20;
    cur_angle = PVector.angleBetween(c,new PVector(1.0,0));
    cur_angle = (cur_angle==HALF_PI)? cur_angle*c.y + HALF_PI : cur_angle + HALF_PI;
    prev_pos = pos.copy();
    loop();
  }
  
  void run() // Main uses this to keeo the taxi running
  {
    if(it++ < 20)
    {
      calculateMove(); // calculate next frame
    }
    else
    {
      moveNext(); // when one cell is moved up
    }
  }
  
  void display(int i) // i is for when taxi is turning otherwise is kept 0; the function displays the taxi as per the calculated position and alignment
  {
    push();
    translate(pos.x,pos.y); // moves origin to position
    rotate(cur_angle + i*PI/40); // rotates axis
    image(taxi_img,0,0,taxi_img.width*20.0/taxi_img.height,20);
    pop();
  }
  
  void calculateMove() // calculates how to move to next frame depending on c and n
  {
    int i = it;
    
    if(n.x==0 && n.y==0) // if there is no path to run on i.e. if taxi is idle
    {
      it--;
      display(0);
      return;
    }
    else if( PVector.dist(c, n)==0 ) // if moving in a straight line
    {
      i = 0;
      pos.x += 2*c.x;
      pos.y += 2*c.y;
    }
    else // if turning
    {
      pos.x = prev_pos.x + c.x*20.0*sin(it*PI/40) + n.x*20.0*(1.0 - cos(it*PI/40));
      pos.y = prev_pos.y + c.y*20.0*sin(it*PI/40) + n.y*20.0*(1.0 - cos(it*PI/40));
    }
    if( c.x*n.y==-1 | c.y*n.x==1)
    {
      i*=-1;
    }
    display(i); // called in every frame
  }
  
  void moveNext() // one cell moved, calculate next cell
  {
    it = 0;
    c = n;
    cur_angle = PVector.angleBetween(c,new PVector(1.0,0));
    cur_angle = (cur_angle==HALF_PI)? cur_angle*c.y + HALF_PI : cur_angle + HALF_PI;
    display(0);
    if( path_it<(path.length-1) )
    {
      path_it++;
      n = path[path_it];
      prev_pos = pos.copy();
    }
    else // if path ends
    {
      pos.x = pos.x + n.x*20;
      pos.y = pos.y + n.y*20;
      n.x = 0.0;
      n.y = 0.0;
      path_it = 0;
      x = 1;
    }
  }
};
