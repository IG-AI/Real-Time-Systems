--Process commnication: Ada lab part 3

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

use Ada.Calendar;
use Ada.Text_IO;


procedure comm1 is
    Message: constant String := "Process communication";
	task buffer is
            -- add your task entries for communication 
		entry get(x: out Integer);
		entry set(x: in Integer; y: out Integer);
		entry quit;
	end buffer;

	task producer is
            -- add your task entries for communication 
		entry update(x: in Integer);
		entry quit;
	end producer;

	task consumer is
            -- add your task entries for communication 
	end consumer;


	task body buffer is 
		Message: constant String := "buffer executing";
                -- change/add your local declarations here 
		b_array: array(1 .. 10) of Integer;
		index: Integer := 0; 
		exit_flag: Boolean := False;
		    
	begin
		Put_Line(Message);
		loop  -- add your task code inside this loop
			-- Exit the task when the exit_flag is True			
			if (exit_flag) then
				exit;
			end if;	   		

			select
				-- Set the the x value at the end of the buffer array 
				when (index < 10) =>
					accept set(x: in Integer; y: out Integer) do
						index := index + 1;
						b_array(index) := x;
						y := index;		
					end set;
			or
				-- Retrieves the first value in the buffer array and removes it from the buffer
				when (index > 0) =>
					accept get(x: out Integer) do			
						x := b_array(1);
						For_Loop:
							for I in Integer range 1 .. 9 loop
								b_array(I) := b_array(I + 1);

						end loop For_Loop;
						index := index - 1;
						producer.update(index);
					end get;
			or
				accept quit do
					exit_flag := True;
				end quit;				
			end select;
		end loop;
	end buffer;


	task body producer is 
		Message: constant String := "producer executing";
                -- change/add your local declarations here
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
		loop -- add your task code inside this loop
			--Exit the task when the exit_flag is True  
			if (exit_flag) then
				exit;
			end if;			

			select 
				accept quit do
					exit_flag := True;
				end quit;
			or
				-- Update the counter that counts the number of taken slots in the buffer
				accept update(x: in Integer) do
					counter := x;
				end update;
			or
				delay 0.05;
			end select;
			if (counter < 10) then
				value := Random(G);
				put_line("Value sent to buffer from P: " & Integer'Image(value));
				buffer.set(value, counter);
				Reset(G);
			end if;
		 
		end loop;
	end producer;


	task body consumer is 
		Message: constant String := "consumer executing";
                -- change/add your local declarations here
		-- Setting up the random generator between 0 - 1
		subtype rand_range is Integer range 0 .. 1;
   		package rand_value is new Ada.Numerics.Discrete_Random (rand_range);
   		use rand_value;
		G: Generator;
		value: Integer := 0;
		x: Integer;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop     -- add your task code inside this loop 
			buffer.get(x);
			put_line("Value recived from buffer to C: " & Integer'Image(x));			
			value := value + x;
			
			delay Duration(Random(G));
			Reset(G); 			

			if (value >= 100) then
				exit;
			end if;
		end loop Main_Cycle; 

                -- add your code to stop executions of other tasks
		producer.quit;  
		buffer.quit; 
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
		Put_Line("Ending the consumer");
	end consumer;
begin
	Put_Line(Message);
end comm1;
