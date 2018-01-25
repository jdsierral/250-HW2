Moog instr[8];
ADSR env[8];
Gain mixer;
Gain envelope;

mixer => envelope => dac;
mixer.gain(0.125);


for (0 => int i; i < 8; i++) {
    instr[i] => env[i] => mixer;
    instr[i].vibratoGain(0.0);
    instr[i].freq( Std.mtof(60 + mapKey(i)) );
    instr[i].noteOn(127.0);
    env[i].set(100::ms, 100::ms, 0.8, 200::ms);
}

1 => int mapping;
0.1 => float threshold;
vec3 smoother;
10::ms => dur smooRate;
smoother.set(0, 0, .05 * (second/smooRate));

spork ~ interpolate( smooRate );
spork ~ initMIDI();

fun void initMIDI() {
    MidiIn midiIn;
    MidiMsg msg;
    midiIn.open( 2 );
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
            /* <<< "device: ", msg.data1, msg.data2, msg.data3 >>>; */
        }
    }
}

fun void interpolate( dur delta ) {
    while( true ){
        smoother.interp( delta ) => envelope.gain;
        delta => now;
    }
}

fun void processEnvelopeData(int data) {
    data / 128.0 => float gain;
    Math.max(Math.min(gain, 1), 0) => gain;

    <<< data + ", " + gain >>>;
    /* if (gain > 0.1) {
        for (0 => int i; i < 8; i++) {
            instr[i].vibratoGain(0.2);
        }
    } else {
        for (0 => int i; i < 8; i++) {
            instr[i].vibratoGain(0.0);
        }
    } */
    smoother.update(gain);
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

fun int mapKey(int key) {
    if (mapping == 0) {
        if (key == 0)
        return -5;
        if (key == 1)
        return 0;
        if (key == 2)
        return 3;
        if (key == 3)
        return 5;
        if (key == 4)
        return 7;
        if (key == 5)
        return 10;
        if (key == 6)
        return 12;
        if (key == 7)
        return 14;
    } else if (mapping == 1) {
        if (key == 0)
        return 0;
        if (key == 1)
        return 2;
        if (key == 2)
        return 3;
        if (key == 3)
        return 5;
        if (key == 4)
        return 7;
        if (key == 5)
        return 8;
        if (key == 6)
        return 10;
        if (key == 7)
        return 12;
    }
}


while(true) {
    1::samp => now;
    /* smoother.update(Std.fabs(input.last())); */
}
