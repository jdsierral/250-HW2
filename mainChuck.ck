Moog instr[8];
ADSR env[8];
Gain mixer;
Gain envelope;
Gain output;
Delay slap;
Gain delFeedback;
LPF delLPF;
HPF delHPF;

float envVal;
0.1 => float threshold;

Mapping map;
ComplexTracker envTracker;


output => dac.chan(8);
output => dac.chan(9);
mixer => envelope => output;
envelope => slap => output;
slap => delLPF => delHPF => delFeedback => slap;


1::second/1::samp => float fs;


mixer.gain(0.25);
envTracker.setFs(fs);
envTracker.setTauAttack(250.0);
envTracker.setTauRelease(300.0);
slap.max(500::ms);
slap.delay(300::ms);
delLPF.freq(5000);
delHPF.freq(250);
slap.gain(0.1);

8 => map.numNotes;
4 => map.base;
4 => map.mapping;
-3 => map.transpose;
4 => map.octave;
0 => map.cents;

for (0 => int i; i < 8; i++) {
    instr[i] => env[i] => mixer;
    i / 8.0 => float pos;
    map.map(pos) => float note;
    if (i == 0) note - 3 => note;
    <<< note >>>;
    instr[i].freq( Std.mtof(note) );
    instr[i].noteOn(100.0);
    env[i].set(100::ms, 100::ms, 0.8, 200::ms);
}

spork ~ initMIDI();
spork ~ trackEnvelope();

fun void initMIDI() {
    MidiIn midiIn;
    MidiMsg msg;
    midiIn.open( "Teensy MIDI" );
    <<< "Midi: " + midiIn.name() >>>;
    while(true) {
        midiIn => now;
        while( midiIn.recv( msg )) {
            if (msg.data1 == 144) {
                processButtonOn(msg.data2);
            }
            if (msg.data1 == 128) {
                processButtonOff(msg.data2);
            }
            if (msg.data1 == 176) {
                processEnvelopeData(msg.data3);
            }
        }
    }
}

fun void trackEnvelope() {
    while(true) {
        envTracker.setTarget(envVal);
        1::samp => now;
    }
}

fun void processEnvelopeData(int data) {
    Math.fabs(data - 72.0) / 64.0 => float val;
    if (val > threshold) {
        val => envVal;
    } else {
        0 => envVal;
    }
}

fun void processButtonOn(int key) {
    key - 60 => int note;
    if (note >= 0 && note < 8)
        env[note].keyOn();
}

fun void processButtonOff(int key) {
    key - 60 => int note;
    if (note >= 0 && note < 8)
        env[note].keyOff();
}


while(true) {
    envTracker.tick() => envelope.gain;
    1::samp => now;
}
