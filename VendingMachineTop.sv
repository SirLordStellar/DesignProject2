module VendingMachineTop (
	input logic clk,
	input logic nickel,
	input logic dime,
	input logic quarter,
	input logic dollar,
	input logic refund,
	input logic reset,
	output logic vend,
	output logic nickel_out,
	output logic dime_out,
	output logic quarter_out
);

	//Keeps track of whether we're in the process of refunding or vending
	logic refunding;
	logic vending;
	
	//Not the number of coins there are (never gonna be 127 coins get real)
	//Each place value is whether there is a coin there
	//Will function basically like a stack you'll see it'll be awesome
	logic [9:0] nickelhas;
	logic [4:0] dimehas;
	logic [2:0] quarterhas;
	logic dollarhas;
	
	//Sets refunding to true if refund is to activate refund module
	//If the coins are already empty though, it sets refunding to false
	always @(posedge clk) begin
		if (~nickelhas[0] && ~dimehas[0] && ~quarterhas[0]) begin
			refunding <= 0;
		end
		else if (refund && (nickelhas[0] || dimehas[0] || quarterhas[0]))
			refunding <= 1;
		else if (vend && (nickelhas[0] || dimehas[0] || quarterhas[0]))
			refunding <= 1;
		else
			refunding <= refunding;
	end
	
	

	//Instance of the coinchanger module
	Coinchangertwo changinthecoins (
		.clock(clk),
		.refunding(refunding),
		.vend(vend),
		.reset(reset),
		.nickel(nickel),
		.dime(dime),
		.quarter(quarter),
		.dollar(dollar),
		.nickels(nickelhas),
		.dimes(dimehas),
		.quarters(quarterhas),
		.dollars(dollarhas),
		.nickel_out(nickel_out),
		.dime_out(dime_out),
		.quarter_out(quarter_out)
	);
	
	//instance of the vending module
	vendingtwo thevending (
		.clock(clk),
		.refunding(refunding),
		.nickels(nickelhas),
		.dimes(dimehas),
		.quarters(quarterhas),
		.dollars(dollarhas),
		.vend(vend)
	);
	
	
	
	


endmodule