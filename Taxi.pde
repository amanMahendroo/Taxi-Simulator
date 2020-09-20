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
    pos = new PVector(40.0,20.0);
    prev_pos = pos;
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
    path = new PVector[new_path.length-1];
    for( int i=1; i<new_path.length; i++ )
    {
      path[i-1] = subtract( new_path[i].givePos(), new_path[i-1].givePos());
    }
    if( PVector.dist( n, new PVector(0,0) )==0 )
    {
      n = path[0];
    }
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
          
    if( PVector.dist(c, n)==0 )
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
    grid.show();
    
    if( c.x*n.y==-1 | c.y*n.x==1)
    {
      i*=-1;
    }
    
    display(i);
    
    delay(15);
  }
  
  void moveNext()
  {
    it = 0;
    prev_pos = pos.copy();
    
    c = n;
    cur_angle = PVector.angleBetween(c,new PVector(1.0,0));
    if(cur_angle == HALF_PI)
    {
      cur_angle *= c.y;
    }
    cur_angle += HALF_PI;
    
    
    if( path_it<(path.length-1) )
    {
      path_it++;
      n = path[path_it];
    }
    else
    {
      noLoop();
    }
  }
};

PVector subtract(PVector a, PVector b)
{
  return new PVector( (a.x-b.x)/40.0, (a.y-b.y)/40.0);
}
