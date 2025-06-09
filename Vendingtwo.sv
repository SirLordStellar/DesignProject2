module vendingtwo (
	input logic clock,
	input logic refunding,
	input logic [9:0] nickels,
	input logic [4:0] dimes,
	input logic [2:0] quarters,
	input logic dollars,
	output logic vend
	
);

	logic [31:0] amount;

	//These are all of our valid combinations of nickels and dimes
	//The stack functionality of nickels and dimes means that we don't have
	//to consider cases where higher place values are high while lower ones aren't
	//That'd be a bit much
	always_comb begin
		amount = 0;
		//It adds the total of all of the coins now
		//It might not exactly return the excess in the coins given
		if (nickels[9])
			amount += 5;
		if (nickels[8])
			amount += 5;
		if (nickels[7])
			amount += 5;
		if (nickels[6])
			amount += 5;
		if (nickels[5])
			amount += 5;
		if (nickels[4])
			amount += 5;
		if (nickels[3])
			amount += 5;
		if (nickels[2])
			amount += 5;
		if (nickels[1])
			amount += 5;
		if (nickels[0])
			amount += 5;
			
		if (dimes[4])
			amount += 10;
		if (dimes[3])
			amount += 10;
		if (dimes[2])
			amount += 10;
		if (dimes[1])
			amount += 10;
		if (dimes[0])
			amount += 10;
			
		if (quarters[2])
			amount += 25;
		if (quarters[1])
			amount += 25;
		if (quarters[0])
			amount += 25;
			
		if (dollars)
			amount += 100;
			
		if (amount >= 50)
			vend = 1;
		else
			vend = 0;
		
	end


endmodule