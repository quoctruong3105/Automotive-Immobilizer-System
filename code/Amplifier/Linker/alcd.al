;PCODE: $00000000 VOL: 0
	#ifndef __SLEEP_DEFINED__
;PCODE: $00000001 VOL: 0
	#define __SLEEP_DEFINED__
;PCODE: $00000002 VOL: 0
	.EQU __se_bit=0x01
;PCODE: $00000003 VOL: 0
	.EQU __sm_mask=0x0E
;PCODE: $00000004 VOL: 0
	.EQU __sm_adc_noise_red=0x02
;PCODE: $00000005 VOL: 0
	.EQU __sm_powerdown=0x04
;PCODE: $00000006 VOL: 0
	.EQU __sm_powersave=0x06
;PCODE: $00000007 VOL: 0
	.EQU __sm_standby=0x0C
;PCODE: $00000008 VOL: 0
	.EQU __sm_ext_standby=0x0E
;PCODE: $00000009 VOL: 0
	.SET power_ctrl_reg=smcr
;PCODE: $0000000A VOL: 0
	#endif
;PCODE: $0000000B VOL: 0
;PCODE: $0000000C VOL: 0
