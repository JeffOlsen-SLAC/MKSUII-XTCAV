
wave add /  -radix hex

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns
isim force add clock_En 1 -value 0 -time 10ns -value 1 -time 990ns -repeat 1us

isim force add pot_a 1
isim force add pot_b 1
run 1us

#up
isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 50us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 50us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 100us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 100us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us


run 100us


# Down
isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us
isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 0
run 10us

isim force add pot_a 1
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 1
run 10us

isim force add pot_a 0
isim force add pot_b 0
run 10us
