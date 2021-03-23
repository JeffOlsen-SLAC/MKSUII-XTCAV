
#wave add /  -radix hex

wcfg new

wave add clock reset clk1khzen lnk_wr
wave add ACC1Flow ACC2Flow WG1Flow WG2Flow KLYFlow
wave add iFlowFault
wave add iMagIIntlk iTrigOff iMagOff iMagTrigEn
wave add simTrigEn
wave add MagState
wave add Trigger_In
wave add Trigger_Out

restart

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add clk1hzen 1 -value 0 -time 10ns -value 1 -time 990ns -repeat 1us
isim force add clk10hzen 1 -value 0 -time 10ns -value 1 -time 990ns -repeat 1us
isim force add clk1khzen 1 -value 0 -time 10ns -value 1 -time 1000ns -repeat 1us
isim force add Trigger_In 1 -value 0 -time 10ns -value 1 -time 1500ns -repeat 1.5us


isim force add lnk_addr 0
isim force add lnk_wr 0
isim force add lnk_datain 0

isim force add triggeren_in 0
isim force add sw_trigen 1
isim force add bypassreg 0 -radix hex

isim force add m24v 0
isim force add klyvacana 0
isim force add wgvacana 0
isim force add focuscoiliana 0
isim force add focuscoilgndana 0
isim force add BeamI  0
isim force add BeamV 0
isim force add FWDPWR 0
isim force add REFLPWR 0
isim force add BeamILow 0
isim force add ACC1Flow 0
isim force add ACC2Flow 0
isim force add WG1Flow 0
isim force add WG2Flow 0
isim force add KLYFlow 0
isim force add tdiff 0
isim force add KLYVAC 0
isim force add WGVACBAD 0
isim force add n_WGVACOK 0
isim force add WGTCGauge 0
isim force add WGValve 0
isim force add MagIIntlk 0
isim force add MagIOK 0
isim force add MagKlixon 0
isim force add Tank_Lo 0
isim force add Tank_Hi 0
isim force add PumpII 0


run 200us
isim force add ACC1Flow 1
run 400us


# Clear Faults
isim force add lnk_addr 6
isim force add lnk_wr 1
isim force add lnk_datain ffffffff - radix hex
run 20ns
isim force add lnk_wr 0
run 1us
isim force add lnk_addr 7
isim force add lnk_wr 1
isim force add lnk_datain ffffffff - radix hex
run 20ns
isim force add lnk_wr 0

run 400us

isim force add ACC1Flow 0
run 400us

# Clear Faults
isim force add lnk_addr 6
isim force add lnk_wr 1
isim force add lnk_datain ffffffff - radix hex
run 20ns
isim force add lnk_wr 0
run 1us
isim force add lnk_addr 7
isim force add lnk_wr 1
isim force add lnk_datain ffffffff - radix hex
run 20ns
isim force add lnk_wr 0

run 400us

# set magnet fault (Off)
isim force add MagIIntlk 1
run 400us
isim force add MagIIntlk 0


run 400us


# Clear Faults
isim force add lnk_addr 6
isim force add lnk_wr 1
isim force add lnk_datain ffffffff - radix hex
run 20ns
isim force add lnk_wr 0
run 1us
isim force add lnk_addr 7
isim force add lnk_wr 1
isim force add lnk_datain ffffffff - radix hex
run 20ns
isim force add lnk_wr 0


run 400us

