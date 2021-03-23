
wave add /  -radix hex

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add newdecimal 70000 -radix dec
run 500ns

isim force add newbcd 1
run 10ns
isim force add newbcd 0

run 1us


