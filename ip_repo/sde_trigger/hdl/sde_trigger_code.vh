// sde_trigger_code.vh
// 
// This is the code portion of the sde_trigger that is included into
// the base sde_trigger_vM_N_S00_AXI.v AXI peripheral generated by Vivado.
// This keeps the guts of our trigger code separated from all the AXI
// register interface code.
// 
// 08-Aug-2014 DFN Initial version.
// 26-Feb-2016 DFN Add external trigger
// 06-Apr-2016 DFN Change to put each ADC in its own 16 bit field to simplify
//                 unpacking.
// 17-Sep-2016 DFN Add single_bin_120mhz trigger
// 20-Sep-2016 DFN Add LED trigger (not just tag)
// 26-Sep-2016 DFN Delay SHWR_BUF_WNUM output by two clock cycles wrt
//                 SHWR_TRIGGER
// 18-Nov-2016 DFN Add mode to alternate SIPM calibration data in mu buffers
// 21-Nov-2017 DFN Add saving EVT_ID separately for each buffer
// 22-Nov-2017 DFN Add SHWR_TRIG_FAST for AMIGA; Add protection against
//                 incrementing full buffer mask at end of event and clearing
//                 it at the same time from AXI.  Requires AXI bus be 2x or
//                 more slower than trigger clock.
// 16-May-2018 DFN Add tot_40mhz trigger.
// 18-Sep-2018 DFN Add stretch of trigger signals to avoid missing them
// 20-Dec-2018 DFN Add synchronization of trigger in signal
// 07-Feb-2019 DFN Add scalers

`include "sde_trigger_regs.vh"  // All the reg & wire declarations

// Generate compatibility mode triggers.
// Some debug included below
single_bin_40mhz 
  sb_40mhz1(.ENABLE40(ENABLE40),
	    .CLK120(CLK120),
	    .ADC0(FILTB_PMT0),
	    .ADC1(FILTB_PMT1),
	    .ADC2(FILTB_PMT2),
	    .THRES0(COMPATIBILITY_SB_TRIG_THR0[`ADC_WIDTH-1:0]),
	    .THRES1(COMPATIBILITY_SB_TRIG_THR1[`ADC_WIDTH-1:0]),
	    .THRES2(COMPATIBILITY_SB_TRIG_THR2[`ADC_WIDTH-1:0]),
	    .TRIG_ENABLE(COMPATIBILITY_SB_TRIG_ENAB
                         [`COMPATIBILITY_SB_TRIG_ENAB_SHIFT+
                          `COMPATIBILITY_SB_TRIG_ENAB_WIDTH-1:
                          `COMPATIBILITY_SB_TRIG_ENAB_SHIFT]),
	    .MULTIPLICITY(COMPATIBILITY_SB_TRIG_ENAB
                          [`COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT+
                           `COMPATIBILITY_SB_TRIG_COINC_LVL_WIDTH-1:
                           `COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT]),
	    .TRIG(COMPATIBILITY_SB_TRIG)
	    );

tot_40mhz
  tot_40mhz1(.ENABLE40(ENABLE40),
	     .CLK120(CLK120),
             .RESET(SHWR_TRIGGER),
	     .ADC0(FILTB_PMT0),
	     .ADC1(FILTB_PMT1),
	     .ADC2(FILTB_PMT2),
	     .THRES0(COMPATIBILITY_TOT_TRIG_THR0[`ADC_WIDTH-1:0]),
	     .THRES1(COMPATIBILITY_TOT_TRIG_THR1[`ADC_WIDTH-1:0]),
	     .THRES2(COMPATIBILITY_TOT_TRIG_THR2[`ADC_WIDTH-1:0]),
	     .TRIG_ENABLE(COMPATIBILITY_TOT_TRIG_ENAB
                          [`COMPATIBILITY_TOT_TRIG_ENAB_SHIFT+
                           `COMPATIBILITY_TOT_TRIG_ENAB_WIDTH-1:
                           `COMPATIBILITY_TOT_TRIG_ENAB_SHIFT]),
	     .MULTIPLICITY(COMPATIBILITY_TOT_TRIG_ENAB
                           [`COMPATIBILITY_TOT_TRIG_COINC_LVL_SHIFT+
                            `COMPATIBILITY_TOT_TRIG_COINC_LVL_WIDTH-1:
                            `COMPATIBILITY_TOT_TRIG_COINC_LVL_SHIFT]),
             .OCCUPANCY(COMPATIBILITY_TOT_TRIG_OCC[`WIDTH_BITS-3:0]),
	     .TRIG(COMPATIBILITY_TOT_TRIG),
             .DEBUG(COMPATIBILITY_TOT_DEBUG)
	     );

totd_40mhz
  totd_40mhz1(.ENABLE40(ENABLE40),
	     .CLK120(CLK120),
             .RESET(SHWR_TRIGGER),
	     .ADC0(FILTB_PMT0),
	     .ADC1(FILTB_PMT1),
	     .ADC2(FILTB_PMT2),
             .BASELINE0(BASELINE[0]), 
             .BASELINE1(BASELINE[1]), 
             .BASELINE2(BASELINE[2]), 
	     .THRES0(COMPATIBILITY_TOTD_TRIG_THR0[`ADC_WIDTH-1:0]),
	     .THRES1(COMPATIBILITY_TOTD_TRIG_THR1[`ADC_WIDTH-1:0]),
	     .THRES2(COMPATIBILITY_TOTD_TRIG_THR2[`ADC_WIDTH-1:0]),
	     .TRIG_ENABLE(COMPATIBILITY_TOTD_TRIG_ENAB
                          [`COMPATIBILITY_TOTD_TRIG_ENAB_SHIFT+
                           `COMPATIBILITY_TOTD_TRIG_ENAB_WIDTH-1:
                           `COMPATIBILITY_TOTD_TRIG_ENAB_SHIFT]),
	     .MULTIPLICITY(COMPATIBILITY_TOTD_TRIG_ENAB
                           [`COMPATIBILITY_TOTD_TRIG_COINC_LVL_SHIFT+
                            `COMPATIBILITY_TOTD_TRIG_COINC_LVL_WIDTH-1:
                            `COMPATIBILITY_TOTD_TRIG_COINC_LVL_SHIFT]),
              .OCCUPANCY(COMPATIBILITY_TOTD_TRIG_OCC[`WIDTH_BITS-3:0]),
              .FD(COMPATIBILITY_TOTD_TRIG_FD[`COMPATIBILITY_TOTD_FD_BITS-1:0]),
              .FN(COMPATIBILITY_TOTD_TRIG_FN[`COMPATIBILITY_TOTD_FN_BITS-1:0]),
              .INT(COMPATIBILITY_TOTD_TRIG_INT[`COMPATIBILITY_INTEGRAL_BITS-1:0]),
	     .TRIG(COMPATIBILITY_TOTD_TRIG),
             .DEBUG(COMPATIBILITY_TOTD_DEBUG)
	     );	


// Generate full bandwidth triggers

single_bin_120mhz
  sb_120mhz1(.RESET(LCL_RESET),
             .CLK120(CLK120),
	     .ADC0(ADCD0[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	     .ADC1(ADCD1[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	     .ADC2(ADCD2[2*`ADC_WIDTH-1:`ADC_WIDTH]),
             .ADC_SSD(ADCD4[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	     .TRIG_THR0(SB_TRIG_THR0[`ADC_WIDTH-1:0]),
	     .TRIG_THR1(SB_TRIG_THR1[`ADC_WIDTH-1:0]),
	     .TRIG_THR2(SB_TRIG_THR2[`ADC_WIDTH-1:0]),
	     .TRIG_SSD(SB_TRIG_SSD[`ADC_WIDTH-1:0]),
	     .TRIG_ENAB(SB_TRIG_ENAB),
             .TRIG(SB_TRIG),
             .DEBUG(SB_TRIG_DEBUG)
  	     );

// Generate muon triggers

muon_trigger
  muon_trigger1(.RESET(LCL_RESET),
                .CLK120(CLK120),
	        .ADC0(ADC0[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC1(ADC1[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC2(ADC2[2*`ADC_WIDTH-1:`ADC_WIDTH]),
                .ADC_SSD(ADC4[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .TRIG_THR0(MUON_TRIG1_THR0[`ADC_WIDTH-1:0]),
	        .TRIG_THR1(MUON_TRIG1_THR1[`ADC_WIDTH-1:0]),
	        .TRIG_THR2(MUON_TRIG1_THR2[`ADC_WIDTH-1:0]),
	        .TRIG_SSD(MUON_TRIG1_SSD[`ADC_WIDTH-1:0]),
	        .TRIG_ENAB(MUON_TRIG1_ENAB),
                .TRIG(MUON_PRETRIG1),
                .DEBUG(MUON1_DEBUG)
  	        );
muon_trigger
  muon_trigger2(.RESET(LCL_RESET),
                .CLK120(CLK120),
	        .ADC0(ADC0[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC1(ADC1[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC2(ADC2[2*`ADC_WIDTH-1:`ADC_WIDTH]),
                .ADC_SSD(ADC4[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .TRIG_THR0(MUON_TRIG2_THR0[`ADC_WIDTH-1:0]),
	        .TRIG_THR1(MUON_TRIG2_THR1[`ADC_WIDTH-1:0]),
	        .TRIG_THR2(MUON_TRIG2_THR2[`ADC_WIDTH-1:0]),
	        .TRIG_SSD(MUON_TRIG2_SSD[`ADC_WIDTH-1:0]),
	        .TRIG_ENAB(MUON_TRIG2_ENAB),
                .TRIG(MUON_PRETRIG2),
                .DEBUG(MUON2_DEBUG)
  	        );

muon_buffers
  muon_buffers1(.RESET(LCL_RESET),
                .AXI_CLK(S_AXI_ACLK),
                .CLK120(CLK120),
	        .ADC0(ADC0[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC1(ADC1[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC2(ADC2[2*`ADC_WIDTH-1:`ADC_WIDTH]),
	        .ADC_CAL(ADC3[2*`ADC_WIDTH-1:`ADC_WIDTH]),
                .ADC_SSD(ADC4[2*`ADC_WIDTH-1:`ADC_WIDTH]),
                .MUON_TRIG_IN(MUON_PRETRIG),
                .MUON_BUF_CONTROL(MUON_BUF_CONTROL),
                .MUON_BUF_TRIG_MASK(MUON_BUF_TRIG_MASK),
                .AXI_MUON_CONTROL_WRITTEN(AXI_MUON_CONTROL_WRITTEN),
                .AXI_REG_WRITE(AXI_REG_WRITE),
                .MUON_TRIGGER(MUON_TRIGGER),
	        .MUON_INTR(MUON_INTR),
                .MUON_ENB(MUON_ENB),
                .MUON_BUF_WNUM(MUON_BUF_WNUM),
                .MUON_BUF_RNUM(MUON_BUF_RNUM),
                .MUON_EVT_CTR(MUON_EVT_CTR),
                .MUON_DATA0(MUON_DATA0),
                .MUON_DATA1(MUON_DATA1),
                .MUON_ADDR(MUON_ADDR),
                .MUON_BUF_TIME_TAG_A(MUON_BUF_TIME_TAG_A),
                .MUON_BUF_TIME_TAG_B(MUON_BUF_TIME_TAG_B),
                .MUON_BUF_STATUS(MUON_BUF_STATUS),
                .MUON_BUF_WORD_COUNT(MUON_BUF_WORD_COUNT),
                .DEBUG(MUON_BUFFER_DEBUG)
	        );

// Scalers
scaler
  scaler_a(.ENABLE40(ENABLE40),
	   .CLK120(CLK120),
	   .ADC0(FILTB_PMT0),
	   .ADC1(FILTB_PMT1),
	   .ADC2(FILTB_PMT2),
	   .THRES0(COMPATIBILITY_SCALER_A_THR0[`ADC_WIDTH-1:0]),
	   .THRES1(COMPATIBILITY_SCALER_A_THR1[`ADC_WIDTH-1:0]),
	   .THRES2(COMPATIBILITY_SCALER_A_THR2[`ADC_WIDTH-1:0]),
	   .TRIG_ENABLE(COMPATIBILITY_SCALER_A_ENAB
                        [`COMPATIBILITY_SB_TRIG_ENAB_SHIFT+
                         `COMPATIBILITY_SB_TRIG_ENAB_WIDTH-1:
                         `COMPATIBILITY_SB_TRIG_ENAB_SHIFT]),
	   .MULTIPLICITY(COMPATIBILITY_SCALER_A_ENAB
                         [`COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT+
                          `COMPATIBILITY_SB_TRIG_COINC_LVL_WIDTH-1:
                          `COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT]),
           .RESET(LCL_RESET | LCL_SCALER_A_COUNT_WRITTEN),
	   .COUNT(LCL_SCALER_A_COUNT),
           .DEBUG(SCALER_A_DEBUG)
	   );
scaler 
  scaler_b(.ENABLE40(ENABLE40),
	   .CLK120(CLK120),
	   .ADC0(FILTB_PMT0),
	   .ADC1(FILTB_PMT1),
	   .ADC2(FILTB_PMT2),
	   .THRES0(COMPATIBILITY_SCALER_B_THR0[`ADC_WIDTH-1:0]),
	   .THRES1(COMPATIBILITY_SCALER_B_THR1[`ADC_WIDTH-1:0]),
	   .THRES2(COMPATIBILITY_SCALER_B_THR2[`ADC_WIDTH-1:0]),
	   .TRIG_ENABLE(COMPATIBILITY_SCALER_B_ENAB
                        [`COMPATIBILITY_SB_TRIG_ENAB_SHIFT+
                         `COMPATIBILITY_SB_TRIG_ENAB_WIDTH-1:
                         `COMPATIBILITY_SB_TRIG_ENAB_SHIFT]),
	   .MULTIPLICITY(COMPATIBILITY_SCALER_B_ENAB
                         [`COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT+
                          `COMPATIBILITY_SB_TRIG_COINC_LVL_WIDTH-1:
                          `COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT]),
           .RESET(LCL_RESET | LCL_SCALER_B_COUNT_WRITTEN),
	   .COUNT(LCL_SCALER_B_COUNT),
           .DEBUG(SCALER_B_DEBUG)
	   );
scaler 
  scaler_c(.ENABLE40(ENABLE40),
	   .CLK120(CLK120),
	   .ADC0(FILTB_PMT0),
	   .ADC1(FILTB_PMT1),
	   .ADC2(FILTB_PMT2),
	   .THRES0(COMPATIBILITY_SCALER_C_THR0[`ADC_WIDTH-1:0]),
	   .THRES1(COMPATIBILITY_SCALER_C_THR1[`ADC_WIDTH-1:0]),
	   .THRES2(COMPATIBILITY_SCALER_C_THR2[`ADC_WIDTH-1:0]),
	   .TRIG_ENABLE(COMPATIBILITY_SCALER_C_ENAB
                        [`COMPATIBILITY_SB_TRIG_ENAB_SHIFT+
                         `COMPATIBILITY_SB_TRIG_ENAB_WIDTH-1:
                         `COMPATIBILITY_SB_TRIG_ENAB_SHIFT]),
	   .MULTIPLICITY(COMPATIBILITY_SCALER_C_ENAB
                         [`COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT+
                          `COMPATIBILITY_SB_TRIG_COINC_LVL_WIDTH-1:
                          `COMPATIBILITY_SB_TRIG_COINC_LVL_SHIFT]),
           .RESET(LCL_RESET | LCL_SCALER_C_COUNT_WRITTEN),
	   .COUNT(LCL_SCALER_C_COUNT),
           .DEBUG(SCALER_C_DEBUG)
	   );

// Keep track of signal area, peak, and baselines
genvar i;
generate for (i=0; i<10; i=i+2)
  begin: arealo
     shwr_integral area(.RESET(LCL_RESET),
			.CLK120(CLK120),
			.TRIGGERED(TRIGGERED),
			.HILO(0),
			.ADC(ADCD[i]),
			.ADCD(ADCDR[i]),
			.INTEGRAL(AREA[i]),
			.BASELINE(BASELINE[i]),
			.SBASELINE(SBASELINE[i]),
			.PEAK(PEAK[i]),
			.SATURATED(SATURATED[i])
			);
  end
endgenerate

generate for (i=1; i<10; i=i+2)
  begin: areahi
     shwr_integral area(.RESET(LCL_RESET),
			.CLK120(CLK120),
			.TRIGGERED(TRIGGERED),
			.HILO(1),
			.ADC(ADCD[i]),
			.ADCD(ADCDR[i]),
			.INTEGRAL(AREA[i]),
			.BASELINE(BASELINE[i]),
			.SBASELINE(SBASELINE[i]),
			.PEAK(PEAK[i]),
			.SATURATED(SATURATED[i])
			);
  end
endgenerate

// Generate LED pulses
led_control led_control1(.RESET(LCL_RESET),
                         .CLK120(CLK120),
                         .ONE_PPS(ONE_PPS),
                         .LED_CONTROL(LCL_LED_CONTROL),
                         .LED(LED),
                         .TRG_FLAG(LED_TRG_FLAG),
                         .DEBUG(LED_DEBUG)
                         );

// Stretch trigger out signal
stretch #(25) stretch_trgout(.CLK(CLK120),.IN(SOME_TRIG_OR),.OUT(TRIG_OUT));

// Stretch trigger signals
stretch #(2) stretch_compat_sb(.CLK(CLK120),
                               .IN(PRESCALED_COMPAT_SB_TRIG),
                               .OUT(STRETCHED_COMPAT_SB_TRIG));
stretch #(2) stretch_compat_tot(.CLK(CLK120),
                                .IN(PRESCALED_COMPAT_TOT_TRIG),
                                .OUT(STRETCHED_COMPAT_TOT_TRIG));
stretch #(2) stretch_compat_totd(.CLK(CLK120),
                                  .IN(PRESCALED_COMPAT_TOTD_TRIG),
                                  .OUT(STRETCHED_COMPAT_TOTD_TRIG));
stretch #(2) stretch_compat_ext(.CLK(CLK120),
                                 .IN(PRESCALED_COMPAT_EXT_TRIG),
                                 .OUT(STRETCHED_COMPAT_EXT_TRIG));
stretch #(2) stretch_sb(.CLK(CLK120),
                         .IN(SB_TRIG),
                         .OUT(STRETCHED_SB_TRIG));

// Synchronize external trigger input to clock
synchronizer_1bit ext_trig_sync(.ASYNC_IN(TRIG_IN),.CLK(CLK120),
                                .SYNC_OUT(TRIG_IN_SYNCED));

always @(posedge CLK120) begin
   LCL_RESET
     <= ((LCL_COMPATIBILITY_GLOBAL_CONTROL &
          `COMPATIBILITY_GLOBAL_CONTROL_RESET) != 0);
    
   if (LCL_RESET)
     begin
        //ENABLE40 <= 0;
        LCL_SHWR_BUF_WNUM <= 0;
        SHWR_BUF_NUM_FULL <= 0;
        SHWR_BUF_FULL_FLAGS <= 0;
        SHWR_BUF_RNUM <= 0;
        SHWR_EVT_CTR <= 0;
        //LCL_SHWR_BUF_TRIG_ID <= 0;
        //LCL_SHWR_BUF_STATUS <= 0;
        DEAD <= 0;
        SHWR_INTR <= 0;
        SHWR_ADDR1 <= 0;
        //EXT_TRIG <= 0;
        //ADC_EXTRA <= 0;
        //SOME_DLYD_TRIG <= 0;
        TRIGGERED <= 0;
        SOME_TRIG <= 0;
        // COMPAT_SB_TRIG_COUNTER <= 0;
        // COMPAT_TOT_TRIG_COUNTER <= 0;
        // COMPAT_TOTD_TRIG_COUNTER <= 0;
        // COMPAT_EXT_TRIG_COUNTER <= 0;
        // PRESCALED_COMPAT_SB_TRIG <= 0;
        // PRESCALED_COMPAT_TOT_TRIG <= 0;
        // PRESCALED_COMPAT_TOTD_TRIG <= 0;
        // PRESCALED_COMPAT_EXT_TRIG <= 0;
        for (DEADDLY = 0; DEADDLY<=`SHWR_DEAD_DLY; DEADDLY=DEADDLY+1)
	  SHWR_DEAD_DLYD[DEADDLY] <= 0;
	for (DELAY = 0; DELAY<=`SHWR_TRIG_DLY; DELAY=DELAY+1)
	  SHWR_TRIG_DLYD[DELAY] <= 0;
	SHWR_EVT_ID <= 0;
        for (INDEX = 0; INDEX<`SHWR_MEM_NBUF; INDEX=INDEX+1)
             LCL_SHWR_EVT_IDN[INDEX] <= 0;
     end
   else
     begin

        // Debugging code.  Std. code uses stretch module above always loop.
        //  TRIG_OUT <= FILT_PMT0 > 300;

	// Send SHWR_TRIG_FAST signal for AMIGA & possibly other use
	// For now this is just a copy of TRIGGERED, but keep separate so
	// we can add extra logic to this pulse, like shortening it from the
	// current ~10us.
	SHWR_TRIG_FAST <= TRIGGERED;

	// Delay SHWR_BUF_WNUM by two clock cycles. This is necessary to
        // compensate for timing delays within the time tagging module so that
        // it associates the trigger with the correct buffer.
        TMP_SHWR_BUF_WNUM <= LCL_SHWR_BUF_WNUM;
        SHWR_BUF_WNUM <= TMP_SHWR_BUF_WNUM;
        
        // Delay muon external trigger to be approx in sync with single bin
        MUON_EXT_TRIG[0] <= EXT_TRIG;
        for (MUON_EXTDLY = 1; MUON_EXTDLY<=`MUON_EXT_TRIG_DELAY; 
             MUON_EXTDLY = MUON_EXTDLY+1)
          MUON_EXT_TRIG[MUON_EXTDLY] <= MUON_EXT_TRIG[MUON_EXTDLY-1];

        // Form composite trigger for storing muon in muon buffer        
        MUON_PRETRIG <= (MUON_PRETRIG1 << `MUON_BUF_TRIG_SB1_SHIFT) |
			(MUON_PRETRIG2 << `MUON_BUF_TRIG_SB2_SHIFT) | 
			(MUON_EXT_TRIG[`MUON_EXT_TRIG_DELAY] <<
			 `MUON_BUF_TRIG_EXT_SHIFT);
        // MUON_PRETRIG <= (MUON_PRETRIG1 << `MUON_BUF_TRIG_SB1_SHIFT) |
	// 		(MUON_PRETRIG2 << `MUON_BUF_TRIG_SB2_SHIFT) | 
	// 		(MUON_PRETRIG3 <<`MUON_BUF_TRIG_SB3_SHIFT) | 
	// 		(MUON_PRETRIG4 <<`MUON_BUF_TRIG_SB4_SHIFT) |
	// 		(MUON_EXT_TRIG[`MUON_EXT_TRIG_DELAY] <<
	// 		 `MUON_BUF_TRIG_EXT_SHIFT);

        // Form external trigger on upward transition
        TRIG_IN_PREV <= TRIG_IN_SYNCED;
        EXT_TRIG <= TRIG_IN_SYNCED & !TRIG_IN_PREV;

        SOME_TRIG_OR <= |SOME_TRIG;
	
        // Handle prescaling of shower triggers
        if (SHWR_BUF_TRIG_MASK & `COMPAT_PRESCALE_SHWR_BUF_TRIG_SB) begin
           if (COMPATIBILITY_SB_TRIG) begin
              COMPAT_SB_TRIG_COUNTER <= COMPAT_SB_TRIG_COUNTER + 1;
              if (COMPAT_SB_TRIG_COUNTER == 0) PRESCALED_COMPAT_SB_TRIG <= 1;
           end
           else
             PRESCALED_COMPAT_SB_TRIG <= 0;
        end
        else
          PRESCALED_COMPAT_SB_TRIG <= COMPATIBILITY_SB_TRIG;

        if (SHWR_BUF_TRIG_MASK & `COMPAT_PRESCALE_SHWR_BUF_TRIG_TOT) begin
           if (COMPATIBILITY_TOT_TRIG) begin
              COMPAT_TOT_TRIG_COUNTER <= COMPAT_TOT_TRIG_COUNTER + 1;
              if (COMPAT_TOT_TRIG_COUNTER == 0) PRESCALED_COMPAT_TOT_TRIG <= 1;
           end
           else
             PRESCALED_COMPAT_TOT_TRIG <= 0;
        end
        else
          PRESCALED_COMPAT_TOT_TRIG <= COMPATIBILITY_TOT_TRIG;

                if (SHWR_BUF_TRIG_MASK & `COMPAT_PRESCALE_SHWR_BUF_TRIG_TOTD) begin
           if (COMPATIBILITY_TOTD_TRIG) begin
              COMPAT_TOTD_TRIG_COUNTER <= COMPAT_TOTD_TRIG_COUNTER + 1;
              if (COMPAT_TOTD_TRIG_COUNTER == 0) PRESCALED_COMPAT_TOTD_TRIG <= 1;
           end
           else
             PRESCALED_COMPAT_TOTD_TRIG <= 0;
        end
        else
          PRESCALED_COMPAT_TOTD_TRIG <= COMPATIBILITY_TOTD_TRIG;

        if (SHWR_BUF_TRIG_MASK & `COMPAT_PRESCALE_SHWR_BUF_TRIG_EXT) begin
           if (EXT_TRIG) begin
              COMPAT_EXT_TRIG_COUNTER <= COMPAT_EXT_TRIG_COUNTER + 1;
              if (COMPAT_EXT_TRIG_COUNTER == 0) PRESCALED_COMPAT_EXT_TRIG <= 1;
	   end
           else
             PRESCALED_COMPAT_EXT_TRIG <= 0;
        end
        else
          PRESCALED_COMPAT_EXT_TRIG <= EXT_TRIG;

	// Repetitive code block that scrubs the filtered ADC data,
	// delays ADC data, and loads shower memory.
`include "adc_filt_delay_block.vh"
        
        // Make offset to data in current buffer to read available
        LCL_SHWR_BUF_STARTT[`SHWR_MEM_BUF_SHIFT+`SHWR_BUF_NUM_WIDTH-1:0]
  <= LCL_SHWR_BUF_STARTN[SHWR_BUF_RNUM];
        // Blocking assignment here is on purpose. Don't change without
        // a careful test!
        LCL_SHWR_BUF_STARTT[31:`SHWR_MEM_BUF_SHIFT+`SHWR_BUF_NUM_WIDTH] = 0;

        // Adjust for logic delay
        LCL_SHWR_BUF_START <= ((LCL_SHWR_BUF_STARTT+12) 
                               & (`SHWR_MEM_DEPTH-1)) >> 2;
        LCL_SHWR_BUF_TRIG_ID <= LCL_SHWR_BUF_TRIG_IDN[SHWR_BUF_RNUM];
        
        // Create enable for downsampling the data.
        if (ENABLE40 >= 2)
	  ENABLE40 <= 0;
        else
	  ENABLE40 <= ENABLE40+1;

        // Do we have a free buffer? If not, we can't process this trigger.
        // Note that the way this is implemented here we can only fill n-1 of
        // the buffers, or we'll end up overwriting the oldest buffer. So this
        // simple logic will not work well for only 2 buffers. To use all the
        // buffers we would have to turn off the write enable to the dual
        // ported memory if all buffers were full. Let's keep the simple logic
        // for now.
        
        if ((SHWR_BUF_NUM_FULL < `SHWR_MEM_NBUF-1)) begin

           if (!TRIGGERED && !DEAD) begin
              // "or" of first triggers
              SOME_TRIG <=  ((STRETCHED_COMPAT_SB_TRIG << 
                              `COMPATIBILITY_SHWR_BUF_TRIG_SB_SHIFT) &
                             (SHWR_BUF_TRIG_MASK & 
                              `COMPATIBILITY_SHWR_BUF_TRIG_SB))
                |  ((STRETCHED_COMPAT_TOT_TRIG << 
                     `COMPATIBILITY_SHWR_BUF_TRIG_TOT_SHIFT) &
                    (SHWR_BUF_TRIG_MASK & 
                     `COMPATIBILITY_SHWR_BUF_TRIG_TOT)) 
                |  ((STRETCHED_COMPAT_TOTD_TRIG << 
                     `COMPATIBILITY_SHWR_BUF_TRIG_TOTD_SHIFT) &
                    (SHWR_BUF_TRIG_MASK & 
                     `COMPATIBILITY_SHWR_BUF_TRIG_TOTD)) 
              | ((STRETCHED_COMPAT_EXT_TRIG <<
                  `COMPATIBILITY_SHWR_BUF_TRIG_EXT_SHIFT) & 
                 (SHWR_BUF_TRIG_MASK & `COMPATIBILITY_SHWR_BUF_TRIG_EXT))
              | ((STRETCHED_SB_TRIG << `SHWR_BUF_TRIG_SB_SHIFT) & 
                 (SHWR_BUF_TRIG_MASK & `SHWR_BUF_TRIG_SB))
              | ((LED_TRG_FLAG << `SHWR_BUF_TRIG_LED_SHIFT) & 
                 (SHWR_BUF_TRIG_MASK & `SHWR_BUF_TRIG_LED));
              
              if (SOME_TRIG) begin
                 TRIGGERED <= 1;
		 SHWR_EVT_ID  <= SHWR_EVT_ID + 1;
                 SHWR_TRIG_DLYD[0] <= 1;
                 DEAD <= 1;
                 SHWR_DEAD_DLYD[0] <= 1;

                 // Trigger ID of first trigger. 
                 LCL_SHWR_BUF_TRIG_IDN[LCL_SHWR_BUF_WNUM] 
                   <= SOME_TRIG |  (LED_TRG_FLAG << `SHWR_BUF_TRIG_LED_SHIFT);
		 SOME_TRIG <= 0;
              end // if (SOME_TRIG)
           end // if (!TRIGGERED && !DEAD)

           // Process dead time
           if (DEAD) begin
              SHWR_DEAD_DLYD[0] <= 0;
              for (DEADDLY = 0; DEADDLY<`SHWR_DEAD_DLY; DEADDLY=DEADDLY+1)
	        SHWR_DEAD_DLYD[DEADDLY+1] <= SHWR_DEAD_DLYD[DEADDLY];     
              if (SHWR_DEAD_DLYD[`SHWR_DEAD_DLY]) 
                DEAD <= 0;
           end

           // Process trigger delay 
           if (TRIGGERED) begin
              
              // "or" of delayed triggers
              SOME_DLYD_TRIG <=  ((STRETCHED_COMPAT_SB_TRIG << 
                                   `COMPATIBILITY_SHWR_BUF_TRIG_SB_SHIFT) &
                                  (SHWR_BUF_TRIG_MASK & 
                                   `COMPATIBILITY_SHWR_BUF_TRIG_SB))
                |  ((STRETCHED_COMPAT_TOT_TRIG << 
                                   `COMPATIBILITY_SHWR_BUF_TRIG_TOT_SHIFT) &
                                  (SHWR_BUF_TRIG_MASK & 
                                   `COMPATIBILITY_SHWR_BUF_TRIG_TOT)) 
                |  ((STRETCHED_COMPAT_TOTD_TRIG << 
                                   `COMPATIBILITY_SHWR_BUF_TRIG_TOTD_SHIFT) &
                                  (SHWR_BUF_TRIG_MASK & 
                                   `COMPATIBILITY_SHWR_BUF_TRIG_TOTD)) 
		| ((STRETCHED_COMPAT_EXT_TRIG << 
                    `COMPATIBILITY_SHWR_BUF_TRIG_EXT_SHIFT) & 
                   (SHWR_BUF_TRIG_MASK & `COMPATIBILITY_SHWR_BUF_TRIG_EXT))
              | ((STRETCHED_SB_TRIG << `SHWR_BUF_TRIG_SB_SHIFT) & 
                 (SHWR_BUF_TRIG_MASK & `SHWR_BUF_TRIG_SB));

              LCL_SHWR_BUF_TRIG_IDN[LCL_SHWR_BUF_WNUM]
                <= LCL_SHWR_BUF_TRIG_IDN[LCL_SHWR_BUF_WNUM] |
                   (SOME_DLYD_TRIG<<8) |  
		   (LED_TRG_FLAG << (`SHWR_BUF_TRIG_LED_SHIFT+8));             
	      
              // Delay this action to the end of the buffer
 	      SHWR_TRIG_DLYD[0] <= 0;
              for (DELAY = 0; DELAY<`SHWR_TRIG_DLY; DELAY=DELAY+1)
	        SHWR_TRIG_DLYD[DELAY+1] <= SHWR_TRIG_DLYD[DELAY];
              
              // If rising edge, we have a trigger and are at the end of the buffer
              if (SHWR_TRIG_DLYD[`SHWR_TRIG_DLY]) 
	        begin
                   // Mark buffer as full and switch to the next one
                   SHWR_TRIGGER <= 1;
 		   SHWR_BUF_FULL_FLAGS <= SHWR_BUF_FULL_FLAGS |
                                          (1<<LCL_SHWR_BUF_WNUM);
		   SHWR_BUF_NUM_FULL <= SHWR_BUF_NUM_FULL+1;
		   LCL_SHWR_BUF_WNUM <= LCL_SHWR_BUF_WNUM+1;
		   SHWR_INTR <= 1;
		   SHWR_EVT_CTR <= SHWR_EVT_CTR+1;
		   TRIGGERED <= 0;

		   // Save event ID of this event
		   LCL_SHWR_EVT_IDN[LCL_SHWR_BUF_WNUM] <= SHWR_EVT_ID;
		   
		   // Save address to start of trace
		   LCL_SHWR_BUF_STARTN[LCL_SHWR_BUF_WNUM] <= SHWR_ADDR;

		   // Save computed values that we will load in registers
		   LCL_SHWR_PEAK_AREA0[LCL_SHWR_BUF_WNUM] 
		     <= AREA[0] | (PEAK[0] << `SHWR_PEAK_SHIFT) |
			(SATURATED[0] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA1[LCL_SHWR_BUF_WNUM] 
		     <= AREA[1] | (PEAK[1] << `SHWR_PEAK_SHIFT) |
			(SATURATED[1] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA2[LCL_SHWR_BUF_WNUM] 
		     <= AREA[2] | (PEAK[2] << `SHWR_PEAK_SHIFT) |
			(SATURATED[2] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA3[LCL_SHWR_BUF_WNUM] 
		     <= AREA[3] | (PEAK[3] << `SHWR_PEAK_SHIFT) |
			(SATURATED[3] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA4[LCL_SHWR_BUF_WNUM] 
		     <= AREA[4] | (PEAK[4] << `SHWR_PEAK_SHIFT) |
			(SATURATED[4] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA5[LCL_SHWR_BUF_WNUM] 
		     <= AREA[5] | (PEAK[5] << `SHWR_PEAK_SHIFT) |
			(SATURATED[5] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA6[LCL_SHWR_BUF_WNUM] 
		     <= AREA[6] | (PEAK[6] << `SHWR_PEAK_SHIFT) |
			(SATURATED[6] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA7[LCL_SHWR_BUF_WNUM] 
		     <= AREA[7] | (PEAK[7] << `SHWR_PEAK_SHIFT) |
			(SATURATED[7] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA8[LCL_SHWR_BUF_WNUM] 
		     <= AREA[8] | (PEAK[8] << `SHWR_PEAK_SHIFT) |
			(SATURATED[8] << `SHWR_SATURATED_SHIFT);
		   LCL_SHWR_PEAK_AREA9[LCL_SHWR_BUF_WNUM] 
		     <= AREA[9] | (PEAK[9] << `SHWR_PEAK_SHIFT) |
			(SATURATED[9] << `SHWR_SATURATED_SHIFT);

		   LCL_SHWR_BASELINE0[LCL_SHWR_BUF_WNUM]
		     <= BASELINE[0] | (BASELINE[1] << 16);
		   LCL_SHWR_BASELINE1[LCL_SHWR_BUF_WNUM]
		     <= BASELINE[2] | (BASELINE[3] << 16);
		   LCL_SHWR_BASELINE2[LCL_SHWR_BUF_WNUM]
		     <= BASELINE[4] | (BASELINE[5] << 16);
		   LCL_SHWR_BASELINE3[LCL_SHWR_BUF_WNUM]
		     <= BASELINE[6] | (BASELINE[7] << 16);
		   LCL_SHWR_BASELINE4[LCL_SHWR_BUF_WNUM]
		     <= BASELINE[8] | (BASELINE[9] << 16);
                end // if (SHWR_TRIG_DLYD[`SHWR_TRIG_DLY])
           end // if (TRIGGERED)
           else
             SHWR_TRIGGER <= 0;
        end  // if ((SHWR_BUF_NUM_FULL < `SHWR_MEM_NBUF-1)
        
        // Process clearing of shower buf full flag
        if (!SHWR_TRIG_DLYD[`SHWR_TRIG_DLY]) 
 	  begin
             PREV_SHWR_CONTROL_WRITTEN <= LCL_SHWR_CONTROL_WRITTEN;
             // Note that this is active on the trailing edge of write when
             // all data are stable.
	     if (PREV_SHWR_CONTROL_WRITTEN && !LCL_SHWR_CONTROL_WRITTEN)
	       begin
                  // Blocking assignment here is on purpose, so be careful  
                  SHWR_BUF_RESET  
		    = (1<<LCL_SHWR_BUF_CONTROL) & SHWR_BUF_FULL_FLAGS;
		  if ((SHWR_BUF_RESET != 0) 
		      && (LCL_SHWR_BUF_CONTROL == SHWR_BUF_RNUM))
		    begin
		       LCL_SHWR_BUF_TRIG_IDN[SHWR_BUF_RNUM] <= 0;
		       SHWR_BUF_FULL_FLAGS <= SHWR_BUF_FULL_FLAGS & 
					      ~SHWR_BUF_RESET;
		       SHWR_BUF_NUM_FULL <= SHWR_BUF_NUM_FULL-1;
		       SHWR_BUF_RNUM <= SHWR_BUF_RNUM+1;
		       // Reset shwr intr pending if resetting last filled buffer
		       if (SHWR_BUF_NUM_FULL == 1) SHWR_INTR <= 0;
		    end
	       end // if ((PREV_SHWR_CONTROL_WRITTEN & !LCL_SHWR_CONTROL_WRITTEN) == 1)
	  end  // if (!SHWR_TRIG_DLYD[`SHWR_TRIG_DLY]) 
        else
          SHWR_BUF_RESET <= 0;
        
        // Process loading information into status registers
        
        // Load ID register with compile date. 
        ID_REG <= `COMPILE_DATE;

        // Process loading of status registers from internal registers

        // Load shower buffer status register 
        // Load as sub-register as alternative to test timing performance
        LCL_SHWR_BUF_STATUS[`SHWR_BUF_WNUM_SHIFT+`SHWR_BUF_NUM_WIDTH-1:
                            `SHWR_BUF_WNUM_SHIFT] <= LCL_SHWR_BUF_WNUM;
        LCL_SHWR_BUF_STATUS[`SHWR_BUF_RNUM_SHIFT+`SHWR_BUF_NUM_WIDTH-1:
                            `SHWR_BUF_RNUM_SHIFT] <= SHWR_BUF_RNUM;
        LCL_SHWR_BUF_STATUS[`SHWR_BUF_FULL_SHIFT+`SHWR_MEM_NBUF-1:
                            `SHWR_BUF_FULL_SHIFT] <= SHWR_BUF_FULL_FLAGS;
        LCL_SHWR_BUF_STATUS[`SHWR_INTR_PEND_SHIFT:
                            `SHWR_INTR_PEND_SHIFT] <= SHWR_INTR;
        LCL_SHWR_BUF_STATUS[`SHWR_BUF_NFULL_SHIFT+`SHWR_BUF_NUM_WIDTH:
                            `SHWR_BUF_NFULL_SHIFT] <= SHWR_BUF_NUM_FULL;
        LCL_SHWR_BUF_STATUS[`SHWR_EVT_ID_SHIFT-1:`SHWR_BUF_NOTUSED_SHIFT] <= 0;
        LCL_SHWR_BUF_STATUS[31:`SHWR_EVT_ID_SHIFT] 
	  <= LCL_SHWR_EVT_IDN[SHWR_BUF_RNUM];

        // Send debug output to test pins P61 through P63

        P61 <= SCALER_A_DEBUG[0];
        P62 <= SCALER_A_DEBUG[1];
        P63 <= SCALER_A_DEBUG[2];
         
     end // else: !if(LCL_RESET)
end

// Include code to synchronize between the AXI bus & local registers
`include "axi_sync_block.vh"

