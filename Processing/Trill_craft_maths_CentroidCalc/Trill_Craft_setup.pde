import processing.serial.*;

// Serial communication
Serial gPort; // Serial port
int gBaudRate = 115200; // Baud Rate
float alpha;


// Number of sensors
int gNumSensors = totalSensorPads;
// Bit resolution
int gNumBits = 16;
// Expected range of received data
int gDataRange[] = {0, (1<<gNumBits)-1};

// Sensor readings
float gSensorReadings[] = new float[gNumSensors];
float proximity [] = new float[gNumSensors];
float mapData01 [] = new float[gNumSensors];
float mapData02 [] = new float[gNumSensors];
float proxHeight [] = new float[gNumSensors];

void trillSetup(int _gPortNumber) {
  println("Available ports: ");
  printArray(Serial.list());

  String portName = Serial.list()[_gPortNumber];

  println("Opening port " + portName);
  gPort = new Serial(this, portName, gBaudRate);
  gPort.bufferUntil('\n');
}



// This function is called whenever new serial data is available
void serialEvent(Serial p) {
  // Read data from the serial buffer as string
  String str = p.readString();
  try {
    // Parse string to extract  information
    String inString = trim(str); // remove whitespaces from beginning/end
    int[] values = int(split(inString, " ")); // Split string using space as a delimiter and cast to int
    int i;
    for (i = 0; i < values.length; i++) {
      if (i < gNumSensors) {
        gSensorReadings[i] = values[i];
        //println("RAW READING: "+gSensorReadings[i]+"ID: "+i);


      }
    }
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}
