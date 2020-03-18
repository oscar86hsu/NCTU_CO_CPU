module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );
 
//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
  wire invertA;
  wire invertB;
  wire nullAdd;
  wire[1:0] operation;
  
  assign invertA = ALU_operation_i[3];
  assign invertB = ALU_operation_i[2];
  assign nullAdd = (ALU_operation_i==4'b1010)?1:0;
  assign operation = ALU_operation_i[1:0];

  wire[31:0] carryout_tmp;
  wire less_than;

ALU_1bit alu0(result[0],carryout_tmp[0],aluSrc1[0],aluSrc2[0],invertA,invertB,nullAdd,operation,invertB,less_than);
ALU_1bit alu1(result[1],carryout_tmp[1],aluSrc1[1],aluSrc2[1],invertA,invertB,nullAdd,operation,carryout_tmp[0],1'b0);
ALU_1bit alu2(result[2],carryout_tmp[2],aluSrc1[2],aluSrc2[2],invertA,invertB,nullAdd,operation,carryout_tmp[1],1'b0);
ALU_1bit alu3(result[3],carryout_tmp[3],aluSrc1[3],aluSrc2[3],invertA,invertB,nullAdd,operation,carryout_tmp[2],1'b0);
ALU_1bit alu4(result[4],carryout_tmp[4],aluSrc1[4],aluSrc2[4],invertA,invertB,nullAdd,operation,carryout_tmp[3],1'b0);
ALU_1bit alu5(result[5],carryout_tmp[5],aluSrc1[5],aluSrc2[5],invertA,invertB,nullAdd,operation,carryout_tmp[4],1'b0);
ALU_1bit alu6(result[6],carryout_tmp[6],aluSrc1[6],aluSrc2[6],invertA,invertB,nullAdd,operation,carryout_tmp[5],1'b0);
ALU_1bit alu7(result[7],carryout_tmp[7],aluSrc1[7],aluSrc2[7],invertA,invertB,nullAdd,operation,carryout_tmp[6],1'b0);
ALU_1bit alu8(result[8],carryout_tmp[8],aluSrc1[8],aluSrc2[8],invertA,invertB,nullAdd,operation,carryout_tmp[7],1'b0);
ALU_1bit alu9(result[9],carryout_tmp[9],aluSrc1[9],aluSrc2[9],invertA,invertB,nullAdd,operation,carryout_tmp[8],1'b0);
ALU_1bit alu10(result[10],carryout_tmp[10],aluSrc1[10],aluSrc2[10],invertA,invertB,nullAdd,operation,carryout_tmp[9],1'b0);
ALU_1bit alu11(result[11],carryout_tmp[11],aluSrc1[11],aluSrc2[11],invertA,invertB,nullAdd,operation,carryout_tmp[10],1'b0);
ALU_1bit alu12(result[12],carryout_tmp[12],aluSrc1[12],aluSrc2[12],invertA,invertB,nullAdd,operation,carryout_tmp[11],1'b0);
ALU_1bit alu13(result[13],carryout_tmp[13],aluSrc1[13],aluSrc2[13],invertA,invertB,nullAdd,operation,carryout_tmp[12],1'b0);
ALU_1bit alu14(result[14],carryout_tmp[14],aluSrc1[14],aluSrc2[14],invertA,invertB,nullAdd,operation,carryout_tmp[13],1'b0);
ALU_1bit alu15(result[15],carryout_tmp[15],aluSrc1[15],aluSrc2[15],invertA,invertB,nullAdd,operation,carryout_tmp[14],1'b0);
ALU_1bit alu16(result[16],carryout_tmp[16],aluSrc1[16],aluSrc2[16],invertA,invertB,nullAdd,operation,carryout_tmp[15],1'b0);
ALU_1bit alu17(result[17],carryout_tmp[17],aluSrc1[17],aluSrc2[17],invertA,invertB,nullAdd,operation,carryout_tmp[16],1'b0);
ALU_1bit alu18(result[18],carryout_tmp[18],aluSrc1[18],aluSrc2[18],invertA,invertB,nullAdd,operation,carryout_tmp[17],1'b0);
ALU_1bit alu19(result[19],carryout_tmp[19],aluSrc1[19],aluSrc2[19],invertA,invertB,nullAdd,operation,carryout_tmp[18],1'b0);
ALU_1bit alu20(result[20],carryout_tmp[20],aluSrc1[20],aluSrc2[20],invertA,invertB,nullAdd,operation,carryout_tmp[19],1'b0);
ALU_1bit alu21(result[21],carryout_tmp[21],aluSrc1[21],aluSrc2[21],invertA,invertB,nullAdd,operation,carryout_tmp[20],1'b0);
ALU_1bit alu22(result[22],carryout_tmp[22],aluSrc1[22],aluSrc2[22],invertA,invertB,nullAdd,operation,carryout_tmp[21],1'b0);
ALU_1bit alu23(result[23],carryout_tmp[23],aluSrc1[23],aluSrc2[23],invertA,invertB,nullAdd,operation,carryout_tmp[22],1'b0);
ALU_1bit alu24(result[24],carryout_tmp[24],aluSrc1[24],aluSrc2[24],invertA,invertB,nullAdd,operation,carryout_tmp[23],1'b0);
ALU_1bit alu25(result[25],carryout_tmp[25],aluSrc1[25],aluSrc2[25],invertA,invertB,nullAdd,operation,carryout_tmp[24],1'b0);
ALU_1bit alu26(result[26],carryout_tmp[26],aluSrc1[26],aluSrc2[26],invertA,invertB,nullAdd,operation,carryout_tmp[25],1'b0);
ALU_1bit alu27(result[27],carryout_tmp[27],aluSrc1[27],aluSrc2[27],invertA,invertB,nullAdd,operation,carryout_tmp[26],1'b0);
ALU_1bit alu28(result[28],carryout_tmp[28],aluSrc1[28],aluSrc2[28],invertA,invertB,nullAdd,operation,carryout_tmp[27],1'b0);
ALU_1bit alu29(result[29],carryout_tmp[29],aluSrc1[29],aluSrc2[29],invertA,invertB,nullAdd,operation,carryout_tmp[28],1'b0);
ALU_1bit alu30(result[30],carryout_tmp[30],aluSrc1[30],aluSrc2[30],invertA,invertB,nullAdd,operation,carryout_tmp[29],1'b0);
ALU_last alu31(result[31], overflow, less_than, aluSrc1[31], aluSrc2[31], invertA, invertB, nullAdd, operation, carryout_tmp[30], 1'b0);



  
	assign zero = ~(|result);

endmodule
