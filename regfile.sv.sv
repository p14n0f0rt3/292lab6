/*
 *
 *
 *
 *
 *
 */

//Notes:
//Register reads are asynchrounous to clock
//Register writes are synchronous to the clock thingy

//I THINK I AM PANROMANTIC DEMISEXUAL AND NONBINARY


//define constants:
`define R0 8'b00000001
`define R1 8'b00000010
`define R2 8'b00000100
`define R3 8'b00001000
`define R4 8'b00010000
`define R5 8'b00100000
`define R6 8'b01000000
`define R7 8'b10000000

`define nothing 16'bxxxxxxxxxxxxxxxx

module regfile(data_in,writenum,write,readnum,clk,data_out);
    input wire [15:0] data_in;
    input wire [2:0] writenum, readnum;
    input wire write, clk;
    
    output wire [15:0] data_out;

    reg [7:0] read_reg, write_reg;
    reg [7:0] load;

    reg [15:0] comp_data_out;
    
    reg [15:0] out0, out1, out2, out3, out4, out5, out6, out7;
    reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7, rx;
    //determine register to read from
    decoder DEC_R(readnum, read_reg); 
    //determine register to write to 
    decoder DEC_W(writenum, write_reg);

    

    always_comb begin
        //AND write_reg and Write
        load[0] = write_reg[0] & write;
        load[1] = write_reg[1] & write;
        load[2] = write_reg[2] & write;
        load[3] = write_reg[3] & write;
        load[4] = write_reg[4] & write;
        load[5] = write_reg[5] & write;
        load[6] = write_reg[6] & write;
        load[7] = write_reg[7] & write;
    end

    mux_2_1 MR0(data_in, out0, load[0], out0);
    mux_2_1 MR1(data_in, out1, load[1], out1);
    mux_2_1 MR2(data_in, out2, load[2], out2);
    mux_2_1 MR3(data_in, out3, load[3], out3);
    mux_2_1 MR4(data_in, out4, load[4], out4);
    mux_2_1 MR5(data_in, out5, load[5], out5);
    mux_2_1 MR6(data_in, out6, load[6], out6);
    mux_2_1 MR7(data_in, out7, load[7], out7); //out[x] basically is the val stored in the register

    always_ff@(posedge clk) begin
        
        //basically the Q portion of the dff determined 
        //using a multiplexer to select if the output is the existing output or writing something new
        case(load)
            `R0: r0 = out0;
            `R1: r1 = out1;
            `R2: r2 = out2;
            `R3: r3 = out3;
            `R4: r4 = out4;
            `R5: r5 = out5;
            `R6: r6 = out6;
            `R7: r7 = out7;

            default: rx = `nothing;
        endcase
        
    end

    always_comb begin
        case(read_reg) //lowkey using a multiplexer without multiplexing lol teehee
            `R0: comp_data_out = r0;
            `R1: comp_data_out = r1;
            `R2: comp_data_out = r2;
            `R3: comp_data_out = r3;
            `R4: comp_data_out = r4;
            `R5: comp_data_out = r5;
            `R6: comp_data_out = r6;
            `R7: comp_data_out = r7;

            default: comp_data_out = `nothing; //defaulting cuz the default vibes 
        endcase
    end

    assign data_out = comp_data_out;


endmodule



module decoder(
    input [2:0] in,
    output reg [7:0] out
    );


    always_comb begin
        case(in)
            3'b000: out = `R0;
            3'b001: out = `R1;
            3'b010: out = `R2;
            3'b011: out = `R3;
            3'b100: out = `R4;
            3'b101: out = `R5;
            3'b110: out = `R6;
            3'b111: out = `R7;

            default: out = 8'bxxxxxxxx;
        endcase
    end

    

endmodule


module mux_2_1(
    input [15:0] a1, a0,
    input reg load,
    output reg [15:0] out
    );

    //a0 means load 0, nothing changes on output
    //a1 means output changes 
    always_comb begin
        case(load)
            1'b0: out = a0;
            1'b1: out = a1;

            default: out = `nothing;
        endcase
    end

endmodule