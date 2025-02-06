module outputLogic(
	// inputs
	input logic [9:0]BUS,
	input logic [9:0]REG, // output of the second read port on the register file
	input logic [1:0]TIME, // current timestep
	input logic PEEKb, DONE,

	// outputs
	output logic [9:0]LEDB,
	output logic [6:0]THEX, // current timestep hex
	output logic [6:0]DHEX0, // current 10b value on the data bus, decoded to 3 7-seg displays
	output logic [6:0]DHEX1,
	output logic [6:0]DHEX2,
	output logic LED_DONE
);
	logic [9:0]DHEXout;

	// display bus on LEDs
	assign LEDB = BUS;
	
	// timestep to seven segment
	seven_seg s1(.I({2'b00, TIME}), .Z(THEX));
	
	always_comb begin
		// if PEEKb is 1 DHEX shows databus
		if(PEEKb) DHEXout = BUS;
		// if PEEKb is 0 DHEX shows second read port on reg file
		else DHEXout = REG;
	end
	
	// display in seven seg
	seven_seg s5(.I(DHEXout[3:0]), .Z(DHEX0));
	seven_seg s6(.I(DHEXout[7:4]), .Z(DHEX1));
	seven_seg s7(.I({2'b00, DHEXout[9:8]}), .Z(DHEX2));
	
	// display when instruction has been compleded
	assign LED_DONE = ~DONE;

endmodule