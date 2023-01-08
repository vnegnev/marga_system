//-----------------------------------------------------------------------------
// Title         : marga_system
// Project       : MaRCoS
//-----------------------------------------------------------------------------
// File          : marga_system.sv
// Author        :   <vlad@arch-nvme>
// Created       : 08.01.2023
// Last modified : 08.01.2023
//-----------------------------------------------------------------------------
// Description :
//
// MaRGA system wrapper: MaRGA + RX/TX chains and glue logic
//
// Outputs:
// - direct SPI lines to the gradient boards
// - direct SPI/I2C? lines to the attenuator core [TODO]
// - external trigger output
// - RX and TX gate outputs
// - 2x 14-bit buses to DAC outputs (must be combined externally) [TODO: check]
//
// Inputs:
// - 2x 16-bit buses from ADC inputs
// - ADC line from GPA-FHDO
// - external trigger input
//
// Internal structure:
// - mardecode core, responsible for outputs and their timing, and RX FIFOs
// - resetting and phase offsetting/incrementing is handled here for
// the TX DDSes and their routing

// -----------------------------------------------------------------------------
// See LICENSE for GPL licensing information
// ------------------------------------------------------------------------------

`ifndef _MARGA_SYSTEM_
 `define _MARGA_SYSTEM_

 `include "marga.sv"
 `include "cic_d.sv"
 `include "dds.sv"
 `include "complex_multiplier.v"

 `timescale 1ns / 1ns

module marga_system
  #()
   (
    // AXI slave bus interface
    // Ports of Axi Slave Bus Interface S0_AXI
    input				  s0_axi_aclk,
    input				  s0_axi_aresetn,
    input [C_S0_AXI_ADDR_WIDTH-1 : 0]	  s0_axi_awaddr,
    input [2 : 0]			  s0_axi_awprot,
    input				  s0_axi_awvalid,
    output				  s0_axi_awready,
    input [C_S0_AXI_DATA_WIDTH-1 : 0]	  s0_axi_wdata,
    input [(C_S0_AXI_DATA_WIDTH/8)-1 : 0] s0_axi_wstrb,
    input				  s0_axi_wvalid,
    output				  s0_axi_wready,
    output [1 : 0]			  s0_axi_bresp,
    output				  s0_axi_bvalid,
    input				  s0_axi_bready,
    input [C_S0_AXI_ADDR_WIDTH-1 : 0]	  s0_axi_araddr,
    input [2 : 0]			  s0_axi_arprot,
    input				  s0_axi_arvalid,
    output				  s0_axi_arready,
    output [C_S0_AXI_DATA_WIDTH-1 : 0]	  s0_axi_rdata,
    output [1 : 0]			  s0_axi_rresp,
    output				  s0_axi_rvalid,
    input				  s0_axi_rready

    // ADC inputs
    input [15:0]			  adc0_i,
    input [15:0]			  adc1_i,

    // DAC outputs
    output reg [13:0]			  dac0_o,
    output reg [13:0]			  dac1_o,

    // OCRA1 outputs
    output				  ocra1_clk_o,
    output				  ocra1_syncn_o,
    output				  ocra1_ldacn_o,
    output				  ocra1_sdox_o,
    output				  ocra1_sdoy_o,
    output				  ocra1_sdoz_o,
    output				  ocra1_sdoz2_o,

    // GPA-FHDO I/O
    input				  fhdo_sdi_i,
    output				  fhdo_clk_o,
    output				  fhdo_sdo_o,
    output				  fhdo_ssn_o,

    // trigger input and output
    input				  trig_i,
    output reg				  trig_o,

    // RX and TX gate
    output reg				  rx_gate_o,
    output reg				  tx_gate_o,

    // LEDs
    output reg [7:0]			  leds_o
    )

   // Parameters of Axi Slave Bus Interface S0_AXI
   parameter integer 			      C_S0_AXI_DATA_WIDTH = 32;
   parameter integer			      C_S0_AXI_ADDR_WIDTH = 19;
   wire					      clk = s0_axi_aclk, rst_n = s0_axi_aresetn;

endmodule // marga_system
`endif //  `ifndef _MARGA_SYSTEM_
