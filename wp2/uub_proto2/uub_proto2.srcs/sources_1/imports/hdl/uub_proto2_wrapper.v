//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Fri Oct 19 14:03:46 2018
//Host        : dfn-x3100.auger.mtu.edu running 64-bit Scientific Linux release 6.8 (Carbon)
//Command     : generate_target uub_proto2_wrapper.bd
//Design      : uub_proto2_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module uub_proto2_wrapper
   (ADC0_CK_N,
    ADC0_CK_P,
    ADC1_CK_N,
    ADC1_CK_P,
    ADC2_CK_N,
    ADC2_CK_P,
    ADC3_CK_N,
    ADC3_CK_P,
    ADC4_CK_N,
    ADC4_CK_P,
    ADC_PWD,
    AMIGA_CLOCK_OUT,
    AMIGA_LTS_OUT,
    AMIGA_RX,
    AMIGA_TX,
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    ENABLE_RD_XFR,
    ENABLE_RD_XFR_CTL,
    FAKE_ENABLE_RD_XFR,
    FAKE_ENABLE_RD_XFR_CTL,
    FAKE_RD_SER_DATA0,
    FAKE_RD_SER_DATA0_CTL,
    FAKE_RD_SER_DATA1,
    FAKE_RD_SER_DATA1_CTL,
    FAKE_RD_XFR_CLK,
    FAKE_RD_XFR_CLK_CTL,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    FPGA_CK_N,
    FPGA_CK_P,
    GPS_PPS,
    GPS_RX,
    GPS_TX,
    LED_ASY,
    LED_FLG,
    P65,
    P6X,
    RADIO_CTS,
    RADIO_RST_IN,
    RADIO_RST_OUT,
    RADIO_RTS,
    RD_SER_DATA0,
    RD_SER_DATA0_CTL,
    RD_SER_DATA1,
    RD_SER_DATA1_CTL,
    RD_XFR_CLK,
    RD_XFR_CLK_CTL,
    TRIG_IN,
    TRIG_OUT,
    USB_IFAULT,
    WATCHDOG,
    adc0_n,
    adc0_p,
    adc1_n,
    adc1_p,
    adc2_n,
    adc2_p,
    adc3_n,
    adc3_p,
    adc4_n,
    adc4_p,
    ext0_ctl,
    ext0_dat,
    hconf);
  input ADC0_CK_N;
  input ADC0_CK_P;
  input ADC1_CK_N;
  input ADC1_CK_P;
  input ADC2_CK_N;
  input ADC2_CK_P;
  input ADC3_CK_N;
  input ADC3_CK_P;
  input ADC4_CK_N;
  input ADC4_CK_P;
  output ADC_PWD;
  output AMIGA_CLOCK_OUT;
  output AMIGA_LTS_OUT;
  input AMIGA_RX;
  output AMIGA_TX;
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  input ENABLE_RD_XFR;
  output [0:0]ENABLE_RD_XFR_CTL;
  output FAKE_ENABLE_RD_XFR;
  output [0:0]FAKE_ENABLE_RD_XFR_CTL;
  output FAKE_RD_SER_DATA0;
  output [0:0]FAKE_RD_SER_DATA0_CTL;
  output FAKE_RD_SER_DATA1;
  output [0:0]FAKE_RD_SER_DATA1_CTL;
  output FAKE_RD_XFR_CLK;
  output [0:0]FAKE_RD_XFR_CLK_CTL;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input FPGA_CK_N;
  input FPGA_CK_P;
  input GPS_PPS;
  input GPS_RX;
  output GPS_TX;
  output [0:0]LED_ASY;
  input LED_FLG;
  output P65;
  output [3:1]P6X;
  input RADIO_CTS;
  input RADIO_RST_IN;
  output RADIO_RST_OUT;
  output RADIO_RTS;
  input RD_SER_DATA0;
  output [0:0]RD_SER_DATA0_CTL;
  input RD_SER_DATA1;
  output [0:0]RD_SER_DATA1_CTL;
  input RD_XFR_CLK;
  output [0:0]RD_XFR_CLK_CTL;
  input TRIG_IN;
  output TRIG_OUT;
  input USB_IFAULT;
  inout WATCHDOG;
  input [11:0]adc0_n;
  input [11:0]adc0_p;
  input [11:0]adc1_n;
  input [11:0]adc1_p;
  input [11:0]adc2_n;
  input [11:0]adc2_p;
  input [11:0]adc3_n;
  input [11:0]adc3_p;
  input [11:0]adc4_n;
  input [11:0]adc4_p;
  output [7:0]ext0_ctl;
  output [3:0]ext0_dat;
  input [7:0]hconf;

  wire ADC0_CK_N;
  wire ADC0_CK_P;
  wire ADC1_CK_N;
  wire ADC1_CK_P;
  wire ADC2_CK_N;
  wire ADC2_CK_P;
  wire ADC3_CK_N;
  wire ADC3_CK_P;
  wire ADC4_CK_N;
  wire ADC4_CK_P;
  wire ADC_PWD;
  wire AMIGA_CLOCK_OUT;
  wire AMIGA_LTS_OUT;
  wire AMIGA_RX;
  wire AMIGA_TX;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire ENABLE_RD_XFR;
  wire [0:0]ENABLE_RD_XFR_CTL;
  wire FAKE_ENABLE_RD_XFR;
  wire [0:0]FAKE_ENABLE_RD_XFR_CTL;
  wire FAKE_RD_SER_DATA0;
  wire [0:0]FAKE_RD_SER_DATA0_CTL;
  wire FAKE_RD_SER_DATA1;
  wire [0:0]FAKE_RD_SER_DATA1_CTL;
  wire FAKE_RD_XFR_CLK;
  wire [0:0]FAKE_RD_XFR_CLK_CTL;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire FPGA_CK_N;
  wire FPGA_CK_P;
  wire GPS_PPS;
  wire GPS_RX;
  wire GPS_TX;
  wire [0:0]LED_ASY;
  wire LED_FLG;
  wire P65;
  wire [3:1]P6X;
  wire RADIO_CTS;
  wire RADIO_RST_IN;
  wire RADIO_RST_OUT;
  wire RADIO_RTS;
  wire RD_SER_DATA0;
  wire [0:0]RD_SER_DATA0_CTL;
  wire RD_SER_DATA1;
  wire [0:0]RD_SER_DATA1_CTL;
  wire RD_XFR_CLK;
  wire [0:0]RD_XFR_CLK_CTL;
  wire TRIG_IN;
  wire TRIG_OUT;
  wire USB_IFAULT;
  wire WATCHDOG;
  wire [11:0]adc0_n;
  wire [11:0]adc0_p;
  wire [11:0]adc1_n;
  wire [11:0]adc1_p;
  wire [11:0]adc2_n;
  wire [11:0]adc2_p;
  wire [11:0]adc3_n;
  wire [11:0]adc3_p;
  wire [11:0]adc4_n;
  wire [11:0]adc4_p;
  wire [7:0]ext0_ctl;
  wire [3:0]ext0_dat;
  wire [7:0]hconf;

  uub_proto2 uub_proto2_i
       (.ADC0_CK_N(ADC0_CK_N),
        .ADC0_CK_P(ADC0_CK_P),
        .ADC1_CK_N(ADC1_CK_N),
        .ADC1_CK_P(ADC1_CK_P),
        .ADC2_CK_N(ADC2_CK_N),
        .ADC2_CK_P(ADC2_CK_P),
        .ADC3_CK_N(ADC3_CK_N),
        .ADC3_CK_P(ADC3_CK_P),
        .ADC4_CK_N(ADC4_CK_N),
        .ADC4_CK_P(ADC4_CK_P),
        .ADC_PWD(ADC_PWD),
        .AMIGA_CLOCK_OUT(AMIGA_CLOCK_OUT),
        .AMIGA_LTS_OUT(AMIGA_LTS_OUT),
        .AMIGA_RX(AMIGA_RX),
        .AMIGA_TX(AMIGA_TX),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .ENABLE_RD_XFR(ENABLE_RD_XFR),
        .ENABLE_RD_XFR_CTL(ENABLE_RD_XFR_CTL),
        .FAKE_ENABLE_RD_XFR(FAKE_ENABLE_RD_XFR),
        .FAKE_ENABLE_RD_XFR_CTL(FAKE_ENABLE_RD_XFR_CTL),
        .FAKE_RD_SER_DATA0(FAKE_RD_SER_DATA0),
        .FAKE_RD_SER_DATA0_CTL(FAKE_RD_SER_DATA0_CTL),
        .FAKE_RD_SER_DATA1(FAKE_RD_SER_DATA1),
        .FAKE_RD_SER_DATA1_CTL(FAKE_RD_SER_DATA1_CTL),
        .FAKE_RD_XFR_CLK(FAKE_RD_XFR_CLK),
        .FAKE_RD_XFR_CLK_CTL(FAKE_RD_XFR_CLK_CTL),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .FPGA_CK_N(FPGA_CK_N),
        .FPGA_CK_P(FPGA_CK_P),
        .GPS_PPS(GPS_PPS),
        .GPS_RX(GPS_RX),
        .GPS_TX(GPS_TX),
        .LED_ASY(LED_ASY),
        .LED_FLG(LED_FLG),
        .P65(P65),
        .P6X(P6X),
        .RADIO_CTS(RADIO_CTS),
        .RADIO_RST_IN(RADIO_RST_IN),
        .RADIO_RST_OUT(RADIO_RST_OUT),
        .RADIO_RTS(RADIO_RTS),
        .RD_SER_DATA0(RD_SER_DATA0),
        .RD_SER_DATA0_CTL(RD_SER_DATA0_CTL),
        .RD_SER_DATA1(RD_SER_DATA1),
        .RD_SER_DATA1_CTL(RD_SER_DATA1_CTL),
        .RD_XFR_CLK(RD_XFR_CLK),
        .RD_XFR_CLK_CTL(RD_XFR_CLK_CTL),
        .TRIG_IN(TRIG_IN),
        .TRIG_OUT(TRIG_OUT),
        .USB_IFAULT(USB_IFAULT),
        .WATCHDOG(WATCHDOG),
        .adc0_n(adc0_n),
        .adc0_p(adc0_p),
        .adc1_n(adc1_n),
        .adc1_p(adc1_p),
        .adc2_n(adc2_n),
        .adc2_p(adc2_p),
        .adc3_n(adc3_n),
        .adc3_p(adc3_p),
        .adc4_n(adc4_n),
        .adc4_p(adc4_p),
        .ext0_ctl(ext0_ctl),
        .ext0_dat4(ext0_dat4),
        .ext0_dat5(ext0_dat5),
        .ext0_dat6(ext0_dat6),
        .ext0_dat7(ext0_dat7),
        .hconf(hconf));
endmodule
