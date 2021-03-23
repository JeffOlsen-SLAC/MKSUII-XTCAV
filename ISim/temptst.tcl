restart

isim force add clock 0 -value 1 -time 4.2ns -repeat 8.4ns
isim force add Reset 1 -value 0 -time 100ns

# In 35, out 37
isim force add outtemp_count 8C06 -radix hex
isim force add intemp_count 9803 -radix hex
isim force add tempoffset 0CAB -radix hex
isim force add deltatempmax 0CAB -radix hex

run 1us

# in 45, out 47
isim force add outtemp_count 5E0F -radix hex
isim force add intemp_count 65AA -radix hex
isim force add tempoffset 0CAB -radix hex
isim force add deltatempmax 0CAB -radix hex

run 1us

# in 24, out 26
isim force add outtemp_count DECD -radix hex
isim force add intemp_count F343 -radix hex
isim force add tempoffset 0CAB -radix hex
isim force add deltatempmax 0CAB -radix hex

run 1us
