

int rows = 4;
int cols = 4;
float val=0;
int indexId=0;


//mm into pixels 
//pixel = dpi * mm / 25.4 mm (1 in)
//dpi set to 120 for Processing app window. 

int gridWidth=430; //width from edge of sensor row 1 to sensor row 4
int gridHeight=532;
int radius= 82; //diam of snesor pad. 
int margin=26; //parameter around the grid of sensors
int spacingX=26;
int spacingY=50;
int size=10;

//needed to get raw co-ordinates so can be used cross platform. 
int xCoord []={81, 189, 297, 405, 81, 189, 297, 405, 81, 189, 297, 405, 81, 189, 297, 405};
int yCoord []={81, 81, 81, 81, 213, 213, 213, 213, 345, 345, 345, 345, 477, 477, 477, 477};
float newXCoord [] = new float [16];
float newYCoord []=new float [16];

float centroidX;
float centroidY;
int biggest = 0;
int biggestVal=0;
int lastBiggest=-1;
int newX;
int newY;

void settings() {
  // Set dimensions of display window
  size(gridWidth+(2*margin), gridHeight+(2*margin));
}

void visualGrid() {
  //visual Grid
  fill(255, 150);
  rectMode(CORNERS);
  rect(margin, margin, width-margin, height-margin, 5);
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      stroke(255); 
      ellipseMode(CORNER);
      ellipse((margin/2+spacingX)+j*(radius+spacingX), (margin/2+spacingY)+i*(radius+spacingY), radius, radius);
    }
  }
}
void setup() {

  background(80);
  ellipseMode(CENTER);
  //if no sensor comment out function
  trillSetup();

  //visual Grid
  visualGrid();
}


void draw() {



  //if no sensor comment out functions

  background(80);
  visualGrid();
  calcPeakValIndex();
  visualiseBiggestCoord();
  
  calcRawPeakVal();


  int posX=(margin/2+spacingX)+(newX+radius/2);
  int posY= (margin/2+spacingY)+(newY+radius/2);
  //println(posX);
  fill(0, 255, 0);
  ellipseMode(CENTER);
  ellipse(posX, posY, 30, 30); //draws rect around biggest one
}



void calcPeakValIndex() { //working
  //calculate index in array with the peak value 
  biggest = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {

      if (gSensorReadings[i*4+j] > gSensorReadings[biggest]) {  //is the array the raw value array or the new fixed coordinate array? 


        biggest = i * 4 + j;
        //println(biggest); //which [index] has biggest val 
        //pass into coord index.
      }
    }
  }
}



void visualiseBiggestCoord() { //working

  //identify biggest co-ord and display it.

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {  
      //color col = xCoord[i*4+j] * 256;  //is the array the raw value array or the new fixed coordinate array? 

      if (i*4+j==biggest) {
        //draws positions of biggest one

        newX=j*(radius+spacingX);
        newY=i*(radius+spacingY);
        //println("x"+i*50);
        //println("y"+j*50);
      }
    }
  }
}


//calculate the peak raw data spike in the array of sensor readings. 
void calcRawPeakVal() { //not working
  //store the peak value (not the coordinate/index of the peak value )
  biggestVal = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      //gSensorReadings[] is the raw sensor values array. 
     try{
      if (gSensorReadings[i*4+j] > gSensorReadings[biggestVal]) {
        println("triggerReading: "+ gSensorReadings[i*4+j]);
        //use that val to normalise all outputs. 
        
        gSensorReadings[i*4+j] = gSensorReadings[i*4+j] / biggestVal; //normalise calc
        
        //normalized = (x-min(x))/(max(x)-min(x))
        //int normalized = ((gSensorReadings[i*4+j]-0)/(100-0));
        //println("normalized: "+normalized);
        
        println("update normalised: "+gSensorReadings[i*4+j]); //not executing
 
        biggestVal = gSensorReadings[i*4+j]; //not executing 
        println("biggestVal: "+biggestVal); //should be 0 and 1s if normalisation in use
   }
     }
     catch(ArithmeticException e) {
       println("now zero");
     }
    }
  }
} 


//does 'biggest' get parsed into 'centroidX'? //join up with the centroidCalc? 


// create a list of x and y coordinates for each sensor, 
//and weight these coordinate values based on how much energy at each position,<-- how to do this?  
//for loop through the data input and match index ID to coord array ID 

void centroidCalc() {
  //calculate the centre of mass of a 4 * 4 grid of values
  centroidX = 0;
  centroidY = 0; //need to clear everytime 

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {

      centroidX+=i * (xCoord[i*4+j]);
      centroidY+=j * (yCoord[i*4+j]);



      //prob need to map centroidX and Y to canvas width and height.
      //width of grid/number elements and then do heightofgrid/number elements 
      //or just draw it without the grid.
    }
  }
  centroidX=(centroidX/16);
  centroidY=(centroidY/16);
  println(" centroidX: "+centroidX);
  println(" centroidY: "+centroidY);
}


/* NOTES
 //and then get the average x and the average y coordinate, and this gives you the centroid.
 //generate co-ordinate for each one - weight them based on energy 
 //if no energy they are zero
 //if energy they are what they should be 
 // only energy in 3,3 then this is *by energy 
 
 //nomalise energy by mapping 0,900,0,1
 //max looks like 1
 //if 3,3 has energy this has 1. 
 //if some have energy it goes to slight movement. 
 //draw in high resolution. 
 //map pixel resolution on to correct place 
 
 //multiply position by energy in grid. Average x and avergage y 
 //if x and y 
 //max size of grid in pixels 200x200 normalise energy of readings between 0 and 1 
 //take centroid X and multiple by sizeofGrid/amount of grid elements (3). if 3 is number of item (0,1,2,3) o
 //total width = 200 . 1=100 , 2=150 
 //divide by 900 to get normalised val.margin + centroidX * then width of grid / numitems
 
 //is it in linear? no it is Expodential. 
 //if 1 cm away 70 
 //if contact 700 
 //biggest, normalised energy then passed into centroidX 
 */
