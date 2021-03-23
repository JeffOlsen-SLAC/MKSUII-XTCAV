
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name mksuii_x -dir "X:/xilinx/mksuii_x/planAhead_run_1" -part xc5vlx30tff665-1
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "X:/xilinx/mksuii_x/mksuii_x.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {X:/xilinx/mksuii_x} {ipcore_dir} }
add_files "ipcore_dir/Acc12x16.ncf" "ipcore_dir/Acc12x20.ncf" "ipcore_dir/adds16s16.ncf" "ipcore_dir/Div20x8.ncf" "ipcore_dir/div54x16x32.ncf" "ipcore_dir/Drive_Lkup.ncf" "ipcore_dir/lkup44004.ncf" "ipcore_dir/mults16s16x54.ncf" "ipcore_dir/Ram16x12dp.ncf" "ipcore_dir/ram16x16.ncf" "ipcore_dir/Ram16x16dp.ncf" "ipcore_dir/Ram512x12dp.ncf" "ipcore_dir/RFDriveDPMem.ncf" "ipcore_dir/sign16xsign16.ncf" "ipcore_dir/SPI_Fifo.ncf" "ipcore_dir/subs16s16.ncf" "ipcore_dir/subu16u16.ncf" "ipcore_dir/sysmon_dpram.ncf" -fileset [get_property constrset [current_run]]
set_param project.paUcfFile  "mksuii_x.ucf"
add_files "mksuii_x.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
read_xdl -file "X:/xilinx/mksuii_x/mksuii_x.ncd"
if {[catch {read_twx -name results_1 -file "X:/xilinx/mksuii_x/mksuii_x.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"X:/xilinx/mksuii_x/mksuii_x.twx\": $eInfo"
}
