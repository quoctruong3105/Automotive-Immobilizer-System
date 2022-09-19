#include <mega328p.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>

#define siren PORTB.0
#define warningLight PORTB.1
#define On 1;
#define Off 0;

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

unsigned int timeEnterPassWord = 0;
unsigned int i = 0;
unsigned char ID[8];

int kiemTraID()
{
    unsigned int j;   
    unsigned char correctID[8] = {'1','2','3','-','+','=','0','N'};  
    for(j = 0; j < 8; j++)
    {
        if(ID[j] != correctID[j])
        {
            break;
        }         
        else
        {
            continue;
        }
    }                
    if(j == 8)
    {                
        return 1; // True
    }                          
    else
    {                
        return 0; // False
    }
}

void turnOnWarning()
{
    warningLight = On;    
    siren = On; 
    delay_ms(200);
    warningLight = Off;  
    siren = Off;
}

// SPI interrupt service routine
interrupt [SPI_STC] void spi_isr(void)
{
    ID[i]=SPDR;
    lcd_gotoxy(0,0);
    lcd_gotoxy(i,1);
    lcd_putchar(ID[i]);
    i++;
    if(i == 8)
    {          
        i = 0;  
        kiemTraID();
        if(kiemTraID() == 1)
        {
            lcd_clear();
            lcd_puts("correct ID");    
            delay_ms(1000);  
            lcd_clear();
            //Communicate with ECU ENGiNE
            putchar('c');
            UDR0 = getchar();
            if(UDR0 == 'u')
            {
                lcd_puts("Unlock Engine");
            } 
            SPCR=0x00;    
        }                             
        else
        {      
            lcd_clear();
            lcd_puts("Not correct");
            delay_ms(1000);
            lcd_clear();    
            timeEnterPassWord++;
            if(timeEnterPassWord > 2) //Allow Enter Wrong ID Only 3 times
            {
                //Communicate with ECU ENGINE   
                putchar('w');
                UDR0 = getchar();
                if(UDR0 == 'l')
                {
                    lcd_puts("Lock Engine"); 
                }
                SPCR=0x00;
            }                          
        }
    }  
    delay_ms(300);               
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

// Standard Input/Output functions
#include <stdio.h>



void main(void)
{

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// SPI initialization
SPCR=0b11000011;
SPSR=0x00;

// Clear the SPI interrupt flag
#asm
    in   r30,spsr
    in   r30,spdr
#endasm

//Set up chan Slave
DDRB = 0b00010000; 
PORTB = 0b00001100; 

// USART initialization
UCSR0A=0x00;
UCSR0B=0xD8;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x08;

DDRB.0 = 1;
DDRB.1 = 1;
PORTB.0 = 0;
PORTB.1 = 0;

// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      { 
        if(timeEnterPassWord < 3 && SPCR != 0x00)
        {                               
            lcd_gotoxy(0,0);
            lcd_puts("Enter ID: ");
        } 
        else if(timeEnterPassWord == 3) 
        {
            turnOnWarning();     
            lcd_gotoxy(0,1);
            lcd_puts("Theft Warning!");
        }
        delay_ms(200);
      }
}
