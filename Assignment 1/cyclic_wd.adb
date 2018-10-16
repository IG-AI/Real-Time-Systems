--Cyclic scheduler with a watchdog:  Ada lab part 2

with Ada.Calendar;
with Ada.Text_IO;
with Ada.Numerics.Float_Random;

use Ada.Calendar;
use Ada.Text_IO;
use Ada.Numerics.Float_Random;


procedure cyclic_wd is
    Message: constant String := "Cyclic scheduler with watchdog";
	Start_Time: Time := Clock;
	Start_Wait: Time := Clock;	
	counter: Integer := 0;  	
        G: Generator;
	flag: Boolean := TRUE;
	
	
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

		-- Random delay to make f3 occasionally have too long execution time
		delay Duration(Random(G));
		Reset(G); 		
	end f3;
	
	task Watchdog is
		entry start; -- Used to synchronize Watchdog with the start of f3's execution
		entry stop(Start_wait: in Time); -- Used to synchronize Watchdog with the end of f3's execution	 	   	
	end Watchdog;

	task body Watchdog is
		start_flag: Boolean := False;
	begin
		loop
 			select	
				-- Indicates that f3 is about to start executing 
				accept start do
					start_flag := True; 
				end start;
			or	
				-- Indicates that f3 finished executing in time 
				when (start_flag) =>	
					accept stop(Start_Wait: in Time) do
						start_flag := False;
						delay until Start_Wait + 1.0;
					end stop;
			or
				-- Indicates that f3 took longer then 0.5 seconds to execute
				when (start_flag) =>						
					delay 0.5;
					start_flag := False;
					put_line("f3's execution time was too long!");
					accept stop(Start_Wait: in Time) do
						delay until Start_Wait + 2.0;
					end stop;
					
			end select;
			
		end loop;
	end Watchdog;

	begin
        loop
		if (flag = FALSE) then
			Start_Wait := Start_Wait + 1.0;
		end if;
		if (flag = TRUE) then      		
			flag := FALSE;
		end if;	
			
		f1;
                f2;

		delay until Start_Wait + 0.5;

		Watchdog.start;

		-- Ensures that f3 is executed every other second
		if (counter mod 2 = 0) then	
                	f3;	  
		end if;

		Watchdog.stop(Start_Wait);
		
		counter := counter + 1;      
        end loop;
end cyclic_wd;
