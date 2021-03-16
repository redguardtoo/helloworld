// download verilog-mode.el from http://www.veripool.org/projects/verilog-mode/wiki/Installing
/* time and integer are similar in functionality,
 time is an unsigned 64-bit used for time variables
 */
reg [8*14:1] string ;
/* This defines a vector with range
 [msb_expr: lsb_expr] */
initial begin
   a = 0.5 ; // same as 5.0e-1. real variable
   b = 1.2E12 ;
   c = 26.19_60_e-11 ; // _’s are
   // used for readability
   string = “ string example ” ;
   newtime =$time;
end

module dff (q,qb,clk,d,rst);
   input clk,d,rst ; // input signals
   output q,qb ; // output definition
   //inout for bidirectionals
   // Net type declarations
   wire   dl,dbl ;
   // parameter value assignment
   paramter delay1 = 3,
     delay2 = delay1 + 1; // delay2
   // shows parameter dependance
   /* Hierarchy primitive instantiation, port
    connection in this section is by
    ordered list */
   nand #delay1 n1(cf,dl,cbf),
     n2(cbf,clk,cf,rst);
   nand #delay2 n3(dl,d,dbl,rst),
     n4(dbl,dl,clk,cbf),
     n5(q,cbf,qb),
     n6(qb,dbl,q,rst);
   /***** for debuging model initial begin
    #500 force dff
    _lab.rst = 1 ;
    #550 release dff_lab.rst;
    // upward path referencing
end ********/
endmodule

module dff_lab;
   reg data,rst;
   // Connecting ports by name.(map)
   dff d1 (.qb(outb), .q(out),
           .clk(clk),.d(data),.rst(rst));
   // overriding module parameters
   defparam
     dff_lab.dff.n1.delay1 = 5 ,
     dff_lab.dff.n2.delay2 = 6 ;
   // full-path referencing is used
   // over-riding by using #(8,9) delay1=8..
   dff d2 #(8,9) (outc, outd, clk, outb, rst);
   // clock generator
   always clk = #10 ~clk ;
   // stimulus ... contd
   initial begin: stimuli // named block stimulus
      clk = 1; data = 1; rst = 0;
      #20 rst = 1;
      #20 data = 0;
      #600 $finish;
   end
   initial // hierarchy: downward path referencing
     begin
        #100 force dff.n2.rst = 0 ;
        #200 release dff.n2.rst;
     end
endmodule

// 3 to 1 mulitplexor with 2 select
primitive mux32 (Y, in1, in2, in3, s1, s2);
   input in1, in2, in3, s1, s2;
   output Y;
   table
      //in1 in2 in3 s1 s2 Y
      0  ?   ?   0   0 : 0 ;
      1  ?   ?   0   0 : 1 ;
      ?  0   ?   1   0 : 0 ;
      ?  1   ?   1   0 : 1 ;
      ?  ?   0   ?   1 : 0 ;
      ?  ?   1   ?   1 : 1 ;
      0  0   ?   ?   0 : 0 ;
      1  1   ?   ?   0 : 1 ;
      0  ?   0   0   ? : 0 ;
      1  ?   1   0   ? : 1 ;
      ?  0   0   1   ? : 0 ;
      ?  1   1   1   ? : 1 ;
   endtable
endprimitive

initial
  begin: block
     fork
        // This waits for the first event a
        // or b to occur
        @a disable block ;
        @b disable block ;
        // reset at absolute time 20
        #20 reset = 1 ;
        // data at absolute time 100
        #100 data = 0 ;
        // data at absolute time 120
        #120 data = 1 ;
     join
  end

  begin: block
     fork
        #20 reset = 1 ;
        // data at absolute time 100
        #100 data = 0 ;
        // data at absolute time 120
        #120 data = 1 ;
     join_any
  end

   always @(rst)// simple if -else
     if (rst)
       // procedural assignment
       q = 0;
     else
       // remove the above continous assign
       deassign q;
   always @(WRITE or READ or STATUS)
     begin
        // if - else - if
        if (!WRITE) begin
           out = oldvalue ;
        end
        else if (!STATUS)
          begin
             q = newstatus ;
             STATUS = hold ;
          end
        else if (!READ) begin
           out = newvalue ;
        end
     end

module d2X8 (select, out); // priority encode
   input [0:2] select;
   output [0:7] out;
   reg [0:7]    out;
   always @(select) begin
      out = 0;
      case (select)
        0: out[0] = 1;
        1: out[1] = 1;
        2: out[2] = 1;
        3: out[3] = 1;
        4: out[4] = 1;
        5: out[5] = 1;
        6: out[6] = 1;
        7: out[7] = 1;
      endcase
   end
endmodule

casex (state)
  // treats both x and z as don’t care
  // during comparison : 3’b01z, 3’b01x, 3b’011
  // ... match case 3’b01x
  3’b01x: fsm = 0 ;
  3’b0xx: fsm = 1 ;
  default: begin
     // default matches all other occurances
     fsm = 1 ;
     next_state = 3’b011 ;
  end
endcase

casez (state)
  // treats z as don’t care during comparison :
  // 3’b11z, 3’b1zz, ... match 3’b1??: fsm = 0 ;
  3’b1??: fsm = 0 ; // if MSB is 1, matches 3?b1??
  3’b01?: fsm = 1 ;
  default: $display(“wrong state”) ;
endcase

forever
  // should be used with disable or timing control
  @(posedge clock) {co, sum} = a + b + ci ;

for (i = 0 ; i < 7 ; i=i+1)
  memory[i] = 0 ; // initialize to 0

for (i = 0 ; i <= bit-width ; i=i+1)
  // multiplier using shift left and add
  if (a[i]) out = out + ( b << (i-1) ) ;

repeat(bit-width) begin
   if (a[0]) out = b + out ;
   b = b << 1 ; // muliplier using
   a = a << 1 ; // shift left and add
end

while(delay) begin @(posedge clk) ;
   ldlang = oldldlang ;
   delay = delay - 1 ;
end

initial forever @(posedge reset)
  disable MAIN ; // disable named block
   // tasks, modules can also be disabled
   always begin: MAIN // defining named blocks
      if (!qfull) begin
         #30 recv(new, newdata) ; // call task
         if (new) begin
            q[head] = newdata ;
            head = head + 1 ; // queue
         end
      end
      else
        disable recv ;
   end // MAIN

   always begin: MAIN //named definition
      if (!qfull)
        begin
           recv(new, newdata) ; // call task
           if (new) begin
              q[head] = newdata ;
              head = head + 1 ;
           end
        end else
          begin
             disable recv ;
          end
   end // MAIN

module foo2 (cs, in1, in2, ns);
   input [1:0] cs;
   input       in1, in2;
   output [1:0] ns;
   function [1:0] generate_next_state;
      input [1:0] current_state ;
      input       input1, input2 ;
      reg [1:0]   next_state ;
      // input1 causes 0->1 transition
      // input2 causes 1->2 transition
      // 2->0 illegal and unknown states go to 0
      begin
         case (current_state)
           2’h0 : next_state = input1 ? 2’h1 : 2’h0 ;
           2’h1 : next_state = input2 ? 2’h2 : 2’h1 ;
           2’h2 : next_state = 2’h0 ;
           default: next_state = 2’h0 ;
         endcase

         generate_next_state = next_state;
      end
   endfunction // generate_next_state
   assign ns = generate_next_state(cs, in1,in2) ;
endmodule

module fork_join_all_process();
   task automatic print_value;
      input [7:0] value;
      input [7:0] delay;
      begin
         #(delay) $display("@%g Passed Value %d Delay %d",
                           $time, value, delay);
      end
   endtask

   initial begin
      fork
         #1  print_value (10,7);
         #1  print_value (8,5);
         #1  print_value (4,2);
      join
      $display("@%g Came out of fork-join", $time);
      #20  $finish;
   end

endmodule

module adder (a, b, ci, co, sum,clk) ;
   input a, b, ci, clk ;
   output co, sum ;
   reg    co, sum;
   always @(posedge clk) // edge control
     // assign co, sum with previous value of a,b,ci
     {co,sum} = #10 a + b + ci ;
endmodule
/* assume a = 10, b= 20 c = 30 d = 40 at start of
 block */
always @(posedge clk)
  begin:block
     a <= #10 b ;
     b <= #10 c ;
     c <= #10 d ;
  end
   /* at end of block + 10 time units, a = 20, b = 30,
    c = 40 */

   specify // similar to defparam, used for timing
      specparam delay1 = 25.0, delay2 = 24.0;
      // edge sensitive delays -- some simulators
      // do not support this
      (posedge clock) => (out1 +: in1) =
                       (delay1, delay2) ;
      // conditional delays
      if (OPCODE == 3’h4) (in1, in2 *> out1)
        = (delay1, delay2) ;
      // +: implies edge-sensitive +ve polarity
      // -: implies edge sensitive -ve polarity
      // *> implies multiple paths
      // level sensitive delays
      if (clock) (in1, in2 *> out1, out2) = 30 ;
      // setuphold
      $setuphold(posedge clock &&& reset,
                 in1 &&& reset, 3:5:6, 2:3:6);
      (reset *> out1, out2) = (2:3:5,3:4:5);
   endspecify

   // @see https://github.com/redguardtoo/evil-matchit/issues/74
   if (sel == 1)
     begin
        output co, sum ;
     end
   else
     begin
        output co, sum ;
     end

   ifdef true
     begin
        output co, sum ;
     end
  else
    begin
       output co, sum ;
    end
   endif

`ifdef behavioral
 `include "groupA_beh.v ";
 `include "groupB_beh.v ";
 `include "ctrl_beh.v ";
`else
 `include "groupA_synth.v ";
 `include "groupB_ synth.v ";
 `include "ctrl_ synth.v ";
`endif

     `celldefine
       module my_and(y, a, b);
   output y;
   input  a, b;
   assign y = a & b;
endmodule
`endcelldefine