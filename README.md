# Automotive Immobilizer System
+ Note: In reality, Immobilizer uses a chip key that contain the ID. But in this project, chip key will be replaced by keypad that request user enter the ID.
+ Knownlegde used in this project: 
  - Microcontroller: external interrupt, UART, SPI, LCD, declare registers. 
  - C language: loop, if-else structure, one-dimensional array, two-dimensional array.
  - Automotive: working principle of immobilizer system.
+ Working principle: when user enters ID characters in keypad, amplifier will send these characters to ECM, when ECM receive 8 characters, it will start comparing 8 entered characters with 8 previously registered characters. If the IDs match, the ECM sends a signal to the engine ECU and allows the engine ECU to operate. When the engine ECU is operating, it will send a signal to the ECM, the ECM will output a signal to notify the user that the engine has been operated. In case of incorrect input, the ECM will send a signal to the engine ECU and will not allow the engine to operate. If you enter the wrong ID more than 3 times, the burglar alarm system will be turned on.
  
