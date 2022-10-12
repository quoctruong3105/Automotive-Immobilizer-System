# Automotive-Immobilizer-System
+ Note: In reality, Immobilizer uses a chip key that contains the ID. But in this project, the chip key will be replaced by a keypad that requests the user enter the ID. The LEDs are used to indicate the ignition signal of the engine in turn.
+ This is a self-study project to improve C programming skills and AVR microcontroller knowledge.
+ Tools: Proteus, Codevision
+ Tasks: Simulate circuit diagram on Proteus, build code in Codevision and load hex file to AVR microcontroller, test system and debug,...
+ Knowledge used in this project: 
  - Microcontroller: External Interrupts, UART, SPI, declare registers. 
  - C language: loop, if-else structure, one-dimensional array, two-dimensional array.
  - Automotive: working principle of the immobilizer system.
+ Working principle: when the user enters ID characters in the keypad, the amplifier will send these characters to ECM, when ECM receives 8 characters, it will start comparing 8 entered characters with 8 previously registered characters. If the IDs match, the ECM sends a signal to the engine ECU and allows the engine ECU to operate. When the engine ECU is operating, it will send a signal to the ECM, the ECM will output a signal to notify the user that the engine has been operated. In case of incorrect input, the ECM will send a signal to the engine ECU and will not allow the engine to operate. If you enter the wrong ID more than 3 times, the burglar alarm system will be turned on.
+ Description video: https://www.youtube.com/watch?v=0yyg5SRCx8g 
