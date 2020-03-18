module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o, jr );

//I/O ports 
input	[6-1:0] funct_i;
input	[3-1:0] ALUOp_i;

output	[4-1:0] ALU_operation_o;  
output	[2-1:0] FURslt_o;
output	jr;
     
//Internal Signals
wire	[4-1:0] ALU_operation_o;
wire	[2-1:0] FURslt_o;
wire	jr;

//Main function


assign ALU_operation_o = ({ALUOp_i,funct_i}==9'b010_010010 || ALUOp_i == 3'b100) ? 4'b0010 : //add addi
						 ({ALUOp_i,funct_i}==9'b010_010000) ? 4'b0110 : //sub
						 ({ALUOp_i,funct_i}==9'b010_010100) ? 4'b0000 : //and
						 ({ALUOp_i,funct_i}==9'b010_010110) ? 4'b0001 : //or
						 ({ALUOp_i,funct_i}==9'b010_010101) ? 4'b1010 : //not
						 ({ALUOp_i,funct_i}==9'b010_100000) ? 4'b0111 : //slt
						 ({ALUOp_i,funct_i}==9'b010_000000) ? 4'b0001 : //sll
						 ({ALUOp_i,funct_i}==9'b010_000010) ? 4'b0000 : //srl
						 ({ALUOp_i,funct_i}==9'b010_000110) ? 4'b0011 :
						 (ALUOp_i == 3'b000)? 4'b0010 :
						 (ALUOp_i == 3'b001 || ALUOp_i == 3'b110)? 4'b0110 : 4'b0000;

						 

assign FURslt_o = (ALUOp_i == 3'b101) ? 2 :
				  (ALUOp_i == 3'b010 && (funct_i == 0 || funct_i == 2)) ? 1 : 0;


assign jr = (ALUOp_i==3'b010 && funct_i==6'b001000) ? 1 : 0;
						 
				

endmodule     
