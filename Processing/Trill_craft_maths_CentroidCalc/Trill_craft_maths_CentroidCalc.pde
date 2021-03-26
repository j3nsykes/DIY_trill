
//mm into pixels
//pixel = dpi * mm / 25.4 mm (1 in)
//dpi set to 120 for Processing app window.
//new diamond design 65mm x 60mm

int gridWidth=284; //width from edge of sensor row 1 to sensor row 4
int gridHeight=307; //307
int totalSensorPads = 24;

int radius= 32; //diam of snesor pad.
int spacingX=4;
int spacingY=4;
float size = 30;
int margin=26; //parameter around the grid of sensors


float x, y;
float centroidX, centroidY;
int biggest = 0;
int biggestVal=0;
int lastBiggest=-1;
float newX, newY;
float norm;
float normalisedData [] = new float [totalSensorPads];

void settings() {
  // Set dimensions of display window
  size(gridWidth, gridHeight);
  smooth();
}


void setup() {

  background(60, 128); 
  noStroke();
  //if no sensor comment out function
  trillSetup(2); //put the port number for Arduino serial comms in here!
}



void draw() {

  background(60, 128);

  calcPeakValIndex();
  visualiseBiggestCoord();

  calcRawPeakVal();
  centroidCalc();

  //moving centroid drawing
  fill(255, 100, 200, 200); 
  ellipseMode(CENTER);
  
  //with easing 
  easingX(centroidX);
  easingY(centroidY);
  ellipse(x, y, size, size); //ellipse of centroid proximity dictates size.

  //without easing
  //notes less drop off but more ridgid movement. 
  //ellipse(centroidX, centroidY, size, size); //ellipse of centroid proximity dictates size.
}


//a = target or centroidX, x = returned val
float easingX(float a)
{
  float b = a - x;
  x += b * 0.05;
  return x;
}

float easingY(float a)
{
  float b = a - y;
  y += b * 0.05;
  return y;
}


void calcPeakValIndex() { //working
  //calculate index in array with the peak value
  biggest = 0;
  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 4; j++) {

      if (gSensorReadings[i*4+j] > gSensorReadings[biggest]) {  //is the array the raw value array or the new fixed coordinate array?


        biggest = i * 4 + j;
        //println(biggest); //which [index] has biggest val

      }
    }
  }
}



void visualiseBiggestCoord() { //working

  //identify biggest co-ord and display it.

  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 4; j++) {
      if (i*4+j==biggest) {
        //draws positions of biggest one

        newX=j*(radius+spacingX);
        newY=i*(radius+spacingY);
      }
    }
  }
}

//normalising function
float normalise(float _val, float _max, float _min) {
  // println("normalising");
  float max=_max;
  float min = _min;
  float val= _val;

  norm=(val - min) / (max - min);

  //clip the values
  //if ( norm>=1) {
  //  norm=1;
  //} else if ( norm<1) {
  //  norm=0;
  //}
  println("update normalised: "+norm);
  if(norm>0){
    return norm;
  }
  else{
  return 0;
  
  }
}

//calculate the peak raw data spike in the array of sensor readings.
void calcRawPeakVal() { 
  //store the peak value (not the coordinate/index of the peak value )
  biggestVal = 0;

  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 4; j++) {
      //gSensorReadings[] is the raw sensor values array.
      if (gSensorReadings[i*4+j] > gSensorReadings[biggestVal]) {
        println("triggerReading: "+ gSensorReadings[i*4+j]);
        //use that val to normalise all outputs.

        normalise(gSensorReadings[i*4+j], 70, 1000);
        //println("update normalised: "+norm);


        //make new array of normlaised values here
        normalisedData[i*4+j] = normalise(gSensorReadings[i*4+j], 1000, 0); //this range effects the centroid 0:0 to 3:3 ratio
      }
    }
  }
}




// create a list of x and y coordinates for each sensor,
//and weight these coordinate values based on how much energy at each position
void centroidCalc() {
  //calculate the centre of mass of a 4 * 4 grid of values
  centroidX = 0;
  centroidY = 0; //need to clear everytime

  for (int i = 0; i < 6; i++) {
    for (int j = 0; j < 4; j++) {

      centroidX+=j * (normalisedData[i*4+j]);
      centroidY+=i * (normalisedData[i*4+j]);


      normalisedData[i*4+j]=0;//reset so not accumalitive add to centroid values
    }
  }
  //println(" centroidX: "+centroidX); //its working!!!
  //println(" centroidY: "+centroidY);
  centroidX=(centroidX/24);
  centroidY=(centroidY/24);
  //println(" centroidX: "+centroidX); //its working!!!
  //println(" centroidY: "+centroidY);
  float maxX = 0.125;
  float maxY = 0.22;
  centroidX=map(centroidX, 0, maxX, spacingX+(radius/2), width-radius/2); //this needs mapping to center points of contact surface area of the sensor.
  centroidY=map(centroidY, 0, maxY, spacingY+(radius/2), height-radius/2);
}
