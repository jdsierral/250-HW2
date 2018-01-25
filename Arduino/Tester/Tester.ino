#include <Bounce.h>

const int chan = 1;
const int TIME = 5;

Bounce button0 = Bounce(23, TIME);
Bounce button1 = Bounce(22, TIME);
Bounce button2 = Bounce(21, TIME);
Bounce button3 = Bounce(20, TIME);
Bounce button4 = Bounce(19, TIME);
Bounce button5 = Bounce(18, TIME);
Bounce button6 = Bounce(17, TIME);
Bounce button7 = Bounce(16, TIME);

void setup() {
  pinMode(23, INPUT_PULLUP);
  pinMode(22, INPUT_PULLUP);
  pinMode(21, INPUT_PULLUP);
  pinMode(20, INPUT_PULLUP);
  pinMode(19, INPUT_PULLUP);
  pinMode(18, INPUT_PULLUP);
  pinMode(17, INPUT_PULLUP);
  pinMode(16, INPUT_PULLUP);
}

void loop() {
  button0.update();
  button1.update();
  button2.update();
  button3.update();
  button4.update();
  button5.update();
  button6.update();
  button7.update();

  //104, 107, 102, 106

  if (button0.fallingEdge()) { usbMIDI.sendNoteOn(60, 100, chan); }
  if (button1.fallingEdge()) { usbMIDI.sendNoteOn(63, 101, chan); }
  if (button2.fallingEdge()) { usbMIDI.sendNoteOn(65, 102, chan); }
  if (button3.fallingEdge()) { usbMIDI.sendNoteOn(67, 103, chan); }
  if (button4.fallingEdge()) { usbMIDI.sendNoteOn(70, 104, chan); }
  if (button5.fallingEdge()) { usbMIDI.sendNoteOn(72, 105, chan); }
  if (button6.fallingEdge()) { usbMIDI.sendNoteOn(75, 106, chan); }
  if (button7.fallingEdge()) { usbMIDI.sendNoteOn(77, 107, chan); }

  if (button0.risingEdge()) { usbMIDI.sendNoteOff(60, 0, chan); }
  if (button1.risingEdge()) { usbMIDI.sendNoteOff(63, 0, chan); }
  if (button2.risingEdge()) { usbMIDI.sendNoteOff(65, 0, chan); }
  if (button3.risingEdge()) { usbMIDI.sendNoteOff(67, 0, chan); }
  if (button4.risingEdge()) { usbMIDI.sendNoteOff(70, 0, chan); }
  if (button5.risingEdge()) { usbMIDI.sendNoteOff(72, 0, chan); }
  if (button6.risingEdge()) { usbMIDI.sendNoteOff(75, 0, chan); }
  if (button7.risingEdge()) { usbMIDI.sendNoteOff(77, 0, chan); }

  while(usbMIDI.read()) {
  }
}

