# HW2-250a


This is the second homework for 250a. The idea was to create a simple controller with at least one button and one continuous controller.

My ideas was to create a wind based polyphonic controller. Additionally, I was really determined to enclose the whole thing in a single protoboard with a teensy controller, 8 buttons and a microphone to sense the pressure from a person blowing into the microphone.

To do that simple push down resistors were used in all the sensors of 10kΩ for the buttons and of 3.3kΩ for the microphone as this seemed to give a good dc value of 500 in the teensy. Due to this the dynamic range was maximized and the non linearity due to distortion on the ADC process was minimized.


# Video example

The following video shows the possibilities of this controller.




# Chuck Side

On chuck, the code is implemented through 8 different generators. This is to allow polyphony given that we know the maximum number of notes of the controller will always be 8. Hence theres no need of dynamic managment of the voices and it can be set like this without being inefficient at all.

# The Controller

Given that the controller is polyphonic one would be tempted to play chords in it, and even though that is a possibility, I personally think its more of a melodic instrument that allows to have subtle counterpoint whenever needed. Due to this, the exmaple video uses a Logic based drum machine and a Guitar as a base to later show the melodic capabilities of the controller.


