
Dot [] dots;
int rows = 4;
int cols = 4;


//mm into pixels 
//pixel = dpi * mm / 25.4 mm (1 in)
//dpi set to 120 for Processing app window. 

int gridWidth=430; //width from edge of sensor row 1 to sensor row 4
int gridHeight=532;
int radius= 82; //diam of snesor pad. 
int margin=26; //parameter around the grid of sensors
int spacingX=26;
int spacingY=50;


void settings() {
  // Set dimensions of display window
  size(gridWidth+(2*margin), gridHeight+(2*margin));
}
void setup() {

  background(80);
  //if no sensor comment out function
  //trillSetup();


  dots= new Dot[16];
  ellipseMode(CORNER);
  //visualise the surface area of grid
  fill(255, 150);
  rectMode(CORNERS);
  rect(margin, margin, width-margin, height-margin, 5);
  int k=0;

  for (int i = 0; i < cols; i += 1) { 
    for (int j = 0; j < rows; j += 1) { 
      //id is now k

      dots[k]=new Dot(k, (margin/2+spacingX)+i*(radius+spacingX), (margin/2+spacingX)+j*(radius+spacingY), radius);
      dots[k]. setCol(255, 100, 200, 150);
      k++;
    }
  }
  displayAllDots();
  //println(k);
}

void draw() {


  location();

  //if no sensor comment out functions
  /*
  background(80);
   //visualise grid of sensors
   fill(255, 150);
   rectMode(CORNERS);
   rect(margin, margin, width-margin, height-margin, 5);
   displayTouch();
   displayAllDots();
   */
}

void location() {

  //find locX + locY center points. 
  for (int i=0; i<gNumSensors; i++) {
    float locX  =dots[i].x+(radius/2);
    float locY  =dots[i].y+(radius/2);
    // println(locX);

    fill(0, 0, 255, 100); //ugly but obvious 
    ellipseMode(CENTER);
    ellipse(locX, locY, 10, 10);
  }

  //need to confirm if [0] and [1] are of triggered or in close proximity sensors. 
  //do I need an extra array to parse active sesnors into?
  //calculate lastactivesensor then nextactivesensor
  //this then updates the index num to correspond. 

  float x1=dots[0].x+(radius/2);
  float x2=dots[1].x+(radius/2);
  float y1=dots[0].y+(radius/2);
  float y2=dots[1].y+(radius/2);
  //send to distance calc. 
  distance(x1, y1, x2, y2);
}

void distance(float _x1, float _y1, float _x2, float _y2) {

  //2D distance calc. 
  float a=_x1-_x2;
  float b=_y1-_y2;
  //distance = sqrt( a*a + b*b );
  float distance = sqrt((a*a)+(b*b));
  println(distance);


  float angle=90; //90 degress between sensor dots 
  //need to add proxHeight into this equation. And find centroid of this .
}


//future calc()s 
void speed() {

  //speed = distance/time;
}

/*
//relative proximity between each cap sensor. distance between dots and difference between them. 2 caps sensor = where I am in x,,y,z 
 calculate measurement = subtract how far apart each dot is subtract one from the other and overall reading from that tells me how high I am (distance). distamce in height between the 2. 
 if angle is 90º at 2 cap dot sensors distance . 2 x 90º traingle (isosolses triangle) proximity distance center point of each one squared. calculate size 
 
 */

/*
To Do
 
 - get proximity or height from each cap sensor - done this is variable proxHeight[i]
 - get sensor grid w and h 
 - get margin and therefor calculate overall canvas w and h 
 - get diam of cap sensor discs
 - accurately plot the cap sensors discs
 
 
 Distance and Location calculations 
 
 - Location is sensorID diam pixel location 
 - Calculate movement and trajectory of a line. 
 -     if(i*2 + 3 >= values.length) ?
 - distance is traingualtion between sensor[0] and sensor[1] and proxHeight. 
 
 */
