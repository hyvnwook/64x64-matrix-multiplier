module top_controller_wrapper(
	output reg done,
	input start, clk, rstn,

	input [7:0] mem_A_wire,
	input [31:0] mem_B_wire,
	output reg [21:0] mat_C,
	output reg [9:0] addr_A_RA,
	output reg [1:0] addr_A_CA,
	output reg [7:0] addr_B_RA,
	output reg [1:0] addr_B_CA,
	output reg [9:0] addr_C_RA,
	output reg [1:0] addr_C_CA,
	output reg WSa, ESa, WSb, ESb, WSc, ESc
);

    reg [7:0]  mem_A_reg;
    reg [31:0] mem_B_reg;

    always @(posedge clk) begin
        if (!rstn) begin
            mem_A_reg <= 8'b0;
            mem_B_reg <= 32'b0;
        end else begin
            mem_A_reg <= mem_A_wire;
            mem_B_reg <= mem_B_wire;
        end
    end

    wire        done_wire;
    wire [21:0] mat_C_wire;

    wire [9:0] addr_A_RA_wire;
    wire [1:0] addr_A_CA_wire;
    wire [7:0] addr_B_RA_wire;
    wire [1:0] addr_B_CA_wire;
    wire [9:0] addr_C_RA_wire;
    wire [1:0] addr_C_CA_wire;

    wire WSa_wire;
    wire ESa_wire;
    wire WSb_wire;
    wire ESb_wire;
    wire WSc_wire;
    wire ESc_wire;

    top_controller U_CONTROLLER(
        .done(done_wire),
        .start(start),
        .clk(clk),
        .rstn(rstn),

        .mem_A_wire(mem_A_reg),
        .mem_B_wire(mem_B_reg),
        .mat_C(mat_C_wire),

        .addr_A_RA(addr_A_RA_wire),
        .addr_A_CA(addr_A_CA_wire),
        .addr_B_RA(addr_B_RA_wire),
        .addr_B_CA(addr_B_CA_wire),
        .addr_C_RA(addr_C_RA_wire),
        .addr_C_CA(addr_C_CA_wire),

        .WSa(WSa_wire),
        .ESa(ESa_wire),
        .WSb(WSb_wire),
        .ESb(ESb_wire),
        .WSc(WSc_wire),
        .ESc(ESc_wire)
    );

    always @(posedge clk) begin
        if (!rstn) begin
            done <= 1'b0;
            mat_C <= 22'b0;

            addr_A_RA <= 10'b0;
            addr_A_CA <= 2'b0;
            addr_B_RA <= 8'b0;
            addr_B_CA <= 2'b0;
            addr_C_RA <= 10'b0;
            addr_C_CA <= 2'b0;

            WSa <= 1'b0;
            ESa <= 1'b1;
            WSb <= 1'b0;
            ESb <= 1'b1;
            WSc <= 1'b1;
            ESc <= 1'b1;
        end else begin
            done <= done_wire;
            mat_C <= mat_C_wire;

            addr_A_RA <= addr_A_RA_wire;
            addr_A_CA <= addr_A_CA_wire;
            addr_B_RA <= addr_B_RA_wire;
            addr_B_CA <= addr_B_CA_wire;
            addr_C_RA <= addr_C_RA_wire;
            addr_C_CA <= addr_C_CA_wire;

            WSa <= WSa_wire;
            ESa <= ESa_wire;
            WSb <= WSb_wire;
            ESb <= ESb_wire;
            WSc <= WSc_wire;
            ESc <= ESc_wire;
        end
    end

endmodule