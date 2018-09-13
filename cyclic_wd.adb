--Cyclic scheduler with a watchdog: 

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;

use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;

-- add packages to use randam number generator


procedure cyclic_wd is
    Message: constant String := "Cyclic scheduler with watchdog";
        -- change/add your declarations here
	Start_Wait: Time;
	c: Integer := 0;         
	d: Duration := 1.0;
	Start_Time: Time := Clock;
        G: Generator;
	
	
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
		delay Duration(Random(G));

		Put(Message);
		Put_Line(Duration'Image(Clock - Start_Time));
		
		Reset(G); 
		-- add a random delay here
	end f3;
	
	task Watchdog is
	       -- add your task entries for communication
		entry start;
		entry stop;		   	
	end Watchdog;

	task body Watchdog is
		begin
		loop
                 -- add your task code inside this loop 
			accept start do
				put_line("Start!");
			end start;

			select			
				accept stop do
					put_line("No delay!");
				end stop;
			or
				delay 0.1;
				put_line("f3 has too long delay!");
				accept stop do
					put_line("Received stop too late!");
				end stop;
			end select;
			
		end loop;
	end Watchdog;

	begin

        loop
            -- change/add your code inside this loop     
              	Start_Wait := Clock;					
		f1;
                f2;
		if (c mod 2 = 0) then			
			delay until Start_Wait + 0.5;
			Watchdog.start;
			put_line("1");
                	f3;	
			put_line("3");		
			Watchdog.stop;
			put_line("4");	  
		end if;
		c := c+1;
		delay until Start_Wait + d;       
        end loop;
end cyclic_wd;
