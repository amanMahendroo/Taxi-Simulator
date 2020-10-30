int sortPassengers()
{
  Cell[][] paths = new Cell[12][40]; // 3 sets of 4 arrays for each of the three passengers containing paths from taxi to arrival, arrival to destination, destination to other passenger arrivals
  Passenger temp[] = new Passenger[3]; // Stores the three passengers temporarily
  if( L==1 )
  {
    return 0; // If there is only one passenger in the queue
  }
  else if( L==2 ) // for 2 passengers in queue
  {
    int a = path.getPath(taxi.pos.x, taxi.pos.y, passengers[0].x1, passengers[0].y1).length + path.getPath(passengers[0].x2, passengers[0].y2, passengers[1].x1, passengers[1].y1).length ;
    int b = path.getPath(taxi.pos.x, taxi.pos.y, passengers[1].x1, passengers[1].y1).length + path.getPath(passengers[1].x2, passengers[1].y2, passengers[0].x1, passengers[0].y1).length ;
    return ( a<b )? 0:1;
  }
  else  // for 3 or more than 3 passengers in queue
  {
    for(int i=0; i<3; i++)
    {
      temp[i] = passengers[i];//L-3 + i];
    }
    for(int i=0; i<3; i++)
    {
      int j;
      paths[i*4] = path.getPath(taxi.pos.x, taxi.pos.y, temp[i].x1 * 40, temp[i].y1 * 40);
      paths[i*4 + 1] = path.getPath(temp[i].x1 * 40, temp[i].y1 * 40, temp[i].x2 * 40, temp[i].y2 * 40);
      j = (i+1) % 3;
      paths[i*4 + 2] = path.getPath(temp[i].x2 * 40, temp[i].y2 * 40, temp[j].x1 * 40, temp[j].y1 * 40);
      j = (i+2) % 3;
      paths[i*4 + 3] = path.getPath(temp[i].x2 * 40, temp[i].y2 * 40, temp[j].x1 * 40, temp[j].y1 * 40);
    }
    int order = giveOptimum(paths);  // uses paths[][] array taking the lengths oh each path into account thus returning which order to pick
    return int(order/2);  // for returning which is the optimum passenger to pick first
  }
}

int giveOptimum(Cell[][] paths)
{
  int[] A = {0,0,0,0,0,0}; // A parameter
  int[] B = {0,0,0,0,0,0}; // B parameter
  
  for(int i=0; i<3; i++)
  {
    int j = (i+1)%3;
    int k = (i+2)%3;
    
    A[i*2] += paths[i*4 + 1].length;
    B[i*2] += paths[i*4].length;
    A[i*2 + 1] += paths[i*4 + 1].length;
    B[i*2 + 1] += paths[i*4].length;
    A[i*2] += paths[j*4 + 1].length;
    A[i*2 + 1] += paths[k*4 + 1].length;
    B[i*2] += paths[i*4 + 2].length;
    B[i*2 + 1] += paths[i*4 + 3].length;
    B[i*2] += paths[j*4 + 2].length;
    B[i*2 + 1] += paths[k*4 + 3].length;
  }
  int min = 400;
  int order = 0;
  for(int i=0; i<6; i++)
  {
    if( A[i] + 2*B[i] < min)  // minimum A+B gives optimum order
    {
      order = i;
      min = A[i] + 2*B[i];
    }
  }
  return order;
}
