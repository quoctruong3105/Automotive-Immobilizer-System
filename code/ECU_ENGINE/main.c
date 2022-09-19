// c -> correct
// w -> wrong
// l -> lock
// u -> unlock

#include <mega328p.h>
#include <delay.h>
#include <stdio.h>

#define Igt1 PORTB.0
#define Igt2 PORTB.1
#define Igt3 PORTB.2
#define Igt4 PORTB.3
#define SparkPlug1 1
#define SparkPlug4 2
#define SparkPlug2 3
#define SparkPlug3 4
#define On 1
#define Off 0

#ifndef RXB8
#define RXB8 1
#endif
#ifndef TXB8
#define TXB8 0
#endif
#ifndef UPE
#define UPE 2
#endif
#ifndef DOR
#define DOR 3
#endif
#ifndef FE
#define FE 4
#endif
#ifndef UDRE
#define UDRE 5
#endif
#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)


unsigned int thuTuNo = 0;
unsigned int curSparkPlug;

// Chose spark plug in turn
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    thuTuNo++;
    if(thuTuNo == 5)
    {
        thuTuNo = 1;
    } 
    if(thuTuNo == 1)
    {
        curSparkPlug = SparkPlug1;           
    }            
    else if(thuTuNo == 2)
    {
        curSparkPlug = SparkPlug4;
    }        
    else if(thuTuNo == 3)
    {
        curSparkPlug = SparkPlug2;
    }            
    else if(thuTuNo == 4)
    {
        curSparkPlug = SparkPlug3;
    }      
}

// Ignition timing
interrupt [EXT_INT0] void ext_int0_isr(void)
{    
    //unsigned int i;   
    if(curSparkPlug == SparkPlug1)
    {
        Igt1 = On;
        delay_ms(200);
        Igt1 = Off;  
    }                  
    else if(curSparkPlug == SparkPlug4)
    {
        Igt4 = On;
        delay_ms(200);
        Igt4 = Off;
    } 
    else if(curSparkPlug == SparkPlug2)
    {
        Igt2 = On;
        delay_ms(200);
        Igt2 = Off;
    }
    else if(curSparkPlug == SparkPlug3)
    {
        Igt3 = On;
        delay_ms(200);
        Igt3 = Off;
    }                
}

// USART Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0)
      {
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
#endif
      rx_buffer_overflow0=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif


void main(void)
{

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// External Interrupt(s) initialization
EICRA=0x0A;
EIMSK=0x00;
EIFR=0x03; 

// USART initialization
UCSR0A=0x00;
UCSR0B=0xD8;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x08;

// Out put Ignition signal
DDRB = 0b11111111;
PORTB = 0b00000000;

#asm("sei")

while (1)
      {
        UDR0 = getchar();
        if(UDR0 == 'c')
        {
            EIMSK = 0b00000011;
            putchar('u');
        }      
        else if(UDR0 == 'w') 
        {
            EIMSK = 0b00000000; 
            putchar('l');
        }
      }
}
