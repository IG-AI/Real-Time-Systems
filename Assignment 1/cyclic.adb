--Cyclic scheduler:  Ada lab part 1

with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic is
    Message: constant String := "Cyclic scheduler";
	Start_Time: Time := Clock;
	Start_Wait: Time := Clock;
	counter: Integer := 0;  
	
        

	procedure f1 is 
		Message: constant String := "f1 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f1;

	procedure f2 is 
		Message: constant String := "f2 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f2;

	procedure f3 is 
		Message: constant String := "f3 executing, time is now";
	begin
		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
	end f3;

	begin
        loop           		
		Start_Wait := Start_Wait + 1.0;				
		f1;
                f2;

		-- Ensures that f3 is executed every other second
		if (counter mod 2 = 0) then  
			delay until Start_Wait + 0.5;
                	f3;
		end if;
		counter := counter + 1;
		
		delay until Start_Wait + 1.0;
        end loop;
end cyclic;

