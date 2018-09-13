with Ada.Calendar;
with Ada.Text_IO;
use Ada.Calendar;
use Ada.Text_IO;

procedure cyclic is
    Message: constant String := "Cyclic scheduler";
        -- change/add your declarations here
	Start_Wait: Time;
	c: Integer := 0;        
	d: Duration := 1.0;
	Start_Time: Time := Clock;
	s: Integer := 0;
        

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
            -- change/add your code inside this loop                 		
		Start_Wait := Clock;					
		f1;
                f2;
		if (c mod 2 = 0) then  
			delay until Start_Wait + 0.5;
                	f3;
		end if;
		c := c+1;
		delay until Start_Wait + d;
        end loop;
end cyclic;

