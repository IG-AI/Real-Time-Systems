with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic_try is
    Message: constant String := "Cyclic scheduler";
        -- change/add your declarations here
	Start_Wait: Time;
	c: Integer := 0;  
	Start_Time: Time := Clock;
	s: Integer := 0;
	Release: Time;
	Drift: Duration;
	Next: Time;
        

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
	Start_Wait := Clock;
	Next := Start_Wait;
        loop
            -- change/add your code inside this loop                 				
		delay until Next;		
		Release := Clock;					
		f1;
                f2;
		Drift := Release - Next;

		-- Ensures that f3 is executed every other second
		if (c mod 2 = 0) then
			Next := Next - Drift + 0.5;	  
			delay until Next;
			
			--delay 0.5;
			
			Release := Clock;
                	f3;
			Drift := Release - Next;
			Next := Next - Drift; 	
		end if;
		c := c + 1;

		Next := Next - Drift + 1.0; 
        end loop;
end cyclic_try;

