// Module to test data transfers from the RD detector.
//
// 11-Oct-2018 DFN Initial version


`define ADDR_BITS 10 // Number of address bits for event memory
`define MEM_SIZE 2048


//`define MUON_PULSES          // Generate muon pulse train instead of one
//                             // suitable for shower testing

module fake_rd_interface 
  (
   input wire DO_FAKE_XFR,
   input wire SERIAL_DATA0_IN,
   input wire SERIAL_CLK_IN,
   input wire ENABLE_XFR_IN,
   input wire XFR_DONE_ACK,
   input wire [31:0] FAKE_DATA,
   input wire LOCAL_CLK,
   input wire AXI_CLK,
   
   output reg ENABLE_FAKE_XFR,
   output reg SERIAL_FAKE_OUT,
   output reg[31:0] FAKE_DATA_ADDR,
   output reg[31:0] DATA_ADDR,
   output reg[31:0] DATA_TO_MEM,
   output reg ENABLE_MEM_WRT,
   output wire XFR_DONE
   );

   wire       LOCAL_DO_FAKE_XFR;
   reg        PREV_DO_FAKE_XFR;
   reg [3:0]  SERIAL_IN_BIT_COUNT;
   reg [3:0]  SERIAL_OUT_BIT_COUNT;
   reg        LOCAL_XFR_DONE;
   reg        PREV_ENABLE_XFR_IN;
   wire       LOCAL_XFR_DONE_ACK;
      
      
   rd_synchronizer do_fake_sync(.ASYNC_IN(DO_FAKE_XFR),
                                .CLK(LOCAL_CLK),
                                .SYNC_OUT(LOCAL_DO_FAKE_XFR));
   rd_synchronizer xfr_done_sync(.ASYNC_IN(LOCAL_XFR_DONE),
                                 .CLK(AXI_CLK),
                                 .SYNC_OUT(XFR_DONE));
   rd_synchronizer xfr_done_ack_sync(.ASYNC_IN(XFR_DONE_ACK),
                                 .CLK(SERIAL_CLK_IN),
                                 .SYNC_OUT(LOCAL_XFR_DONE_ACK));
   
   
// Get and store data from RD
   always @(posedge SERIAL_CLK_IN)
     begin
        PREV_ENABLE_XFR_IN <= ENABLE_XFR_IN;
        if (PREV_ENABLE_XFR_IN && !ENABLE_XFR_IN)
          LOCAL_XFR_DONE <= 1;
        else if (LOCAL_XFR_DONE_ACK)
          LOCAL_XFR_DONE <= 0;
        
// May have a problem here if the previous transfer has not been acknowledged.
        // Will think transfer is complete when it is not.
        // This should be fixed when integrated with WCD triggers
       if (ENABLE_XFR_IN) begin
           // Write data to memory every 13 bits
           if (SERIAL_IN_BIT_COUNT == 12) begin
              SERIAL_IN_BIT_COUNT <= 0;
              ENABLE_MEM_WRT <= 1;
              DATA_ADDR <= DATA_ADDR+4;
          end
           else
             SERIAL_IN_BIT_COUNT <= SERIAL_IN_BIT_COUNT+1;
           
           DATA_TO_MEM[SERIAL_IN_BIT_COUNT] <= SERIAL_DATA0_IN;
         end // if (ENABLE_XFR_IN)
        else begin
           SERIAL_IN_BIT_COUNT <= 0;
           DATA_ADDR <= 0;
        end
     end

   // Send fake RD data out

   always @(posedge LOCAL_CLK)
     begin
        PREV_DO_FAKE_XFR <= LOCAL_DO_FAKE_XFR;
        if (LOCAL_DO_FAKE_XFR && !PREV_DO_FAKE_XFR)
          begin
             SERIAL_OUT_BIT_COUNT <= 0;
             ENABLE_FAKE_XFR <= 1;
             FAKE_DATA_ADDR <= 0;
          end
        if (ENABLE_FAKE_XFR)
          begin
             if (SERIAL_OUT_BIT_COUNT == 12) 
               begin
                  SERIAL_OUT_BIT_COUNT <= 0;
                  if (FAKE_DATA_ADDR < 2047*4)
                    FAKE_DATA_ADDR <= FAKE_DATA_ADDR+4;
                  else
                    ENABLE_FAKE_XFR <= 0;
               end
             SERIAL_OUT_BIT_COUNT <= SERIAL_OUT_BIT_COUNT+1;
             SERIAL_FAKE_OUT <= FAKE_DATA[SERIAL_OUT_BIT_COUNT];
          end
     end

 endmodule  
   
