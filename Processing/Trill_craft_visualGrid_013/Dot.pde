class Dot {
  int x, y;
  float d;
  int r, g, b;
  color c;
  int a;

  int id;
  int activeTouch [] = new int[gNumSensors];
  int lastActiveTouch [] = new int[gNumSensors];
  int position [] = new int[gNumSensors];
  int lastPosition [] = new int[gNumSensors];

  float[] data = new float[16];
  float total = 0, average = 0;
  int p = 0, n = 0;

  
  Dot(int _id, int _x, int _y, int _d) {
    id=_id;
    x=_x;
    y=_y;
    d=_d;
  }


  //where  to display ...parse diam to control via incoming data. 
  void display() {
    //float d =   gSensorReadings[id];//id will become i in the for loop when decalred. 
    //float d = 20;
    noStroke();
    fill(c);
    ellipseMode(CORNER);
    ellipse(x, y, d, d);
  }

  //cpontrol color on/off switch
  void setCol(int _r, int _g, int _b, int _a)
  {
    r=_r;
    g=_g;
    b=_b;
    a=_a;
    c= color(r, g, b, a);
  }

  void opacity() {

    //map intensity of touch to alpha channel
    a= int(proximity[id]); //alpha intensity 
    setCol(255, 100, 200, a);
  }
  void touchCheck() {

    if (activeTouch[id]==0 && gSensorReadings[id]> 120 ) { //check for repeated triggers.
      // println("Electrode " + id + " was touched");
      //control visual indicator. 
      setCol(255, 100, 200, a);
      activeTouch[id]=1; //no repeat triggers

      lastActiveTouch[id]=gSensorReadings[id];//store last active reading
      //printArray(lastActiveTouch[id]);
    
    //put lastActiveTouch ID num into a varibale 
    updateIndex(id);
 
    
 
    } else if (activeTouch[id]==1 && gSensorReadings[id]<= 120 ) {
      //println("Electrode " + id + " was released");
      activeTouch[id]=0;
      // setCol(200, 200, 200, a);
    }

  }




  //void location() {
  //  //^^ parse and x y into this function and update with the x y from lastActive id 
  //  //get from one ellispe to the next. 
  //  //posX=x[id];
  //  //posY=y[id];

  //  //send position. Write touch position up to maxNumCentroids/gNumSensors
  //}


  //void sizeOfTouch() {

  //  //send size. Write touch size up to maxNumCentroids/gNumSensors
  //}
}

//send ID to update active index
int updateIndex(int _index){
index=_index;
return index;
}


void displayAllDots() {
  for (Dot d : dots) {
    d.display();
    d.opacity();
  }
}

void displayTouch() {
  for (Dot d : dots) {
    d.touchCheck();
  }
}
