-makelib xcelium_lib/xpm -sv \
  "/home/root07/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/home/root07/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../quartsine.srcs/sources_1/ip/blk_mem_gen/sim/blk_mem_gen.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

