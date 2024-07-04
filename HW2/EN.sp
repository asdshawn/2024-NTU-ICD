*********************************************
.inc '90nm_bulk.l'
.global VDD GND
.SUBCKT EN A B Z 
*.PININFO DVDD:I GND:I In:I Out:O
MN1 W1 A GND GND NMOS l=0.1u w=0.25u m=1
MP1 W1 A VDD VDD PMOS l=0.1u w=0.5u m=1
MN2 W2 B W1 GND NMOS l=0.1u w=0.25u m=1
MP2 W2 B A VDD PMOS l=0.1u w=0.5u m=1
MN3 W2 W1 B GND NMOS l=0.1u w=0.25u m=1
MP3 W2 A B DVDD PMOS l=0.1u w=0.5u m=1
MN4 Z W2 GND GND NMOS l=0.1u w=0.25u m=1
MP4 Z W2 VDD VDD PMOS l=0.1u w=0.5u m=1
.ENDS

Vdd VDD GND dc=1.0
VA A 0 pulse (0 1.0 0 0 0 0.25u 0.5u)
VB B 0 pulse (0 1.0 0 0 0 0.5u 1u)

xEN A B Z EN

.tran 0.1n 1u
.op
.option post
.end