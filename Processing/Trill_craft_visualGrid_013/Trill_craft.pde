import processing.serial.*;

// Serial communication
Serial gPort; // Serial port
int gPortNumber = 2; // Port number
int gBaudRate = 115200; // Baud Rate


// Number of sensors
int gNumSensors = 16;
// Bit resolution
int gNumBits = 12;
// Expected range of received data
int gDataRange[] = {0, (1<<gNumBits)-1};

// Sensor readings
int gSensorReadings[] = new int[gNumSensors];
float proximity [] = new float[gNumSensors];
float mapData01 [] = new float[gNumSensors];
float mapData02 [] = new float[gNumSensors];
float proxHeight [] = new float[gNumSensors];

void trillSetup() {
  println("Available ports: ");
  printArray(Serial.list());

  String portName = Serial.list()[gPortNumber];

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
        mapData01[i]=map(gSensorReadings[i], 120, 600, 100, 255);
        proximity[i]=lerp(proximity[i], mapData01[i], 0.25); //use to control alpha and potentially size. 

        //repeat but for height (distance away from sensor)
        mapData02[i]=map(gSensorReadings[i], 120, 600, 10, height-50);
        proxHeight[i]=lerp(proximity[i], mapData02[i], 0.25); //use to control alpha and potentially size.
      }
    }
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}
