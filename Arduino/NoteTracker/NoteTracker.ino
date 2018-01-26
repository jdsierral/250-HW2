#include <ResponsiveAnalogRead.h>
#include <Bounce.h>

const int CHAN = 1;
const int A_IN = A0;
const int D_PINS = 8;
const int VEL = 100;

const int D_IN[D_PINS] = {4, 7, 2, 6, 20, 17, 23, 19};

//{4, 7, 2, 6, 20, 17, 23, 19};
//{1, 2, 3, 4, 5,  6,  7,  8}
//
//{6, 19, 2, 23, 7, 17, 4, 20}
//{4, 8, 3, 7, 2, 6, 1, 5}


const int BOUNCE_TIME = 10;
const int note[D_PINS] = {60, 61, 62, 63, 64, 65, 66, 67};

byte data;
byte dataLag;

float dc = 55;
float mag = 0;


ResponsiveAnalogRead analog { A_IN , true };

Bounce digital[] = {
  Bounce(D_IN[0], BOUNCE_TIME),
  Bounce(D_IN[1], BOUNCE_TIME),
  Bounce(D_IN[2], BOUNCE_TIME),
  Bounce(D_IN[3], BOUNCE_TIME),
  Bounce(D_IN[4], BOUNCE_TIME),
  Bounce(D_IN[5], BOUNCE_TIME),
  Bounce(D_IN[6], BOUNCE_TIME),
  Bounce(D_IN[7], BOUNCE_TIME)
};

void setup() {
  for (int i = 0; i < D_PINS; i++) {
      pinMode(D_IN[i], INPUT_PULLUP);
  }

}

void loop() {
  // put your main code here, to run repeatedly:
  getAnalogData();
  getDigitalData();
  while(usbMIDI.read()) {
  }
}

void getAnalogData() {
  analog.update();
  if (analog.hasChanged()) {
    data = float(analog.getValue()/8.0);
    float dc = tickDC(data);
//    float val = 2 * tickMagnitude( data - dc );
    int val = int(data - dc + 64);
    usbMIDI.sendControlChange(7, val, CHAN);
  }
}

void getDigitalData() {
  for (int i = 0; i < D_PINS; i++) {
    digital[i].update();
    if (digital[i].risingEdge()) {
      usbMIDI.sendNoteOn(note[i], VEL, CHAN);
    }
    if (digital[i].fallingEdge()) {
      usbMIDI.sendNoteOff(note[i], 0, CHAN);
    }
  }
}

float tickDC(float newdcVal) {
  dc += (1 - 0.9999) * (newdcVal - dc);
  return dc;
}

float tickMagnitude(float newAmplitude) {
  mag += (1 - 0.99) * (fabs(newAmplitude) - mag);
  return mag;
}


