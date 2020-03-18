module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles

wire [32-1:0] instruction, write_back_ans, ALUSrc1, ALUSrc2, ALU_result, Shifter_result, zeroFilled, signExtend, readData2, writeData;

wire [32-1:0] pc_in, pc_out, memData, addr_i, jumpShiftLeft, branchShiftLeft, branchAdd, branchAns, Adder_result, Jump_result, jalorwb;

wire [5-1:0] writeReg_addr, JalToReg;
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOp;
wire [2-1:0] FURslt;

wire RegDst, RegWrite, ALUSrc, zero, overflow, jump, branch, branchType, memWrite, memRead, Memtoreg, beq_or_bne, branchTF, jal, jr;

wire [31:0] IF_ID_result_adder, instruction_ex, read_data1, ID_EX_result_adder, ID_EX_read_data2, ID_EX_data_Sign_Extend, ID_EX_data_Zero_Filled, EX_MEM_ans_branch_add, EX_MEM_addr_i, EX_MEM_read_data2, MEM_WB_ans_data_mem, MEM_WB_addr_i;

wire [20:0] ID_EX_instruction;
wire [5:0] EX, ID_EX_EX;
wire [4:0] EX_MEM_Writereg, MEM_WB_Writereg;
wire [2:0] M, ID_EX_M, EX_MEM_M;
wire [1:0] WB, ID_EX_WB, EX_MEM_WB, MEM_WB_WB;
wire EX_MEM_beq_or_bne;


//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );

Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),
	    .sum_o(Adder_result)    
	    );

pipeline_reg #(.size(32)) IF_ID_1(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(Adder_result),
			.data_o(IF_ID_result_adder)
			);

Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instruction_ex)    
	    );

pipeline_reg #(.size(32)) IF_ID_2(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(instruction_ex),
			.data_o(instruction)
			);

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(ID_EX_instruction[20:16]),
        .data1_i(ID_EX_instruction[15:11]),
        .select_i(ID_EX_EX[5]),
        .data_o(writeReg_addr)
        );	

Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instruction[25:21]) ,  
        .RTaddr_i(instruction[20:16]) ,  
        .Wrtaddr_i(MEM_WB_Writereg) ,
        .Wrtdata_i(write_back_ans)  ,
        .RegWrite_i(MEM_WB_WB[1]), 
        .RSdata_o(read_data1) ,
        .RTdata_o(readData2)   
        );

Decoder Decoder(
        .instr_op_i(instruction[31:26]),
		.jump(jump),
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),
		.branch(branch),
		.branchType(branchType),
		.MemWrite(memWrite),
		.MemRead(memRead),
		.MemtoReg(Memtoreg),
	    .RegDst_o(RegDst),
        .jal(jal)		
		);

assign WB={RegWrite,Memtoreg};
assign M={branch,memRead,memWrite};
assign EX={RegDst,branchType,ALUOp,ALUSrc};

pipeline_reg #(.size(2)) ID_EX_1(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(WB),
			.data_o(ID_EX_WB)
			);
			
pipeline_reg #(.size(3)) ID_EX_2(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(M),
			.data_o(ID_EX_M)
			);
			
pipeline_reg #(.size(6)) ID_EX_3(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX),
			.data_o(ID_EX_EX)
			);

pipeline_reg #(.size(32)) ID_EX_4(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(IF_ID_result_adder),
			.data_o(ID_EX_result_adder)
			);
pipeline_reg #(.size(32)) ID_EX_5(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(read_data1),
			.data_o(ALUSrc1)
			);
pipeline_reg #(.size(32)) ID_EX_6(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(readData2),
			.data_o(ID_EX_read_data2)
			);
pipeline_reg #(.size(32)) ID_EX_7(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(signExtend),
			.data_o(ID_EX_data_Sign_Extend)
			);
pipeline_reg #(.size(32)) ID_EX_8(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(zeroFilled),
			.data_o(ID_EX_data_Zero_Filled)
			);
pipeline_reg #(.size(21)) ID_EX_9(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(instruction[20:0]),
			.data_o(ID_EX_instruction)
			);

ALU_Ctrl AC(
        .funct_i(ID_EX_instruction[5:0]),   
        .ALUOp_i(ID_EX_EX[3:1]),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt),
		.jr(jr)
        );

Sign_Extend SE(
        .data_i(instruction[15:0]),
        .data_o(signExtend)
        );

Zero_Filled ZF(
        .data_i(instruction[15:0]),
        .data_o(zeroFilled)
        );

Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(ID_EX_read_data2),
        .data1_i(ID_EX_data_Sign_Extend),
        .select_i(ID_EX_EX[0]),
        .data_o(ALUSrc2)
        );	

Mux2to1 #(.size(1)) for_bne(
        .data0_i(zero),
        .data1_i(~zero),
        .select_i(ID_EX_EX[4]),
        .data_o(beq_or_bne)
        );	

assign branchTF = EX_MEM_M[2] && EX_MEM_beq_or_bne;


ALU ALU(
		.aluSrc1(ALUSrc1),
	    .aluSrc2(ALUSrc2),
	    .ALU_operation_i(ALU_operation),
		.result(ALU_result),
		.zero(zero),
		.overflow(overflow)
	    );

Shifter shifter( 
		.result(Shifter_result), 
		.leftRight(~ID_EX_instruction[1]),
		.shamt(ID_EX_instruction[10:6]),
		.sftSrc(ALUSrc2) 
		);

Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result),
        .data1_i(Shifter_result),
		.data2_i(ID_EX_data_Zero_Filled),
        .select_i(FURslt),
        .data_o(addr_i)
        );

pipeline_reg #(.size(2)) EX_MEM_1(                   
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ID_EX_WB),
			.data_o(EX_MEM_WB)
			);

pipeline_reg #(.size(3)) EX_MEM_2(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ID_EX_M),
			.data_o(EX_MEM_M)
			);

pipeline_reg #(.size(32)) EX_MEM_3(                  
			.clk(clk_i),
			.rst(rst_n),
			.data_i(branchAdd),
			.data_o(EX_MEM_ans_branch_add)
			);

pipeline_reg #(.size(1)) EX_MEM_4(             
			.clk(clk_i),
			.rst(rst_n),
			.data_i(beq_or_bne),
			.data_o(EX_MEM_beq_or_bne)
			);

pipeline_reg #(.size(32)) EX_MEM_5(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(addr_i),
			.data_o(EX_MEM_addr_i)
			);

pipeline_reg #(.size(32)) EX_MEM_6(
			.clk(clk_i),
			.rst(rst_n),
			.data_i(ID_EX_read_data2),
			.data_o(EX_MEM_read_data2)
			);

pipeline_reg #(.size(5)) EX_MEM_7(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(writeReg_addr),
			.data_o(EX_MEM_Writereg)
			);

Data_Memory DM(	
		.clk_i(clk_i),
		.addr_i(EX_MEM_addr_i), 
		.data_i(EX_MEM_read_data2), 
		.MemRead_i(EX_MEM_M[1]), 
		.MemWrite_i(EX_MEM_M[0]), 
		.data_o(memData)
		);

pipeline_reg #(.size(2)) MEM_WB_1(                   
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX_MEM_WB),
			.data_o(MEM_WB_WB)
			);

pipeline_reg #(.size(32)) MEM_WB_2(                 
			.clk(clk_i),
			.rst(rst_n),
			.data_i(memData),
			.data_o(MEM_WB_ans_data_mem)
			);

pipeline_reg #(.size(32)) MEM_WB_3(                  
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX_MEM_addr_i),
			.data_o(MEM_WB_addr_i)
			);

pipeline_reg #(.size(5)) MEM_WB_4(             
			.clk(clk_i),
			.rst(rst_n),
			.data_i(EX_MEM_Writereg),
			.data_o(MEM_WB_Writereg)
			);

Mux2to1 #(.size(32)) after_data_mem(
        .data0_i(MEM_WB_addr_i),
        .data1_i(MEM_WB_ans_data_mem),
        .select_i(MEM_WB_WB[0]),
        .data_o(write_back_ans)
        );	

assign jumpShiftLeft = {{Adder_result[31:28]},{ID_EX_instruction[25:0]},{2'b00}};

Shifter branch_Shifter( 
		.result(branchShiftLeft), 
		.leftRight(1'b1),
		.shamt(5'd2),
		.sftSrc(ID_EX_data_Sign_Extend) 
		);

Adder Adder2(
        .src1_i(ID_EX_result_adder),     
	    .src2_i(branchShiftLeft),
	    .sum_o(branchAdd)
	    );

Mux2to1 #(.size(32)) ex_pc(
        .data0_i(Adder_result),
        .data1_i(EX_MEM_ans_branch_add),
        .select_i(branchTF),
        .data_o(pc_in)
        );


endmodule



