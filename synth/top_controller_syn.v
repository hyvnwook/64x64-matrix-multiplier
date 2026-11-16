module top_controller(
	output reg done,
	input start, clk, rstn,

	input [7:0] mem_A_wire,
	input [31:0] mem_B_wire,
	output reg [21:0] mat_C,
	output [9:0] addr_A_RA,
	output [1:0] addr_A_CA,
	output [7:0] addr_B_RA,
	output [1:0] addr_B_CA,
	output [9:0] addr_C_RA,
	output [1:0] addr_C_CA,
	output reg WSa, ESa, WSb, ESb, WSc, ESc
);

	wire [7:0] A_in;
	wire [31:0] B_in;
	wire [21:0] C_out;

	wire [7:0] mat_A;
	wire [31:0] mat_B;

	reg [15:0] count;
	reg [1:0] count_wr;
	wire [15:0] count_1;
	wire [9:0] c_RA;

	reg [21:0] acc1, acc2, acc3, acc4;

	reg write_started;

	assign count_1 = count - 16'b1;
	assign c_RA = count[15:6] - 1'b1;

	assign mat_A = mem_A_wire;
	assign mat_B = mem_B_wire;
	
	always @(posedge clk) begin
		if (!rstn) begin
			count <= 16'b0;
			count_wr <= 2'b0;
			acc1 <= 22'b0; acc2 <= 22'b0; acc3 <= 22'b0; acc4 <= 22'b0;
			done <= 1'b0;
			WSa <= 1'b0; ESa <= 1'b1; WSb <= 1'b0; ESb <= 1'b1; WSc <= 1'b1; ESc <= 1'b1;
			write_started <= 1'b0;
		end else begin
			if (start) begin
				count <= 16'b0;
				count_wr <= 2'b0;
				acc1 <= 22'b0; acc2 <= 22'b0; acc3 <= 22'b0; acc4 <= 22'b0;
				done <= 1'b0;
				WSa <= 1'b1; ESa <= 1'b0; WSb <= 1'b1; ESb <= 1'b0; WSc <= 1'b1; ESc <= 1'b1;		
				write_started <= 1'b0;
			end else begin
				if (done == 1'b0) begin // if it is not done
					WSa <= WSa; ESa <= ESa; WSb <= WSb; ESb <= ESb;
					if (count_1 == 16'b0) begin // done configuration
						if (write_started) begin 
							done <= 1'b1;
						end else begin 
							done <= 1'b0;
						end
					end 
					if (ESc) begin // read mode
						if (((count[15:6] >= 10'b1) && (count_1[5:0] == 6'b111111)) || (count == 16'b0) && (write_started == 1'b1)) begin // start write mode 
							WSc <= 1'b0;
							ESc <= 1'b0;
							count_wr <= 2'b0;
							write_started <= 1'b1;
						end else begin 
							count <= count + 1'b1;
						end
						if (mat_A >= 8'b0) begin 
							acc1 <= acc1 + mat_A * mat_B[31:24];
							acc2 <= acc2 + mat_A * mat_B[23:16];
							acc3 <= acc3 + mat_A * mat_B[15:8];
							acc4 <= acc4 + mat_A * mat_B[7:0];
						end
					end else begin // write mode (stop count, start count_wr)
						case (count_wr)
							2'b00: mat_C <= acc1;
							2'b01: mat_C <= acc2;
							2'b10: mat_C <= acc3;
							2'b11: mat_C <= acc4;
						endcase
						if ((count_wr == 2'b11) && (mat_C == acc4)) begin // write mode ends
							WSc <= 1'b1;
							ESc <= 1'b1;
							count_wr <= 2'b0;
							acc1 <= 22'b0;
							acc2 <= 22'b0;
							acc3 <= 22'b0;
							acc4 <= 22'b0;
							count <= count + 16'b1;
						end else begin
							WSc <= WSc;
							ESc <= ESc;
							if (mat_C == acc1) count_wr <= 2'b01;
							if (mat_C == acc2) count_wr <= 2'b10;
							if (mat_C == acc3) count_wr <= 2'b11;
							if (mat_C == acc4) count_wr <= count_wr;
						end
					end
				end else begin // if it is done
					count <= 16'b0; done <= done;
					acc1 <= 22'b0; acc2 <= 22'b0; acc3 <= 22'b0; acc4 <= 22'b0;
					mat_C <= 22'b0;
					ESa <= 1'b1; ESb <= 1'b1; ESc <= 1'b1;
				end
			end
		end
	end

	assign addr_A_RA = {count[15:10], count[5:2]};
	assign addr_A_CA = count[1:0];
	assign addr_B_RA = {count[5:0], count[9:8]};
	assign addr_B_CA = count[7:6];
	assign addr_C_RA = c_RA;
	assign addr_C_CA = count_wr;

endmodule