module FPGA_Main_Backup(clk, mbed_pulse, mbed_data, sample, pulse_count, output_ready, pulse);
input clk, mbed_pulse;
output mbed_data;

// debug print
output sample;
output [3:0] pulse_count;
output output_ready;
output pulse;

// pulse date collection
reg [8:0] mbed_data;
reg sample;
reg [3:0] pulse_count;

// for sending data to servos
assign output_ready = !sample;

// servos
Servo_Driver(clk, output_ready, output_ready, mbed_data[7:0], pulse);

always @ (posedge clk)
begin
	// starts the sampling process if there a data pluse and it ist't started already
	if (!sample)
	begin
		sample <= mbed_pulse;
	end
	else
	begin
		// this ends the sampling process once all the bits have been collected
		if (pulse_count > 8)
		begin
			// resets sampling registers
			sample <= 0;
			pulse_count <= 0;
		end
		// collects data
		else 
		begin
			// shifts all the bits along the mbed data register and adds the newest bit at the end
			mbed_data <= {mbed_data[7:0],mbed_pulse};
			// increments the bit counter
			pulse_count <= pulse_count + 1;
		end
	end
end

endmodule
