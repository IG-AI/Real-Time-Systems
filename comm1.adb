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
		entry get;
		entry set(x: in Integer);
		entry quit;
	end buffer;

	task producer is
            -- add your task entries for communication 
		entry ready;
		entry quit;
	end producer;

	task consumer is
            -- add your task entries for communication 
		entry ready;
		entry receive(x: in Integer);
	end consumer;


	task body buffer is 
		Message: constant String := "buffer executing";
                -- change/add your local declarations here 
		b_array: array(1 .. 10) of Integer;
		index: Integer := 0;  
		    
	begin
		Put_Line(Message);
		loop  -- add your task code inside this loop
			put_line("Begin loop"); 
			if (index /= 10) then
				put_line("sending prooducer.ready");
				producer.ready;
				put_line("sent prooducer.ready");
			end if;	
			if (index /= 0) then
				--consumer.ready;
				NULL;
			end if;	   		

			select
				accept set(x: in Integer) do
					index := index + 1;
					put_line(Integer'Image(index));
					b_array(index) := x;
					put_line(Integer'Image(index));			
				end set;
			or
				accept get do				
					consumer.receive(b_array(index));
					index := index -1;
					put_line(Integer'Image(index));
				end get;
			or
				accept quit do
					NULL;
				end quit;
			or
				
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
	begin
		Put_Line(Message);
		loop -- add your task code inside this loop  
			select
				accept ready do
					value := Random(G);
					put_line(Integer'Image(value));
					buffer.set(value);
					put_line("hej");
					Reset(G);
				end ready;
			or
				accept quit do
					NULL;
				end quit;
			end select;
		 
			


         	end loop;
	end producer;


	task body consumer is 
		Message: constant String := "consumer executing";
                -- change/add your local declarations here
		value: Integer := 0;
	begin
		Put_Line(Message);
		Main_Cycle:
		loop     -- add your task code inside this loop 
			accept ready do 
				buffer.get;
				accept receive(x: in Integer) do
					put_line(Integer'Image(x));
					value := value + x;
				end receive;
			end ready;
			
			if (value >= 100) then
				exit;
			end if;
		end loop Main_Cycle; 

                -- add your code to stop executions of other tasks
		buffer.quit;
		producer.quit;     
		exception
			  when TASKING_ERROR =>
				  Put_Line("Buffer finished before producer");
		Put_Line("Ending the consumer");
	end consumer;
begin
	Put_Line(Message);
end comm1;
