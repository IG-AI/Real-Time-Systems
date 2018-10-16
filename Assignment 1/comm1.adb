--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

use Ada.Calendar;
use Ada.Text_IO;


procedure comm1 is
    Message: constant String := "Process communication";
	task buffer is
		entry get(value: out Integer); -- Used to retrive an item from the buffer
		entry set(value: in Integer); -- Used to insert an item into the buffer
		entry quit; -- Used to end the buffer  
	end buffer;

	task producer is
		entry quit; -- Used to end the producer  
	end producer;

	task consumer is
            
	end consumer;


	task body buffer is 
		Message: constant String := "buffer executing";
		buffer_array: array(1 .. 10) of Integer;
		index: Integer := 0; 
		exit_flag: Boolean := False;
		    
	begin
		Put_Line(Message);
		loop
			-- Exit the task when the exit_flag is True			
			if (exit_flag) then
				exit;
			end if;	   		

			select
				-- Receives a random number and adds it at the end of the buffer 
				when (index < 10) =>
					accept set(value: in Integer) do
						index := index + 1;
						buffer_array(index) := value;		
					end set;
			or
				-- Retrieves the first value in the buffer 
				when (index > 0) =>
					accept get(value: out Integer) do			
						value := buffer_array(1);
						For_Loop:
							for i in Integer range 1 .. 9 loop
								buffer_array(i) := buffer_array(i + 1);

						end loop For_Loop;
						index := index - 1;
					end get;
			or
				-- Sets the exit flag to true so that the buffer will end the next iteration
				accept quit do
					exit_flag := True;
				end quit;				
			end select;
		end loop;
	end buffer;


	task body producer is 
		Message: constant String := "producer executing";

		-- Setting up the random generator between 0 - 25
		subtype rand_range is Integer range 0 .. 25;
   		package rand_value is new Ada.Numerics.Discrete_Random (rand_range);
   		use rand_value;
		G: Generator;

		value: Integer;
		exit_flag: Boolean := False;
		counter: Integer := 0;

	begin
		Put_Line(Message);
		loop 
			--Exit the task when the exit_flag is True  
			if (exit_flag) then
				exit;
			end if;			

			select 
				-- Sets the exit flag to true so that the producer will end the next iteration
				accept quit do
					exit_flag := True;
				end quit;
			or
				delay 0.05;
			end select;

			value := Random(G);
			put_line("Producer sent the following value to buffer: " & Integer'Image(value));
			buffer.set(value);
			Reset(G);

		 
		end loop;
	end producer;


	task body consumer is 
		Message: constant String := "consumer executing";
		
		-- Setting up a random Integer generator between 0 - 1
		subtype rand_range is Integer range 0 .. 1;
   		package rand_value is new Ada.Numerics.Discrete_Random (rand_range);
   		use rand_value;
		G: Generator;

		total: Integer := 0;
		value: Integer;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop   
			-- Retreive a number from the buffer and add it to the total
			buffer.get(value);
			put_line("Consumer recived the following value from buffer: " & Integer'Image(value));			
			total := total + value;
			
			if (total >= 100) then
				exit;
			end if;

			-- Delay either 0.0 or 0.5 seconds so that the producer have time to fill up the buffer 
			--delay Duration(float(Random(G)) - 0.5);
			--Reset(G); 
			delay 1.0;			

		end loop Main_Cycle; 

		Put_Line("Ending the consumer");

		-- End the other tasks
                producer.quit;  
		buffer.quit; 
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
	end consumer;
begin
	Put_Line(Message);
end comm1;
