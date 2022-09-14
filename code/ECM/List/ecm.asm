
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega328P
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2303
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _timeEnterPassWord=R3
	.DEF _i=R5
	.DEF _rx_wr_index0=R8
	.DEF _rx_rd_index0=R7
	.DEF _rx_counter0=R10
	.DEF _tx_wr_index0=R9
	.DEF _tx_rd_index0=R12
	.DEF _tx_counter0=R11
	.DEF __lcd_x=R14
	.DEF __lcd_y=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _spi_isr
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3F:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x63,0x6F,0x72,0x72,0x65,0x63,0x74,0x20
	.DB  0x49,0x44,0x0,0x55,0x6E,0x6C,0x6F,0x63
	.DB  0x6B,0x20,0x45,0x6E,0x67,0x69,0x6E,0x65
	.DB  0x0,0x4E,0x6F,0x74,0x20,0x63,0x6F,0x72
	.DB  0x72,0x65,0x63,0x74,0x0,0x4C,0x6F,0x63
	.DB  0x6B,0x20,0x45,0x6E,0x67,0x69,0x6E,0x65
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x49
	.DB  0x44,0x3A,0x20,0x0,0x54,0x68,0x65,0x66
	.DB  0x74,0x20,0x57,0x61,0x72,0x6E,0x69,0x6E
	.DB  0x67,0x21,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  _0x14
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x14+11
	.DW  _0x0*2+11

	.DW  0x0C
	.DW  _0x14+25
	.DW  _0x0*2+25

	.DW  0x0C
	.DW  _0x14+37
	.DW  _0x0*2+37

	.DW  0x0B
	.DW  _0x38
	.DW  _0x0*2+49

	.DW  0x0F
	.DW  _0x38+11
	.DW  _0x0*2+60

	.DW  0x04
	.DW  0x03
	.DW  _0x3F*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <alcd.h>
;#include <stdio.h>
;
;#define siren PORTB.0
;#define warningLight PORTB.1
;#define On 1;
;#define Off 0;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;unsigned int timeEnterPassWord = 0;
;unsigned int i = 0;
;unsigned char ID[8];
;
;int kiemTraID()
; 0000 0032 {

	.CSEG
_kiemTraID:
; 0000 0033     unsigned int j;
; 0000 0034     unsigned char correctID[8] = {'1','2','3','-','+','=','0','N'};
; 0000 0035     for(j = 0; j < 8; j++)
	SBIW R28,8
	LDI  R30,LOW(49)
	ST   Y,R30
	LDI  R30,LOW(50)
	STD  Y+1,R30
	LDI  R30,LOW(51)
	STD  Y+2,R30
	LDI  R30,LOW(45)
	STD  Y+3,R30
	LDI  R30,LOW(43)
	STD  Y+4,R30
	LDI  R30,LOW(61)
	STD  Y+5,R30
	LDI  R30,LOW(48)
	STD  Y+6,R30
	LDI  R30,LOW(78)
	STD  Y+7,R30
	ST   -Y,R17
	ST   -Y,R16
;	j -> R16,R17
;	correctID -> Y+2
	__GETWRN 16,17,0
_0x4:
	__CPWRN 16,17,8
	BRSH _0x5
; 0000 0036     {
; 0000 0037         if(ID[j] != correctID[j])
	LDI  R26,LOW(_ID)
	LDI  R27,HIGH(_ID)
	ADD  R26,R16
	ADC  R27,R17
	LD   R0,X
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CP   R30,R0
	BRNE _0x5
; 0000 0038         {
; 0000 0039             break;
; 0000 003A         }
; 0000 003B         else
; 0000 003C         {
; 0000 003D             continue;
; 0000 003E         }
; 0000 003F     }
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0040     if(j == 8)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x8
; 0000 0041     {
; 0000 0042         return 1; // True
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2080002
; 0000 0043     }
; 0000 0044     else
_0x8:
; 0000 0045     {
; 0000 0046         return 0; // False
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
; 0000 0047     }
; 0000 0048 }
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
;
;void turnOnWarning()
; 0000 004B {
_turnOnWarning:
; 0000 004C     warningLight = On;
	SBI  0x5,1
; 0000 004D     siren = On;
	SBI  0x5,0
; 0000 004E     delay_ms(200);
	CALL SUBOPT_0x0
; 0000 004F     warningLight = Off;
	CBI  0x5,1
; 0000 0050     siren = Off;
	CBI  0x5,0
; 0000 0051 }
	RET
;
;// SPI interrupt service routine
;interrupt [SPI_STC] void spi_isr(void)
; 0000 0055 {
_spi_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0056     ID[i]=SPDR;
	__GETW2R 5,6
	SUBI R26,LOW(-_ID)
	SBCI R27,HIGH(-_ID)
	IN   R30,0x2E
	ST   X,R30
; 0000 0057     lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0058     lcd_gotoxy(i,1);
	ST   -Y,R5
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0059     lcd_putchar(ID[i]);
	LDI  R26,LOW(_ID)
	LDI  R27,HIGH(_ID)
	ADD  R26,R5
	ADC  R27,R6
	LD   R30,X
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 005A     i++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 005B     if(i == 8)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0x12
; 0000 005C     {
; 0000 005D         i = 0;
	CLR  R5
	CLR  R6
; 0000 005E         kiemTraID();
	RCALL _kiemTraID
; 0000 005F         if(kiemTraID() == 1)
	RCALL _kiemTraID
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x13
; 0000 0060         {
; 0000 0061             lcd_clear();
	CALL _lcd_clear
; 0000 0062             lcd_puts("correct ID");
	__POINTW1MN _0x14,0
	CALL SUBOPT_0x2
; 0000 0063             delay_ms(1000);
; 0000 0064             lcd_clear();
; 0000 0065             //Communicate with ECU ENGiNE
; 0000 0066             putchar('c');
	LDI  R30,LOW(99)
	CALL SUBOPT_0x3
; 0000 0067             UDR0 = getchar();
; 0000 0068             lcd_puts("Unlock Engine");
	__POINTW1MN _0x14,11
	RJMP _0x3C
; 0000 0069             SPCR=0x00;
; 0000 006A         }
; 0000 006B         else
_0x13:
; 0000 006C         {
; 0000 006D             lcd_clear();
	CALL _lcd_clear
; 0000 006E             lcd_puts("Not correct");
	__POINTW1MN _0x14,25
	CALL SUBOPT_0x2
; 0000 006F             delay_ms(1000);
; 0000 0070             lcd_clear();
; 0000 0071             timeEnterPassWord++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
; 0000 0072             if(timeEnterPassWord > 2) //Allow Enter Wrong ID Only 3 times
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x16
; 0000 0073             {
; 0000 0074                 //Communicate with ECU ENGINE
; 0000 0075                 putchar('w');
	LDI  R30,LOW(119)
	CALL SUBOPT_0x3
; 0000 0076                 UDR0 = getchar();
; 0000 0077                 lcd_puts("Lock Engine");
	__POINTW1MN _0x14,37
_0x3C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0078                 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 0079             }
; 0000 007A         }
_0x16:
; 0000 007B     }
; 0000 007C     delay_ms(300);
_0x12:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x4
; 0000 007D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI

	.DSEG
_0x14:
	.BYTE 0x31
;
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 008F {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0090 char status,data;
; 0000 0091 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0092 data=UDR0;
	LDS  R16,198
; 0000 0093 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x17
; 0000 0094    {
; 0000 0095    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0096 #if RX_BUFFER_SIZE0 == 256
; 0000 0097    // special case for receiver buffer size=256
; 0000 0098    if (++rx_counter0 == 0)
; 0000 0099       {
; 0000 009A #else
; 0000 009B    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x18
	CLR  R8
; 0000 009C    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x18:
	INC  R10
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x19
; 0000 009D       {
; 0000 009E       rx_counter0=0;
	CLR  R10
; 0000 009F #endif
; 0000 00A0       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 00A1       }
; 0000 00A2    }
_0x19:
; 0000 00A3 }
_0x17:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x3E
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00AA {
_getchar:
; 0000 00AB char data;
; 0000 00AC while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x1C:
	TST  R10
	BREQ _0x1C
; 0000 00AD data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 00AE #if RX_BUFFER_SIZE0 != 256
; 0000 00AF if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x1F
	CLR  R7
; 0000 00B0 #endif
; 0000 00B1 #asm("cli")
_0x1F:
	cli
; 0000 00B2 --rx_counter0;
	DEC  R10
; 0000 00B3 #asm("sei")
	sei
; 0000 00B4 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00B5 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 00C5 {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C6 if (tx_counter0)
	TST  R11
	BREQ _0x20
; 0000 00C7    {
; 0000 00C8    --tx_counter0;
	DEC  R11
; 0000 00C9    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0000 00CA #if TX_BUFFER_SIZE0 != 256
; 0000 00CB    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x21
	CLR  R12
; 0000 00CC #endif
; 0000 00CD    }
_0x21:
; 0000 00CE }
_0x20:
_0x3E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00D5 {
_putchar:
; 0000 00D6 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x22:
	LDI  R30,LOW(8)
	CP   R30,R11
	BREQ _0x22
; 0000 00D7 #asm("cli")
	cli
; 0000 00D8 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R11
	BRNE _0x26
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE _0x25
_0x26:
; 0000 00D9    {
; 0000 00DA    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00DB #if TX_BUFFER_SIZE0 != 256
; 0000 00DC    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x28
	CLR  R9
; 0000 00DD #endif
; 0000 00DE    ++tx_counter0;
_0x28:
	INC  R11
; 0000 00DF    }
; 0000 00E0 else
	RJMP _0x29
_0x25:
; 0000 00E1    UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 00E2 #asm("sei")
_0x29:
	sei
; 0000 00E3 }
	JMP  _0x2080001
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;
;void main(void)
; 0000 00ED {
_main:
; 0000 00EE 
; 0000 00EF // Crystal Oscillator division factor: 1
; 0000 00F0 #pragma optsize-
; 0000 00F1 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00F2 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00F3 #ifdef _OPTIMIZE_SIZE_
; 0000 00F4 #pragma optsize+
; 0000 00F5 #endif
; 0000 00F6 
; 0000 00F7 // SPI initialization
; 0000 00F8 SPCR=0b11000011;
	LDI  R30,LOW(195)
	OUT  0x2C,R30
; 0000 00F9 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00FA 
; 0000 00FB // Clear the SPI interrupt flag
; 0000 00FC #asm
; 0000 00FD     in   r30,spsr
    in   r30,spsr
; 0000 00FE     in   r30,spdr
    in   r30,spdr
; 0000 00FF #endasm
; 0000 0100 
; 0000 0101 //Set up chan Slave
; 0000 0102 DDRB = 0b00010000;
	LDI  R30,LOW(16)
	OUT  0x4,R30
; 0000 0103 PORTB = 0b00001100;
	LDI  R30,LOW(12)
	OUT  0x5,R30
; 0000 0104 
; 0000 0105 // USART initialization
; 0000 0106 UCSR0A=0x00;
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 0107 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0000 0108 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0109 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 010A UBRR0L=0x08;
	LDI  R30,LOW(8)
	STS  196,R30
; 0000 010B 
; 0000 010C DDRB.0 = 1;
	SBI  0x4,0
; 0000 010D DDRB.1 = 1;
	SBI  0x4,1
; 0000 010E PORTB.0 = 0;
	CBI  0x5,0
; 0000 010F PORTB.1 = 0;
	CBI  0x5,1
; 0000 0110 
; 0000 0111 // Characters/line: 16
; 0000 0112 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0113 
; 0000 0114 // Global enable interrupts
; 0000 0115 #asm("sei")
	sei
; 0000 0116 
; 0000 0117 while (1)
_0x32:
; 0000 0118       {
; 0000 0119         if(timeEnterPassWord < 3 && SPCR != 0x00)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R3,R30
	CPC  R4,R31
	BRSH _0x36
	IN   R30,0x2C
	CPI  R30,0
	BRNE _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 011A         {
; 0000 011B             lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 011C             lcd_puts("Enter ID: ");
	__POINTW1MN _0x38,0
	RJMP _0x3D
; 0000 011D         }
; 0000 011E         else if(timeEnterPassWord == 3)
_0x35:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R3
	CPC  R31,R4
	BRNE _0x3A
; 0000 011F         {
; 0000 0120             turnOnWarning();
	RCALL _turnOnWarning
; 0000 0121             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 0122             lcd_puts("Theft Warning!");
	__POINTW1MN _0x38,11
_0x3D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
; 0000 0123         }
; 0000 0124         delay_ms(200);
_0x3A:
	CALL SUBOPT_0x0
; 0000 0125       }
	RJMP _0x32
; 0000 0126 }
_0x3B:
	RJMP _0x3B

	.DSEG
_0x38:
	.BYTE 0x1A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0xB,4
	RJMP _0x2000005
_0x2000004:
	CBI  0xB,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0xB,5
	RJMP _0x2000007
_0x2000006:
	CBI  0xB,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0xB,6
	RJMP _0x2000009
_0x2000008:
	CBI  0xB,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0xB,7
	RJMP _0x200000B
_0x200000A:
	CBI  0xB,7
_0x200000B:
	__DELAY_USB 5
	SBI  0x8,0
	__DELAY_USB 13
	CBI  0x8,0
	__DELAY_USB 13
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R14,Y+1
	LDD  R13,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x5
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R14,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	CP   R14,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R13
	ST   -Y,R13
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080001
_0x2000013:
_0x2000010:
	INC  R14
	SBI  0x8,2
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x8,2
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0xA,4
	SBI  0xA,5
	SBI  0xA,6
	SBI  0xA,7
	SBI  0x7,0
	SBI  0x7,2
	SBI  0x7,1
	CBI  0x8,0
	CBI  0x8,2
	CBI  0x8,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	CALL SUBOPT_0x6
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_ID:
	.BYTE 0x8
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	CALL _putchar
	CALL _getchar
	STS  198,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
