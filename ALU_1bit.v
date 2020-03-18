module ALU_1bit( result, carryOut, a, b, invertA, invertB, nullAdd, operation, carryIn, less );
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire nullAdd;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
	wire tmp_a, tmp_b;
	xor gate1(tmp_a, a, invertA);
	xor gate2(tmp_b, b, invertB);

	wire and_result, or_result;
	and gate3(and_result, tmp_a, tmp_b);
	or gate4(or_result, tmp_a, tmp_b);

	wire adder_input2, add_result;
	and gate5(adder_input2, tmp_b, ~nullAdd);
	Full_adder gate6(add_result, carryOut, carryIn, tmp_a, adder_input2);

	assign result = (operation[1] & operation[0] & less) |
									(~operation[1] & ~operation[0] & and_result) |
									(~operation[1] & operation[0] & or_result) |
									(operation[1] & ~operation[0] & add_result);

  
endmodule
