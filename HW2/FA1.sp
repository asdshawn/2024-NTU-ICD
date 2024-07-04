*********************************************
.inc '90nm_bulk.l'
.global VDD GND
.SUBCKT Sum VDD GND A B Ci S
MN1 W1 A GND GND NMOS l=0.1u w=0.25u m=1
MP1 W1 A VDD VDD PMOS l=0.1u w=0.5u m=1
MN2 W2 B A GND NMOS l=0.1u w=0.25u m=1
MP2 W2 B W1 VDD PMOS l=0.1u w=0.5u m=1
MN3 W2 A B GND NMOS l=0.1u w=0.25u m=1
MP3 W2 W1 B VDD PMOS l=0.1u w=0.5u m=1
MN4 W3 Ci GND GND NMOS l=0.1u w=0.25u m=1
MP4 W3 Ci VDD VDD PMOS l=0.1u w=0.5u m=1
MN5 W4 W2 W3 GND NMOS l=0.1u w=0.25u m=1
MP5 W4 W2 Ci VDD PMOS l=0.1u w=0.5u m=1
MN6 W4 W3 W2 GND NMOS l=0.1u w=0.25u m=1
MP6 W4 Ci W2 VDD PMOS l=0.1u w=0.5u m=1
MN7 S W4 GND GND NMOS l=0.1u w=0.25u m=1
MP7 S W4 VDD VDD PMOS l=0.1u w=0.5u m=1
.ENDS

.SUBCKT Cout VDD GND A B Ci Co
MN1 W1 Ci W2 GND NMOS l=0.1u w=0.25u m=1
MN2 W2 A GND GND NMOS l=0.1u w=0.25u m=1
MN3 W2 B GND GND NMOS l=0.1u w=0.25u m=1
MN4 W1 A W3 GND NMOS l=0.1u w=0.25u m=1
MN5 W3 B GND GND NMOS l=0.1u w=0.25u m=1
MP1 W4 A VDD VDD PMOS l=0.1u w=0.5u m=1
MP2 W4 B VDD VDD PMOS l=0.1u w=0.5u m=1
MP3 W1 Ci W4 VDD PMOS l=0.1u w=0.5u m=1
MP4 W1 A W5 VDD PMOS l=0.1u w=0.5u m=1
MP5 W5 B VDD VDD PMOS l=0.1u w=0.5u m=1
MN6 Co W1 GND GND NMOS l=0.1u w=0.25u m=1
MP6 Co W1 VDD VDD PMOS l=0.1u w=0.5u m=1
.ENDS

Vdd VDD GND dc=1.0

VA A 0 pulse (0 1.0 0 0 0 0.25u 0.5u)
VB B 0 pulse (0 1.0 0 0 0 0.5u 1u)
VCi Ci 0 pulse (0 1.0 0 0 0 1u 2u)

xS VDD GND A B Ci S Sum
xCo VDD GND A B Ci Co Cout

.tran 0.1n 2u
.op
.option post
.end
