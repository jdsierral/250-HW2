adc => Gain input => blackhole;
1 => int keyboard;

vec3 smoother;
10::ms => dur smooRate;

smoother.set(0, 0, .05 * (second/smooRate));

spork ~ interpolate( smooRate );

Moog instr[8];
ADSR env[8];
Gain mixer;
Gain envelope;

mixer => envelope => dac;


for (0 => int i; i < 8; i++) {
    instr[i] => env[i] => mixer;
    instr[i].vibratoGain(0.1);
    instr[i].freq( Std.mtof(60 + mapKey(i)) );
    instr[i].noteOn(127.0);
    env[i].set(100::ms, 100::ms, 0.8, 200::ms);
}

spork ~ initKeyboard();

fun void initKeyboard() {
    Hid hid;
    HidMsg msg;
    hid.openKeyboard( keyboard );
    <<< "keyboard: " + hid.name() >>>;
    while(true) {
        hid => now;
        while ( hid.recv( msg ) ) {
            if ( msg.isButtonDown() ) { processButtonOn(msg.ascii); }
            else if ( msg.isButtonUp() ) { processButtonOff(msg.ascii);}
        }
    }
}

fun void interpolate( dur delta ) {
    while( true ){
        smoother.interp( delta ) => envelope.gain;
        delta => now;
    }
}

fun void processButtonOn(int key) {
    key - 49 => int note;
    if (note >= 0 && note < 8)
        env[note].keyOn();
}

fun void processButtonOff(int key) {
    key - 49 => int note;
    if (note >= 0 && note < 8)
        env[note].keyOff();
}

fun int mapKey(int key) {
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
}


while(true) {
    1::samp => now;
    smoother.update(Std.fabs(input.last()));
}
