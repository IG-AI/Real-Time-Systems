--Protected types: Ada lab part 4

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Calendar;
use Ada.Text_IO;

procedure comm2 is
    Message: constant String := "Protected Object";
    	type BufferArray is array (1 .. 10) of Integer;
        -- protected object declaration
		b_array: BufferArray;
	protected  buffer is
            -- add entries of protected object here
		entry read(x: out Integer);
		entry write(x: in Integer);

	private
            -- add local declarations
		v: Integer := 0;
		index: Integer := 0; 
	
	end buffer;

	task producer is
		-- add task entries
		entry quit;
	end producer;

	task consumer is
                -- add task entries
	end consumer;

		
	protected body buffer is 
              -- add definitions of protected entries here
		-- Retrieves the first value in the buffer array and removes it from the buffer
		entry read(x: out Integer)
			when index > 0 is
		begin				
			x := b_array(1);
			For_Loop:
				for I in Integer range 1 .. 9 loop
					b_array(I) := b_array(I + 1);
				end loop For_Loop; 
			index := index - 1;
			put_line("Index read num: " & Integer'Image(index));
			--delay 1.0;
		end read;
		-- Set the the x value at the end of the buffer array
		entry write(x: in Integer)
			when index < 10 is
		begin			
			index := index + 1;
			put_line("Index write num: " & Integer'Image(index));
			b_array(index) := x;
			put_line("Array num: " & Integer'Image(b_array(index))); 
			--delay 1.0;
		end write;
	end buffer;


        task body producer is 
		Message: constant String := "producer executing";
                -- add local declrations of task here
		-- Setting up the random generator between 0 - 25
		subtype rand_range is Integer range 0 .. 25;
   		package rand_value is new Ada.Numerics.Discrete_Random (rand_range);
   		use rand_value;
		G: Generator;
		Ran: Integer;
		exit_flag: Boolean := False;  
	begin
		Put_Line(Message);
		loop
                -- add your task code inside this loop
			-- Exit the task when the exit_flag is True
			if (exit_flag) then
				exit;			
			end if;

			Select
				accept quit do
					exit_flag := True;
				end quit;
			or
				delay 0.05;
				Ran := Random(G); 			 
				buffer.write(Ran);
				put_line("Rand num: " & Integer'Image(Ran));
	   			Reset(G);
			end select;
		end loop;
	end producer;


	task body consumer is 
		Message: constant String := "consumer executing";
                -- add local declrations of task here 
		value: Integer := 0;
		total: Integer := 0; 
	begin
		Put_Line(Message);
		Main_Cycle:
		loop 
                -- add your task code inside this loop 
			delay 1.0;
			put_line("Before: " & Integer'Image(value));
			buffer.read(value); 
			total := total + value;
			put_line("After: " & Integer'Image(value)); 
			put_line("Total: " & Integer'Image(total)); 
	
			if (total >= 100) then
				exit;
			end if;
		end loop Main_Cycle; 

                -- add your code to stop executions of other tasks     
		Put_Line("Ending the consumer");
		producer.quit;
		
	end consumer;

begin
Put_Line(Message);
end comm2;
