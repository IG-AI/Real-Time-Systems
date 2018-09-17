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
		entry set(x: in Integer);
		entry quit;
	end buffer;

	task producer is
            -- add your task entries for communication 
		--entry ready;
		entry quit;
	end producer;

	task consumer is
            -- add your task entries for communication 
		--entry ready;
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
			put_line("index: " & Integer'image(index));
			if (exit_flag) then
				put_line("Ending buffer");
				
				exit;
			end if;
			--if (index < 2) then
			--	producer.ready;
			--end if;	
			--if (index /= 0) then
			--	consumer.ready;				
			--end if;	   		

			select
				when (index < 10) =>
					accept set(x: in Integer) do
						index := index + 1;
						b_array(index) := x;			
					end set;
			or
				when (index > 0) =>
					accept get(x: out Integer) do			
						x := b_array(index);
						index := index -1;
					end get;
			or
				accept quit do
					exit_flag := True;
					--accept set(x: in Integer) do
					--	NULL;			
					--end set;
				end quit;				
			end select;
		end loop;
	end buffer;


	task body producer is 
		Message: constant String := "producer executing";
                -- change/add your local declarations here
		subtype rand_range is Integer range 0 .. 25;
   		package rand_value is new Ada.Numerics.Discrete_Random (rand_range);
   		use rand_value;
		G: Generator;
		value: Integer;
		exit_flag: Boolean := False;
	begin
		Put_Line(Message);
		loop -- add your task code inside this loop  
			if (exit_flag) then
				put_line("Ending Producer");
				exit;
			end if;			

			select 
				accept quit do
					put_line("here");
					exit_flag := True;
				end quit;
			or
				delay 0.05;
			end select;
			value := Random(G);
			put_line("Value sent to buffer from P: " & Integer'Image(value));
			buffer.set(value);
			Reset(G);
		 
		end loop;
	end producer;


	task body consumer is 
		Message: constant String := "consumer executing";
                -- change/add your local declarations here
		value: Integer := 0;
		x: Integer;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop     -- add your task code inside this loop 
			--accept ready do 
			--	NULL;
			--end ready;

			buffer.get(x);
			--accept receive(x: in Integer) do
			put_line("Value recived from buffer to C: " & Integer'Image(x));			
			value := value + x;
			put_line("Count: " & Integer'Image(Value));
			--end receive;
			
			--delay 1.0;			

			if (value >= 100) then
				exit;
			end if;
		end loop Main_Cycle; 

                -- add your code to stop executions of other tasks
		put_line("Ending Consumer");
		producer.quit;  
		put_line("sent mess 1");  
		buffer.quit; 
		
		--producer.quit;  
		put_line("sent mess 2");
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
		Put_Line("Ending the consumer");
	end consumer;
begin
	Put_Line(Message);
end comm1;
