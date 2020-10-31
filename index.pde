void setup() {  // sets up canvas, initialises objects
  size(800, 800);
  land = new Grid();
  path = new Path();
  taxi = new Taxi();
  passengers = new Passenger[10];
  cur_pas = new Passenger();
}

class Passenger {
  int x1, x2, y1, y2;

  Passenger() {
    do {
      x1 = floor(random(20));
      y1 = floor(random(20));
      x2 = floor(random(20));
      y2 = floor(random(20));
    } while (!land.grid[x1][y1].road || !land.grid[x2][y2].road);  // randomizing pickup and drop locations of passenger
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
Passenger cur_pas;
Passenger passengers[];

int L = 0;
int p_state = 0;  // stage the taxi is in: 0 if there is passenger is dropped or the taxi is idle, 1 if taxi is moving towards passenger, 2 during the ride
int x = 1;  // if a path has reached its end, x is equalled to 1
int delay = 0;  // controlling delay when passenger is being picked/dropped
int gSize = 20;  // size of grid


int x1 = 0, y1 = 0, x2 = 0, y2 = 0;

void draw() {
  if(x==1 && ( p_state!=0 || L!=0 ))  // to calculate next path whenever a path has ended
  {
    if( p_state==0 )  // sets taxi in trajectory to pickup the next passenger including deciding which passenger to pick
    {
      int temp = sortPassengers();  // decides which passenger to pick
      cur_pas = passengers[temp];
      pick(temp);
      taxi.addPath( path.getPath( taxi.pos.x, taxi.pos.y, float(cur_pas.x1 * 40), float(cur_pas.y1 * 40) ) );  // feeds taxi the path to pickup
      p_state++;
      x = 0;
    }
    else if( p_state==1 )  // sets taxi in trajectory to drop the passenger
    {
      if(delay!=100)
      {
        delay++;  // delay to account for passenger movement
      }
      else
      {
        delay = 0;
        taxi.addPath( path.getPath( float(cur_pas.x1 * 40), float(cur_pas.y1 * 40) , float(cur_pas.x2 * 40), float(cur_pas.y2 * 40) ) ); // feeds taxi the path to drop
        p_state++;
        x = 0;
      }
    }
    else  // passenger has been dropped, setting p_state back to 0
    {
      if(delay!=100)
      {
        delay++;  // delay to account for passenger movement
      }
      else
      {
        p_state = 0;
        delay = 0;
      }
    }
  }
  
  land.show();  // shows the grid
  taxi.run();  // triggers method of taxi to calculate its next frame and display frame accordingly
  
  if (L < 9 && random(200) < 1) {  // randomly spawns passengers
    passengers[L] = new Passenger();
    ++L;
  }
  
  for (int i = 0; i < L; ++i) {   // show passengers in queue (yellow for pickup location, green for destination)
    if (passengers[i] == null) {
      break;
    }
    passengers[i].show();
  }
  if(p_state!=0) // if passengers exist, show the current passenger (blue circle)
  {
    cur_pas.show();
    stroke(0,0,255);
    circle(cur_pas.x1*40+20, cur_pas.y1*40+20, 10);
    circle(cur_pas.x2*40+20, cur_pas.y2*40+20, 10);
  }
}

void pick(int a) {  // removes picked passenger from array
  L--;
  if( a==0 && L==0 )
    return;
  for (int i = a+1; i < L+1; ++i) {
    passengers[i-1] = passengers[i];
  }
}
