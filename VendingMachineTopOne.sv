/*
	Project Title: $0.50 Vending Machine
	Author: Sophia Pole

*/


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
	
	//Not the number of coins there are (never gonna be 1023 coins get real)
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




module Coinchangertwo (
	input logic clock,
	input logic nickel,
	input logic dime,
	input logic quarter,
	input logic dollar,
	input logic vend,
	input logic refunding,
	input logic reset,
	output logic [9:0] nickels,
	output logic [4:0] dimes,
	output logic [2:0] quarters,
	output logic dollars,
	output logic nickel_out,
	output logic dime_out,
	output logic quarter_out
);

	logic [6:0] namount;
	logic [6:0] damount;
	logic [6:0] qamount;
	
	//Using these numbers will make the logic a lot easier for vend
	always_comb begin
		if (nickels[9])
			namount = 50;
		else if (nickels[8])
			namount = 45;
		else if (nickels[7])
			namount = 40;
		else if (nickels[6])
			namount = 35;
		else if (nickels[5])
			namount = 30;
		else if (nickels[4])
			namount = 25;
		else if (nickels[3])
			namount = 20;
		else if (nickels[2])
			namount = 15;
		else if (nickels[1])
			namount = 10;
		else if (nickels[0])
			namount = 5;
		else
			namount = 0;
			
		if (dimes[4])
			damount = 50;
		else if (dimes[3])
			damount = 40;
		else if (dimes[2])
			damount = 30;
		else if (dimes[1])
			damount = 20;
		else if (dimes[0])
			damount = 10;
		else
			damount = 0;
			
		if (quarters[2])
			qamount = 75;
		else if (quarters[1])
			qamount = 50;
		else if (quarters[0])
			qamount = 25;
		else
			qamount = 0;
		
		
	end


	//This is where all the logic of changing the coin counts happens
	always @(posedge reset or posedge clock) begin
		//Reset has the highest priority
		if (reset) begin
			nickels <= 10'b0000000000;
			dimes <= 5'b00000;
			quarters <= 3'b000;
			dollars <= 0;
			nickel_out <= 0;
			dime_out <= 0;
			quarter_out <= 0;
		end
		//Next priority is processing money inputs
		else if (nickel || dime || quarter || dollar) begin
			nickel_out <= 0;
			dime_out <= 0;
			quarter_out <= 0;
			if (nickel) begin	
				if (nickels[8]) begin
					nickels[9] <= 1;
				end
				else if (nickels[7]) begin
					nickels[8] <= 1;
				end
				else if (nickels[6]) begin
					nickels[7] <= 1;
				end
				else if (nickels[5]) begin
					nickels[6] <= 1;
				end
				else if (nickels[4]) begin
					nickels[5] <= 1;
				end
				else if (nickels[3]) begin
					nickels[4] <= 1;
				end
				else if (nickels[2]) begin
					nickels[3] <= 1;
				end
				else if (nickels[1]) begin
					nickels[2] <= 1;
				end
				else if (nickels[0]) begin
					nickels[1] <= 1;
				end
				else
					nickels[0] <= 1;
			end
			if (dime) begin
				if (dimes[3]) begin
					dimes[4] <= 1;
				end
				else if (dimes[2]) begin
					dimes[3] <= 1;
				end
				else if (dimes[1]) begin
					dimes[2] <= 1;
				end
				else if (dimes[0]) begin
					dimes[1] <= 1;
				end
				else
					dimes[0] <= 1;
			end
			if (quarter) begin
				if (quarters[0]) begin
					quarters[1] <= 1;
				end
				else
					quarters[0] <= 1;
			end
			if (dollar) begin
				dollars <= 1;
			end
		end
		//Next, if we aren't resetting or inserting coins we'll check
		//if we're refunding
		//Dollars will never be refunded because they are instantly processed into vend
		//It goes down the if else if ladder to empty all of the coin stacks one coin at a time
		else if (refunding && ~vend) begin	
			if (nickels[9]) begin
				nickels[9] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[8]) begin
				nickels[8] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[7]) begin
				nickels[7] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[6]) begin
				nickels[6] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[5]) begin
				nickels[5] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[4]) begin
				nickels[4] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[3]) begin
				nickels[3] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[2]) begin
				nickels[2] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[1]) begin
				nickels[1] <= 0;
				nickel_out <= 1;
			end
			else if (nickels[0]) begin
				nickels[0] <= 0;
				nickel_out <= 1;
			end
			else
				nickel_out <= 0;
				
			if (dimes[4]) begin
				dimes[4] <= 0;
				dime_out <= 1;
			end
			else if (dimes[3]) begin
				dimes[3] <= 0;
				dime_out <= 1;
			end
			else if (dimes[2]) begin
				dimes[2] <= 0;
				dime_out <= 1;
			end
			else if (dimes[1]) begin
				dimes[1] <= 0;
				dime_out <= 1;
			end
			else if (dimes[0]) begin
				dimes[0] <= 0;
				dime_out <= 1;
			end
			else
				dime_out <= 0;
			
			if (quarters[2]) begin
				quarters[2] <= 0;
				quarter_out <= 1;
			end
			else if (quarters[1]) begin
				quarters[1] <= 0;
				quarter_out <= 1;
			end
			else if (quarters[0]) begin
				quarters[0] <= 0;
				quarter_out <= 1;
			end
			else
				quarter_out <= 0;
		end
		//Finally, we'll check if we have the correct amount of money to vend a product
		//This handles subtracting the $0.50 cents, then it's back to the refund block to
		//handle the excess
		else if (vend) begin
			nickel_out <= 0;
			dime_out <= 0;
			quarter_out <= 0;
			
			//If there is a dollar
			if (dollars) begin
				dollars <= 0;
				if (quarters[0])
					quarters <= 7;
				else
					quarters <= 3;
			end
			
			//If there is enough of one kind of coin to cover vend
			else if (qamount >= 50) begin
				if (quarters[2])
					quarters[2:1] <= 0;
				else
					quarters <= 0;
			end
			else if (damount == 50)
				dimes <= 0;
			else if (namount == 50)
				nickels <= 0;
			
			
			//If there is only one quarter
			else if (qamount > 0) begin
				//If we can vend from just quarters and nickels
				if (qamount + namount >= 50) begin
					quarters <= 0;
					//Get rid of 25 cents in nickels
					if (nickels[9])
						nickels[9:5] <= 0;
					else if (nickels[8])
						nickels[8:4] <= 0;
					else if (nickels[7])
						nickels[7:3] <= 0;
					else if (nickels[6])
						nickels[6:2] <= 0;
					else if (nickels[5])
						nickels[5:1] <= 0;
					else
						nickels[4:0] <= 0;
				end
				
				//If we can vend from just quarters and dimes
				else if (qamount + damount >= 50) begin
					quarters <= 0;
					
					//Need to add a nickel because quarters and dimes makes 55 cents
					if (nickels[8]) begin
						nickels[9] <= 1;
					end
					else if (nickels[7]) begin
						nickels[8] <= 1;
					end
					else if (nickels[6]) begin
						nickels[7] <= 1;
					end
					else if (nickels[5]) begin
						nickels[6] <= 1;
					end
					else if (nickels[4]) begin
						nickels[5] <= 1;
					end
					else if (nickels[3]) begin
						nickels[4] <= 1;
					end
					else if (nickels[2]) begin
						nickels[3] <= 1;
					end
					else if (nickels[1]) begin
						nickels[2] <= 1;
					end
					else if (nickels[0]) begin
						nickels[1] <= 1;
					end
					else
						nickels[0] <= 1;
					
					if (dimes[4])
						dimes[4:2] <= 0;
					else if (dimes[3])
						dimes[3:1] <= 0;
					else
						dimes[2:0] <= 0;
				end
				//If we can vend from quarters, dimes, and nickels
				else if (qamount + namount + damount >= 50) begin
					quarters <= 0;
					//If there are two dimes (and either one or two nickels)
					if (damount == 20) begin
						dimes <= 0;
						if (nickels[1])
							nickels[1] <= 0;
						else 
							nickels[0] <= 0;
					end
					//If there is one dime
					else begin
						dimes <= 0;
						if (nickels[3])
							nickels[3:1] <= 0;
						else
							nickels <= 0;
					end
				end
			end
			
			//If we can vend from just nickels and dimes
			else if (namount + damount >= 50) begin
				if (damount == 40) begin
					//If we had three nickels
					if (nickels[2]) 
						nickels[2:1] <= 0;
					else
						nickels <= 0;
				end
				else if (damount == 30) begin
					if (nickels[4])
						nickels[4:1] <= 0;
					else
						nickels <= 0;
				end
				else if (damount == 20) begin
					if (nickels[6])
						nickels[6:1] <= 0;
					else
						nickels <= 0;
				end
				else begin
					if (nickels[8])
						nickels[8:1] <= 0;
					else
						nickels <= 0;
				end
			end
			
		end
		//One last bit of cleanup for while none of the above are true
		else begin
			nickel_out <= 0;
			dime_out <= 0;
			quarter_out <= 0;
		end
	end


endmodule




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
