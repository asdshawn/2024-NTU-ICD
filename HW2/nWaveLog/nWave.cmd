verdiSetActWin -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1536 793
wvConvertFile -win $_nWave1 -o \
           "/home/raid7_2/user12/r2945050/ICD/HW2/EN.tr0.fsdb" \
           "/home/raid7_2/user12/r2945050/ICD/HW2/EN.tr0"
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/home/raid7_2/user12/r2945050/ICD/HW2/EN.tr0.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/"
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/v\(a\)} -color ID_RED5 \
{/v\(b\)} -color ID_ORANGE5 \
{/v\(z\)} -color ID_YELLOW5 \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvExit
