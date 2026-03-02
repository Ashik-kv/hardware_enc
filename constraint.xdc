set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports clk]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -period 10.00 -name sys_clk_pin  -waveform {0 5} -add [get_ports clk];

set_property -dict {PACKAGE_PIN C12  IOSTANDARD LVCMOS33} [get_ports {rst_n}]

set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVCMOS33 } [get_ports {uart_tx}];

set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports { uart_rx }];
