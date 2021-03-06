#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir -p results

echo 'Synthesizing sample design with XST';
xst -ifn xst.scr
cp GBit2_example_design.ngc ./results/

#Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
cp ../example_design/GBit2_example_design.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -uc GBit2_example_design.ucf GBit2_example_design.ngc GBit2_example_design.ngd

echo 'Running map'
map -ol high -timing GBit2_example_design -o mapped.ncd

echo 'Running par'
par -ol high mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed routed mapped.pcf

echo 'Running netgen to create gate level Verilog model'
netgen -ofmt verilog -sim -dir . -pcf mapped.pcf -tm GBit2_example_design -w -sdf_anno false routed.ncd routed.v
