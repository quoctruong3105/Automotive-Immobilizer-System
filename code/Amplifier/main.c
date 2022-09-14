#include <mega328p.h>
#include <delay.h>

#define KEYPAD_DDR DDRD
#define KEYPAD_PORT PORTD
#define KEYPAD_PIN PIND

void transmitData(unsigned char data)
{          
    PORTB.2 = 0;
    SPDR =  data;
    while(SPSR == 0x00){};
    PORTB.2 = 1;
}


unsigned int scan_code[4] = {0x0E, 0x0D, 0x0B, 0x07};
unsigned int ascii_code[4][4] = {'7', '8', '9', '/',
                                 '4', '5', '6', '*',
                                 '1', '2', '3', '-',
                                 'N', '0', '=', '+'};
unsigned int key;
unsigned int checkpad()
{
    unsigned int i, j, keyin;
    for(i = 0; i < 4; i++)
    {
        KEYPAD_PORT = 0xFF - (1<<(i+4));
        delay_us(10);  
        keyin = KEYPAD_PIN & 0x0F;
        if(keyin != 0x0F)
        {
            for(j = 0; j < 4; j++)
            {
                if(keyin == scan_code[j])
                {
                    return ascii_code[j][i];
                }
            }
        }
    }
}  

void main(void)
{

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// USART initialization
UCSR0A=0x00;
UCSR0B=0x48;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x08;


//Khai bao huong cho cac chan ket noi KeyPad
KEYPAD_DDR = 0xF0;
KEYPAD_PORT = 0x0F;

// SPI initialization
SPCR=0b01010011;
SPSR=0x00;

//  Set up port for Master
DDRB = 0b00101100; 
PORTB = 0b00010100;

while (1)
      {
        key = checkpad(); // Read keypad
        if(key)
        {   
            transmitData(key);
        }  
        delay_ms(200);
      }
}