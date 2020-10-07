class Taxi {
  PVector pos;
  PVector prev_pos;
  float cur_angle;
  PImage taxi_img;
  PVector c;
  PVector n;
  int it;
  int path_it;
  PVector[] path;
  
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
  
  void addPath(Cell[] new_path)
  {
    int len;
    for(len=0; new_path[len]!=null; len++);
    
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
  
  void run()
  {
    if(it++ < 20)
    {
      calculateMove();
    }
    else
    {
      moveNext();
    }
  }
  
  void display(int i)
  {
    push();
    translate(pos.x,pos.y);
    rotate(cur_angle + i*PI/40);
    image(taxi_img,0,0,taxi_img.width*20.0/taxi_img.height,20);
    pop();
  }
  
  void calculateMove()
  {
    int i = it;
    
    if(n.x==0 && n.y==0)
    {
      it--;
      display(0);
      return;
    }
    else if( PVector.dist(c, n)==0 )
    {
      i = 0;
      pos.x += 2*c.x;
      pos.y += 2*c.y;
    }
    else
    {
      pos.x = prev_pos.x + c.x*20.0*sin(it*PI/40) + n.x*20.0*(1.0 - cos(it*PI/40));
      pos.y = prev_pos.y + c.y*20.0*sin(it*PI/40) + n.y*20.0*(1.0 - cos(it*PI/40));
    }
    
    land.show();
    
    if( c.x*n.y==-1 | c.y*n.x==1)
    {
      i*=-1;
    }
    display(i);
  }
  
  void moveNext()
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
    else
    {
      pos.x = pos.x + n.x*20;
      pos.y = pos.y + n.y*20;
      n.x = 0.0;
      n.y = 0.0;
      path_it = 0;
    }
  }
};
