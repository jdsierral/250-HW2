Moog instr[8];
ADSR env[8];
Gain mixer;
Gain envelope;
float envGain;

mixer => envelope;
envelope => dac;
mixer.gain(0.125);
vec3 smoother;
0 => int mapping;
0.1 => float threshold;
40::ms => dur smooRate;
smoother.set(0, 0, .05 * (second/smooRate));


for (0 => int i; i < 8; i++) {
    instr[i] => env[i] => mixer;
    instr[i].vibratoGain(0.0);
    instr[i].vibratoFreq(6);
    instr[i].freq( Std.mtof(64 + mapKey(i)) );
    instr[i].noteOn(100.0);
    env[i].set(100::ms, 100::ms, 0.8, 200::ms);
}


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
        smoother.interp( delta ) => float gain;
        /* if ( gain < threshold ) { 0 => gain; } */
        gain => envelope.gain;
        delta => now;
    }
}

fun void processEnvelopeData(int data) {

    Math.fabs(data - 63.5) / 64.0 => float gain;
    /* Std.dbtorms(Math.min(gain, 64) * 3) => gain; */
    if (gain < threshold) 0 => gain;
    /* if ( gain < threshold ) { 0 => gain; } */

    if (gain > 0.4) {
        for (0 => int i; i < 8; i++) {
            instr[i].vibratoGain(0.007);
        }
    } else {
        for (0 => int i; i < 8; i++) {
            instr[i].vibratoGain(0.0);
        }
    }
    gain => envGain;
    /* smoother.update( gain ); */
    /* <<< data + ", " + gain >>>; */
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
    0.5::ms => now;
    smoother.update(envGain);
}
