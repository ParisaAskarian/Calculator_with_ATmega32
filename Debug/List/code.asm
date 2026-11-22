
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _exp_size=R4
	.DEF _exp_size_msb=R5
	.DEF _top_operands=R6
	.DEF _top_operands_msb=R7
	.DEF _top_operators=R8
	.DEF _top_operators_msb=R9
	.DEF _top_fix_oper=R10
	.DEF _top_fix_oper_msb=R11

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF

_0x3:
	.DB  0x7,0x4,0x1,0xA,0x8,0x5,0x2,0x0
	.DB  0x9,0x6,0x3,0xB,0xC,0xD,0xE,0xF
_0x0:
	.DB  0x49,0x6E,0x76,0x61,0x6C,0x69,0x64,0x0
	.DB  0x45,0x78,0x70,0x72,0x65,0x73,0x73,0x69
	.DB  0x6F,0x6E,0x0,0x25,0x64,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _code
	.DW  _0x3*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <lcd.h>
;#include <delay.h>
;#include <string.h>
;#include <stdbool.h>
;#asm
.equ __lcd_port=0x1B;PORTA
; 0000 0009 #endasm
;
;//keypad charecters
;unsigned char code[4][4] = {
;    {7, 4, 1, 10}, //first column
;    {8, 5, 2, 0}, //second column
;    {9, 6, 3, 11}, //third column
;    {12, 13, 14, 15}, //fourth column
;    };

	.DSEG
;
;//keep the input expression from keypad
;unsigned char exp[32];
;int exp_size = 0;
;
;//a stack for operands
;int operands[32];
;int top_operands = -1;
;
; //a stack operators
;unsigned char operators[32];
;int top_operators = -1;
;
;//a stack for keep a multi digit number
;//when the digits of number are finished, then push the full number in operands stack
;int fix_operand[32];
;int top_fix_oper = -1;
;
;void test(void){
; 0000 0024 void test(void){

	.CSEG
; 0000 0025 
; 0000 0026     //test number 1:
; 0000 0027      //check the exp list was exacly the same as input from keypad;
; 0000 0028     //int i;
; 0000 0029     //lcd_clear();
; 0000 002A     //lcd_gotoxy(0, 0);
; 0000 002B     //for(i=0; i < exp_size; i++){
; 0000 002C     //    lcd_putchar(exp[i]);
; 0000 002D     //    delay_ms(30);
; 0000 002E     //}
; 0000 002F 
; 0000 0030     //test number 2:
; 0000 0031     // check the operands and operators stacks are be correct
; 0000 0032     int i;
; 0000 0033     lcd_clear();
;	i -> R16,R17
; 0000 0034     lcd_gotoxy(0, 0);
; 0000 0035     for(i=0; i < 2; i++){
; 0000 0036         lcd_putchar(operands[i]);
; 0000 0037         lcd_putchar(',');
; 0000 0038         delay_ms(30);
; 0000 0039     }
; 0000 003A     lcd_putchar(operators[top_operators]);
; 0000 003B     delay_ms(30);
; 0000 003C 
; 0000 003D     //test number 3:
; 0000 003E     //check that fix_operand stack was correct
; 0000 003F     //lcd_clear();
; 0000 0040     //lcd_gotoxy(0, 0);
; 0000 0041     //lcd_putchar(fix_operand[top_fix_oper]);
; 0000 0042     //delay_ms(30);
; 0000 0043 
; 0000 0044 }
;
;//scan the pushed key
;unsigned char scan_key(void){
; 0000 0047 unsigned char scan_key(void){
_scan_key:
; .FSTART _scan_key
; 0000 0048 
; 0000 0049     unsigned char i, data, NumKey, temp;
; 0000 004A 
; 0000 004B     temp = 0x70;
	CALL __SAVELOCR4
;	i -> R17
;	data -> R16
;	NumKey -> R19
;	temp -> R18
	LDI  R18,LOW(112)
; 0000 004C     NumKey = 0xFF;
	LDI  R19,LOW(255)
; 0000 004D 
; 0000 004E     for(i = 0; i < 4; i++){
	LDI  R17,LOW(0)
_0x8:
	CPI  R17,4
	BRSH _0x9
; 0000 004F         PORTC = temp;
	OUT  0x15,R18
; 0000 0050         delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0051 
; 0000 0052         data = PINC & 0x0F;
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R16,R30
; 0000 0053 
; 0000 0054         if( data == 0x07) {NumKey = code[0][i]; break;}
	CPI  R16,7
	BRNE _0xA
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_code)
	SBCI R31,HIGH(-_code)
	LD   R19,Z
	RJMP _0x9
; 0000 0055         if( data == 0x0B) {NumKey = code[1][i]; break;}
_0xA:
	CPI  R16,11
	BRNE _0xB
	__POINTW2MN _code,4
	CALL SUBOPT_0x0
	RJMP _0x9
; 0000 0056         if( data == 0x0D) {NumKey = code[2][i]; break;}
_0xB:
	CPI  R16,13
	BRNE _0xC
	__POINTW2MN _code,8
	CALL SUBOPT_0x0
	RJMP _0x9
; 0000 0057         if( data == 0x0E) {NumKey = code[3][i]; break;}
_0xC:
	CPI  R16,14
	BRNE _0xD
	__POINTW2MN _code,12
	CALL SUBOPT_0x0
	RJMP _0x9
; 0000 0058 
; 0000 0059         temp = ((temp >> 1)| 0x80)& 0xF0;
_0xD:
	MOV  R30,R18
	LSR  R30
	ORI  R30,0x80
	ANDI R30,LOW(0xF0)
	MOV  R18,R30
; 0000 005A     }
	SUBI R17,-1
	RJMP _0x8
_0x9:
; 0000 005B 
; 0000 005C     return NumKey;
	MOV  R30,R19
	CALL __LOADLOCR4
	RJMP _0x208000B
; 0000 005D 
; 0000 005E }
; .FEND
;
;//this function is for when the input expression is invalid
;void error(void){
; 0000 0061 void error(void){
_error:
; .FSTART _error
; 0000 0062     lcd_clear();
	CALL _lcd_clear
; 0000 0063     lcd_gotoxy(5, 0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x1
; 0000 0064     lcd_putsf("Invalid");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0065     lcd_gotoxy(3, 1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0066     lcd_putsf("Expression");
	__POINTW2FN _0x0,8
	CALL _lcd_putsf
; 0000 0067     delay_ms(30);
	LDI  R26,LOW(30)
	CALL SUBOPT_0x2
; 0000 0068 
; 0000 0069     exp_size =0;
; 0000 006A     top_operators = -1;
; 0000 006B     top_operands = -1;
; 0000 006C     top_fix_oper = -1;
; 0000 006D     return;
	RET
; 0000 006E }
; .FEND
;
;//pop the top value in a stack
;void pop(int *top){
; 0000 0071 void pop(int *top){
_pop:
; .FSTART _pop
; 0000 0072     if( *top == -1){
	CALL SUBOPT_0x3
;	*top -> Y+0
	CALL __GETW1P
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0xE
; 0000 0073         error();
	RCALL _error
; 0000 0074         return;
	JMP  _0x2080004
; 0000 0075     }
; 0000 0076     else{
_0xE:
; 0000 0077         (*top)--;
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0078     }
; 0000 0079 
; 0000 007A }
	JMP  _0x2080004
; .FEND
;
;//push a value at the top of stack
;void push_operator(unsigned char stack[32], int *top, unsigned char value){
; 0000 007D void push_operator(unsigned char stack[32], int *top, unsigned char value){
_push_operator:
; .FSTART _push_operator
; 0000 007E     if( *top == 31){
	ST   -Y,R26
;	stack -> Y+3
;	*top -> Y+1
;	value -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x10
; 0000 007F         error();
	RCALL _error
; 0000 0080         return;
	RJMP _0x2080006
; 0000 0081     }
; 0000 0082     else{
_0x10:
; 0000 0083         (*top)++;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x4
; 0000 0084         stack[*top] = value;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0000 0085     }
; 0000 0086 }
	RJMP _0x2080006
; .FEND
;
;void push_operand(int stack[32], int *top, int value){
; 0000 0088 void push_operand(int stack[32], int *top, int value){
_push_operand:
; .FSTART _push_operand
; 0000 0089     if( *top == 31){
	ST   -Y,R27
	ST   -Y,R26
;	stack -> Y+4
;	*top -> Y+2
;	value -> Y+0
	CALL SUBOPT_0x5
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x12
; 0000 008A         error();
	RCALL _error
; 0000 008B         return;
	RJMP _0x2080009
; 0000 008C     }
; 0000 008D     else{
_0x12:
; 0000 008E         (*top)++;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x4
; 0000 008F         stack[*top] = value;
	CALL SUBOPT_0x5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0090     }
; 0000 0091 }
	RJMP _0x2080009
; .FEND
;
;//just see the top value in stack
;unsigned char peek_operator(unsigned char stack[32], int top){
; 0000 0094 unsigned char peek_operator(unsigned char stack[32], int top){
_peek_operator:
; .FSTART _peek_operator
; 0000 0095     if( top == -1){
	CALL SUBOPT_0x3
;	stack -> Y+2
;	top -> Y+0
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRNE _0x14
; 0000 0096         error();
	RCALL _error
; 0000 0097         return 255;
	LDI  R30,LOW(255)
	RJMP _0x208000B
; 0000 0098     }
; 0000 0099 
; 0000 009A     return stack[top];
_0x14:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RJMP _0x208000B
; 0000 009B }
; .FEND
;
;int peek_operand(int stack[32], int top){
; 0000 009D int peek_operand(int stack[32], int top){
_peek_operand:
; .FSTART _peek_operand
; 0000 009E     if( top == -1){
	CALL SUBOPT_0x3
;	stack -> Y+2
;	top -> Y+0
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRNE _0x15
; 0000 009F         error();
	RCALL _error
; 0000 00A0         return;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x208000B
; 0000 00A1     }
; 0000 00A2 
; 0000 00A3     return stack[top];
_0x15:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
_0x208000B:
	ADIW R28,4
	RET
; 0000 00A4 }
; .FEND
;
;//making the multi digit number and push it at the top of operand stack
;void read_and_push_fix_operand(void){
; 0000 00A7 void read_and_push_fix_operand(void){
_read_and_push_fix_operand:
; .FSTART _read_and_push_fix_operand
; 0000 00A8 
; 0000 00A9     int value;
; 0000 00AA     int number = 0;
; 0000 00AB     int mul = 1;
; 0000 00AC 
; 0000 00AD     //test();
; 0000 00AE 
; 0000 00AF     //moving on the stack and read on by on charecters and convert them to a digit
; 0000 00B0     while(top_fix_oper != -1){
	CALL __SAVELOCR6
;	value -> R16,R17
;	number -> R18,R19
;	mul -> R20,R21
	__GETWRN 18,19,0
	__GETWRN 20,21,1
_0x16:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0x18
; 0000 00B1         value = peek_operand(fix_operand, top_fix_oper);
	LDI  R30,LOW(_fix_operand)
	LDI  R31,HIGH(_fix_operand)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R10
	RCALL _peek_operand
	MOVW R16,R30
; 0000 00B2         number = number +( (value - '0') * (mul));
	MOVW R26,R16
	SBIW R26,48
	MOVW R30,R20
	CALL __MULW12
	__ADDWRR 18,19,30,31
; 0000 00B3         mul = mul * 10;
	MOVW R30,R20
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R20,R30
; 0000 00B4         pop(&top_fix_oper);
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL _pop
; 0000 00B5     }
	RJMP _0x16
_0x18:
; 0000 00B6 
; 0000 00B7     push_operand(operands, &top_operands, number);
	CALL SUBOPT_0x6
	MOVW R26,R18
	RCALL _push_operand
; 0000 00B8 
; 0000 00B9 }
	RJMP _0x2080008
; .FEND
;
;//do the operators
;// for example: if the operator is "+" , this function add two top operands stack values together
;//and return back the result into the operands stack
;void caculate(int num1, int num2, unsigned char operator){
; 0000 00BE void caculate(int num1, int num2, unsigned char operator){
_caculate:
; .FSTART _caculate
; 0000 00BF     int result;
; 0000 00C0 
; 0000 00C1     //test number 4:
; 0000 00C2     //check that num1 and num2 are correct
; 0000 00C3     //lcd_clear();
; 0000 00C4     //lcd_gotoxy(0, 0);
; 0000 00C5     //lcd_putchar(num1);
; 0000 00C6     //delay_ms(30);
; 0000 00C7     //lcd_putchar(num2);
; 0000 00C8     //delay_ms(30);
; 0000 00C9     //lcd_putchar(operator);
; 0000 00CA     //delay_ms(30);
; 0000 00CB 
; 0000 00CC     if(operator == '/'){
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	num1 -> Y+5
;	num2 -> Y+3
;	operator -> Y+2
;	result -> R16,R17
	LDD  R26,Y+2
	CPI  R26,LOW(0x2F)
	BRNE _0x19
; 0000 00CD 
; 0000 00CE         if(num2 == 0){
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SBIW R30,0
	BRNE _0x1A
; 0000 00CF             error();
	RCALL _error
; 0000 00D0             return;
	RJMP _0x208000A
; 0000 00D1         }
; 0000 00D2 
; 0000 00D3         result = num1 / num2;
_0x1A:
	CALL SUBOPT_0x7
	CALL __DIVW21
	RJMP _0x54
; 0000 00D4 
; 0000 00D5     }
; 0000 00D6     else if( operator == '*'){
_0x19:
	LDD  R26,Y+2
	CPI  R26,LOW(0x2A)
	BRNE _0x1C
; 0000 00D7         result = num1 * num2;
	CALL SUBOPT_0x7
	CALL __MULW12
	RJMP _0x54
; 0000 00D8     }
; 0000 00D9     else if ( operator == '-'){
_0x1C:
	LDD  R26,Y+2
	CPI  R26,LOW(0x2D)
	BRNE _0x1E
; 0000 00DA         result = num1 - num2;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SUB  R30,R26
	SBC  R31,R27
	RJMP _0x54
; 0000 00DB     }
; 0000 00DC     else if ( operator == '+'){
_0x1E:
	LDD  R26,Y+2
	CPI  R26,LOW(0x2B)
	BRNE _0x20
; 0000 00DD         result = num1 + num2;
	CALL SUBOPT_0x7
	ADD  R30,R26
	ADC  R31,R27
_0x54:
	MOVW R16,R30
; 0000 00DE     }
; 0000 00DF 
; 0000 00E0     push_operand(operands, &top_operands, result);
_0x20:
	CALL SUBOPT_0x6
	MOVW R26,R16
	RCALL _push_operand
; 0000 00E1 }
_0x208000A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; .FEND
;
;//when the expression is over and program pushed all charecters in stacks,
;//program must start moving on operators and operands stack,
;// for any operator, pick up two operands and caxulathe result
;void finall_caculation(void){
; 0000 00E6 void finall_caculation(void){
_finall_caculation:
; .FSTART _finall_caculation
; 0000 00E7     int num1;
; 0000 00E8     int num2;
; 0000 00E9     unsigned char operator;
; 0000 00EA 
; 0000 00EB     while(top_operators != -1){
	CALL __SAVELOCR6
;	num1 -> R16,R17
;	num2 -> R18,R19
;	operator -> R21
_0x21:
	CALL SUBOPT_0x8
	BREQ _0x23
; 0000 00EC 
; 0000 00ED          operator = peek_operator(operators, top_operators);
	CALL SUBOPT_0x9
	MOVW R26,R8
	RCALL _peek_operator
	MOV  R21,R30
; 0000 00EE          pop(&top_operators);
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	RCALL _pop
; 0000 00EF 
; 0000 00F0          if(top_operands < 1){
	CALL SUBOPT_0xA
	BRGE _0x24
; 0000 00F1             error();
	RCALL _error
; 0000 00F2             return;
	RJMP _0x2080008
; 0000 00F3         }
; 0000 00F4 
; 0000 00F5          num2 = peek_operand(operands, top_operands);
_0x24:
	CALL SUBOPT_0xB
	MOVW R18,R30
; 0000 00F6          pop(&top_operands);
	CALL SUBOPT_0xC
; 0000 00F7 
; 0000 00F8          num1 = peek_operand(operands, top_operands);
	CALL SUBOPT_0xB
	MOVW R16,R30
; 0000 00F9          pop(&top_operands);
	CALL SUBOPT_0xC
; 0000 00FA 
; 0000 00FB          caculate(num1, num2, operator);
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	MOV  R26,R21
	RCALL _caculate
; 0000 00FC     }
	RJMP _0x21
_0x23:
; 0000 00FD     if(top_operands > 0 || top_operands == -1){
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRLT _0x26
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x25
_0x26:
; 0000 00FE          error();
	RCALL _error
; 0000 00FF          return ;
; 0000 0100 
; 0000 0101     }
; 0000 0102 
; 0000 0103 }
_0x25:
_0x2080008:
	CALL __LOADLOCR6
_0x2080009:
	ADIW R28,6
	RET
; .FEND
;
;//this function give the operators a value,
;//then program can compare them:
;// the value of "-" and "+" is 1
;// the value of "*" and "/" is 2
;int value(unsigned char operator){
; 0000 0109 int value(unsigned char operator){
_value:
; .FSTART _value
; 0000 010A     int val;
; 0000 010B 
; 0000 010C     if(operator == '-' || operator == '+'){
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	operator -> Y+2
;	val -> R16,R17
	LDD  R26,Y+2
	CPI  R26,LOW(0x2D)
	BREQ _0x29
	CPI  R26,LOW(0x2B)
	BRNE _0x28
_0x29:
; 0000 010D         val = 1;
	__GETWRN 16,17,1
; 0000 010E     }
; 0000 010F     else{
	RJMP _0x2B
_0x28:
; 0000 0110         val = 2;
	__GETWRN 16,17,2
; 0000 0111     }
_0x2B:
; 0000 0112 
; 0000 0113     return val;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2080003
; 0000 0114 }
; .FEND
;
;// this function is the brain of the program:
;// moving in expression and push the operators in operators stack,
;// and push the operands in operands stack.
;// if the value of the top operator in operators stack,
;// is bigger than / equal the value of the current operator in
;// expression, first calculate the top operator in stack,
;// then push the current operator.
;void caculate_exp(void){
; 0000 011D void caculate_exp(void){
_caculate_exp:
; .FSTART _caculate_exp
; 0000 011E     int i;
; 0000 011F 
; 0000 0120     unsigned char charecter;
; 0000 0121     unsigned char charecterInStack;
; 0000 0122 
; 0000 0123     int num1;
; 0000 0124     int num2;
; 0000 0125 
; 0000 0126     bool expect_operand = true;
; 0000 0127 
; 0000 0128     char valid_operators[] = "-+/*";
; 0000 0129 
; 0000 012A     if( exp_size == 0){
	SBIW R28,8
	LDI  R30,LOW(45)
	ST   Y,R30
	LDI  R30,LOW(43)
	STD  Y+1,R30
	LDI  R30,LOW(47)
	STD  Y+2,R30
	LDI  R30,LOW(42)
	STD  Y+3,R30
	LDI  R30,LOW(0)
	STD  Y+4,R30
	LDI  R30,LOW(1)
	STD  Y+5,R30
	CALL __SAVELOCR6
;	i -> R16,R17
;	charecter -> R19
;	charecterInStack -> R18
;	num1 -> R20,R21
;	num2 -> Y+12
;	expect_operand -> Y+11
;	valid_operators -> Y+6
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x2C
; 0000 012B         error();
	CALL SUBOPT_0xD
; 0000 012C         return;
	RJMP _0x2080007
; 0000 012D     }
; 0000 012E 
; 0000 012F     for(i=0; i< exp_size ; i++){
_0x2C:
	__GETWRN 16,17,0
_0x2E:
	__CPWRR 16,17,4,5
	BRLT PC+2
	RJMP _0x2F
; 0000 0130 
; 0000 0131         //test();
; 0000 0132 
; 0000 0133         charecter = exp[i];
	LDI  R26,LOW(_exp)
	LDI  R27,HIGH(_exp)
	ADD  R26,R16
	ADC  R27,R17
	LD   R19,X
; 0000 0134 
; 0000 0135         if(strchr(valid_operators, charecter) != NULL  ){
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R19
	CALL _strchr
	SBIW R30,0
	BRNE PC+2
	RJMP _0x30
; 0000 0136 
; 0000 0137             if(expect_operand == true){
	LDD  R26,Y+11
	CPI  R26,LOW(0x1)
	BRNE _0x31
; 0000 0138                 error();
	CALL SUBOPT_0xD
; 0000 0139                 return;
	RJMP _0x2080007
; 0000 013A             }
; 0000 013B 
; 0000 013C             read_and_push_fix_operand();
_0x31:
	RCALL _read_and_push_fix_operand
; 0000 013D 
; 0000 013E             if(top_operators == -1){
	CALL SUBOPT_0x8
	BRNE _0x32
; 0000 013F                 push_operator(operators, &top_operators, charecter);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xE
; 0000 0140 
; 0000 0141             }
; 0000 0142             else{
	RJMP _0x33
_0x32:
; 0000 0143 
; 0000 0144                 while (top_operators != -1){
_0x34:
	CALL SUBOPT_0x8
	BREQ _0x36
; 0000 0145 
; 0000 0146                     charecterInStack = peek_operator(operators, top_operators);
	CALL SUBOPT_0x9
	MOVW R26,R8
	RCALL _peek_operator
	MOV  R18,R30
; 0000 0147 
; 0000 0148                     if(value(charecter)> value(charecterInStack)){
	MOV  R26,R19
	RCALL _value
	PUSH R31
	PUSH R30
	MOV  R26,R18
	RCALL _value
	POP  R26
	POP  R27
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x36
; 0000 0149                         break;
; 0000 014A                     }
; 0000 014B 
; 0000 014C                     if(top_operands < 1){
	CALL SUBOPT_0xA
	BRGE _0x38
; 0000 014D                         error();
	CALL SUBOPT_0xD
; 0000 014E                         return;
	RJMP _0x2080007
; 0000 014F 
; 0000 0150                     }
; 0000 0151 
; 0000 0152                     num2 = peek_operand(operands, top_operands);
_0x38:
	CALL SUBOPT_0xB
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0153                     pop(&top_operands);
	CALL SUBOPT_0xC
; 0000 0154 
; 0000 0155                     num1 = peek_operand(operands, top_operands);
	CALL SUBOPT_0xB
	MOVW R20,R30
; 0000 0156                     pop(&top_operands);
	CALL SUBOPT_0xC
; 0000 0157 
; 0000 0158                     caculate(num1, num2, charecterInStack);
	ST   -Y,R21
	ST   -Y,R20
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R18
	RCALL _caculate
; 0000 0159                     pop(&top_operators);
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	RCALL _pop
; 0000 015A 
; 0000 015B                 }
	RJMP _0x34
_0x36:
; 0000 015C 
; 0000 015D                 push_operator(operators,&top_operators,charecter);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xE
; 0000 015E 
; 0000 015F                 expect_operand = true;
	LDI  R30,LOW(1)
	STD  Y+11,R30
; 0000 0160             }
_0x33:
; 0000 0161         }
; 0000 0162         else{
	RJMP _0x39
_0x30:
; 0000 0163 
; 0000 0164             push_operand(fix_operand, &top_fix_oper,charecter);
	LDI  R30,LOW(_fix_operand)
	LDI  R31,HIGH(_fix_operand)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R19
	CLR  R27
	RCALL _push_operand
; 0000 0165 
; 0000 0166             expect_operand = false;
	LDI  R30,LOW(0)
	STD  Y+11,R30
; 0000 0167 
; 0000 0168             //test();
; 0000 0169 
; 0000 016A         }
_0x39:
; 0000 016B 
; 0000 016C     }
	__ADDWRN 16,17,1
	RJMP _0x2E
_0x2F:
; 0000 016D 
; 0000 016E     if(top_fix_oper != -1){
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0x3A
; 0000 016F         read_and_push_fix_operand();
	RCALL _read_and_push_fix_operand
; 0000 0170     }
; 0000 0171 
; 0000 0172     if( top_operators != -1 && top_operands >= 1 ){
_0x3A:
	CALL SUBOPT_0x8
	BREQ _0x3C
	CALL SUBOPT_0xA
	BRGE _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 0173 
; 0000 0174         //test();
; 0000 0175 
; 0000 0176         finall_caculation();
	RCALL _finall_caculation
; 0000 0177         return ;
	CALL __LOADLOCR6
	RJMP _0x2080007
; 0000 0178     }
; 0000 0179     else{
_0x3B:
; 0000 017A         error();
	CALL SUBOPT_0xD
; 0000 017B         return;
	RJMP _0x2080007
; 0000 017C     }
; 0000 017D 
; 0000 017E }
; .FEND
;
;//show the expression on LCD and when click on "=" key,
;// show the result of the expression .
;void show_on_lcd(void){
; 0000 0182 void show_on_lcd(void){
_show_on_lcd:
; .FSTART _show_on_lcd
; 0000 0183     unsigned char Key;
; 0000 0184     int result;
; 0000 0185     char result_string[10];
; 0000 0186 
; 0000 0187     DDRC = 0xF0;
	SBIW R28,10
	CALL __SAVELOCR4
;	Key -> R17
;	result -> R18,R19
;	result_string -> Y+4
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0188     PORTC = 0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0189 
; 0000 018A     DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 018B     PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 018C 
; 0000 018D     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 018E     lcd_clear();
	CALL _lcd_clear
; 0000 018F     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 0190 
; 0000 0191     while(1){
_0x3F:
; 0000 0192         Key = scan_key();
	RCALL _scan_key
	MOV  R17,R30
; 0000 0193 
; 0000 0194         if (Key != 0xFF){
	CPI  R17,255
	BRNE PC+2
	RJMP _0x42
; 0000 0195 
; 0000 0196             if( Key < 10){
	CPI  R17,10
	BRSH _0x43
; 0000 0197                 lcd_putchar(Key + '0');
	MOV  R26,R17
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
; 0000 0198                 exp[exp_size] = Key + '0';
	MOVW R26,R4
	SUBI R26,LOW(-_exp)
	SBCI R27,HIGH(-_exp)
	MOV  R30,R17
	SUBI R30,-LOW(48)
	RJMP _0x55
; 0000 0199                 exp_size++;
; 0000 019A 
; 0000 019B             }
; 0000 019C             else if( Key == 10){
_0x43:
	CPI  R17,10
	BRNE _0x45
; 0000 019D                 lcd_clear();
	CALL _lcd_clear
; 0000 019E 
; 0000 019F                 exp_size = 0;
	CLR  R4
	CLR  R5
; 0000 01A0 
; 0000 01A1                 top_operators = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
; 0000 01A2                 top_operands = -1;
	MOVW R6,R30
; 0000 01A3                 top_fix_oper = -1;
	MOVW R10,R30
; 0000 01A4             }
; 0000 01A5             else if( Key == 11){
	RJMP _0x46
_0x45:
	CPI  R17,11
	BRNE _0x47
; 0000 01A6 
; 0000 01A7                 //test();
; 0000 01A8 
; 0000 01A9                 lcd_clear();
	CALL _lcd_clear
; 0000 01AA                 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 01AB                 caculate_exp();
	RCALL _caculate_exp
; 0000 01AC                 result = peek_operand(operands, top_operands);
	CALL SUBOPT_0xB
	MOVW R18,R30
; 0000 01AD 
; 0000 01AE                 sprintf(result_string, "%d", result);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,19
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01AF                 lcd_puts(result_string);
	MOVW R26,R28
	ADIW R26,4
	CALL _lcd_puts
; 0000 01B0                 delay_ms(100);
	LDI  R26,LOW(100)
	CALL SUBOPT_0x2
; 0000 01B1 
; 0000 01B2                 exp_size = 0;
; 0000 01B3                 top_operators = -1;
; 0000 01B4                 top_operands = -1;
; 0000 01B5                 top_fix_oper = -1;
; 0000 01B6 
; 0000 01B7             }
; 0000 01B8             else if (Key == 12){
	RJMP _0x48
_0x47:
	CPI  R17,12
	BRNE _0x49
; 0000 01B9                 lcd_putchar('/');
	LDI  R26,LOW(47)
	CALL SUBOPT_0xF
; 0000 01BA                 exp[exp_size] = '/';
	LDI  R30,LOW(47)
	RJMP _0x55
; 0000 01BB                 exp_size++;
; 0000 01BC 
; 0000 01BD             }
; 0000 01BE             else if (Key == 13){
_0x49:
	CPI  R17,13
	BRNE _0x4B
; 0000 01BF                 lcd_putchar('*');
	LDI  R26,LOW(42)
	CALL SUBOPT_0xF
; 0000 01C0                 exp[exp_size] = '*';
	LDI  R30,LOW(42)
	RJMP _0x55
; 0000 01C1                 exp_size++;
; 0000 01C2 
; 0000 01C3             }
; 0000 01C4             else if (Key == 14){
_0x4B:
	CPI  R17,14
	BRNE _0x4D
; 0000 01C5                 lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0xF
; 0000 01C6                 exp[exp_size] = '-';
	LDI  R30,LOW(45)
	RJMP _0x55
; 0000 01C7                 exp_size++;
; 0000 01C8 
; 0000 01C9             }
; 0000 01CA             else if (Key == 15){
_0x4D:
	CPI  R17,15
	BRNE _0x4F
; 0000 01CB                 lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL SUBOPT_0xF
; 0000 01CC                 exp[exp_size] = '+';
	LDI  R30,LOW(43)
_0x55:
	ST   X,R30
; 0000 01CD                 exp_size++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 01CE             }
; 0000 01CF 
; 0000 01D0             delay_ms(30);
_0x4F:
_0x48:
_0x46:
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
; 0000 01D1 
; 0000 01D2             while(scan_key() != 0xFF){
_0x50:
	RCALL _scan_key
	CPI  R30,LOW(0xFF)
	BREQ _0x52
; 0000 01D3                 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 01D4             }
	RJMP _0x50
_0x52:
; 0000 01D5 
; 0000 01D6 
; 0000 01D7         }
; 0000 01D8     }
_0x42:
	RJMP _0x3F
; 0000 01D9 }
_0x2080007:
	ADIW R28,14
	RET
; .FEND
;
;void main( void){
; 0000 01DB void main( void){
_main:
; .FSTART _main
; 0000 01DC     show_on_lcd();
	RCALL _show_on_lcd
; 0000 01DD }
_0x53:
	RJMP _0x53
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x4
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	CALL SUBOPT_0x5
	TST  R31
	BRMI _0x2000014
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL SUBOPT_0x4
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2080006:
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x10
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x10
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080005
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080005:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
; .FSTART __lcd_delay_G101
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
; .FEND
__lcd_read_nibble_G101:
; .FSTART __lcd_read_nibble_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G101:
; .FSTART _lcd_read_byte0_G101
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080004:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x2080002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x2080002:
	LDD  R17,Y+0
_0x2080003:
	ADIW R28,3
	RET
; .FEND
__long_delay_G101:
; .FSTART __long_delay_G101
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G101:
; .FSTART __lcd_init_write_G101
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	RCALL __long_delay_G101
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R26,LOW(40)
	CALL SUBOPT_0x17
	LDI  R26,LOW(4)
	CALL SUBOPT_0x17
	LDI  R26,LOW(133)
	CALL SUBOPT_0x17
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strchr:
; .FSTART _strchr
	ST   -Y,R26
    ld   r26,y+
    ld   r30,y+
    ld   r31,y+
strchr0:
    ld   r27,z
    cp   r26,r27
    breq strchr1
    adiw r30,1
    tst  r27
    brne strchr0
    clr  r30
    clr  r31
strchr1:
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
_code:
	.BYTE 0x10
_exp:
	.BYTE 0x20
_operands:
	.BYTE 0x40
_operators:
	.BYTE 0x20
_fix_operand:
	.BYTE 0x40
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R19,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R27,0
	CALL _delay_ms
	CLR  R4
	CLR  R5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
	MOVW R6,R30
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(_operands)
	LDI  R31,HIGH(_operands)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(_operators)
	LDI  R31,HIGH(_operators)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_operands)
	LDI  R31,HIGH(_operands)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R6
	JMP  _peek_operand

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	JMP  _pop

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	CALL _error
	CALL __LOADLOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R19
	JMP  _push_operator

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	CALL _lcd_putchar
	LDI  R26,LOW(_exp)
	LDI  R27,HIGH(_exp)
	ADD  R26,R4
	ADC  R27,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	CALL __long_delay_G101
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
