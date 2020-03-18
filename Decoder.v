module Decoder(instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, jump, jal, branch, branchType,  MemWrite, MemRead, MemtoReg);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
output			jump;
output			jal;
output			branch;
output			branchType;
output			MemWrite;
output			MemRead;
output			MemtoReg;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;
wire			jump;
wire			jal;
wire			branch;
wire			branchType;
wire			MemWrite;
wire			MemRead;
wire			MemtoReg;

//Main function

assign RegDst_o = (instr_op_i==6'b111111) ? 1 : 0;
				  
assign RegWrite_o = (instr_op_i==6'b111011) ? 0 :
					(instr_op_i==6'b100101) ? 0 :
					(instr_op_i==6'b100011) ? 0 :
					(instr_op_i==6'b100010) ? 0 : 1;
				  		  
assign ALUOp_o = (instr_op_i==6'b111111) ? 3'b010 :
				  (instr_op_i==6'b110111) ? 3'b100 :
				  (instr_op_i==6'b100001 || instr_op_i==6'b100011) ? 3'b000 :
				  (instr_op_i==6'b111011) ? 3'b001 :
				  (instr_op_i==6'b100101) ? 3'b110 : 3'b000;			

assign ALUSrc_o = (instr_op_i==6'b111111) ? 0 :
				  (instr_op_i==6'b100101) ? 0 :
				  (instr_op_i==6'b111011) ? 0 : 1;

assign jump = (instr_op_i == 6'b100010 || instr_op_i == 6'b100111) ? 1 : 0;

assign jal = (instr_op_i==6'b100111) ? 1 : 0;

assign branch = (instr_op_i == 6'b111011 || instr_op_i == 6'b100101) ? 1 : 0;

assign branchType = instr_op_i == 6'b111011 ? 0 : 1;

assign MemWrite = instr_op_i == 6'b100011 ? 1 : 0;

assign MemRead = instr_op_i == 6'b100001 ? 1 : 0;

assign MemtoReg = instr_op_i == 6'b100001 ? 1 : 0;			  



endmodule
   