wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/home/raid7_2/user12/r2945050/ICD/HW4/sigmoid.vcd.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/AN3"
wvGetSignalSetScope -win $_nWave1 "/tb"
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/tb/clk} \
{/tb/i_valid} \
{/tb/i_x\[7:0\]} \
{/tb/o_valid} \
{/tb/o_y\[15:0\]} \
{/tb/rst_n} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/ABS_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/ASR2"
wvAddSignal -win $_nWave1 "/tb/DUT/ASR2/Z\[7:0\]"
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/ABS_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/OUT_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/ADD1_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/SQ_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/F_OP_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/ASR1"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/F_OP_0"
wvGetSignalSetScope -win $_nWave1 "/tb/DUT/OUT_0"
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/tb/clk} \
{/tb/i_valid} \
{/tb/i_x\[7:0\]} \
{/tb/o_valid} \
{/tb/o_y\[15:0\]} \
{/tb/rst_n} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/tb/DUT/ASR2/Z\[7:0\]} \
{/tb/DUT/ABS_0/Z\[7:0\]} \
{/tb/DUT/ADD1_0/Z\[7:0\]} \
{/tb/DUT/SQ_0/o_x\[15:0\]} \
{/tb/DUT/ASR1/Z\[15:0\]} \
{/tb/DUT/F_OP_0/Z\[15:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/tb/DUT/OUT_0/Z\[15:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 )} 
wvSetPosition -win $_nWave1 {("G3" 1)}
wvGetSignalClose -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1536 793
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 4 5 6 )} {( "G2" 1 2 3 4 5 6 )} {( "G3" \
           1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 4 5 6 )} {( "G2" 1 2 3 4 5 6 )} {( "G3" \
           1 )} 
wvSetRadix -win $_nWave1 -format Bin
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 6 )} 
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G4" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 2)}
wvSetPosition -win $_nWave1 {("G4" 2)}
wvSetCursor -win $_nWave1 96754.172690 -snap {("G5" 0)}
wvSetCursor -win $_nWave1 95448.888741 -snap {("G5" 0)}
wvSetCursor -win $_nWave1 92185.678870 -snap {("G4" 0)}
