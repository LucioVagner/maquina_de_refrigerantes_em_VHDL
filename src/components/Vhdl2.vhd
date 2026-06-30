library IEEE;
use IEEE.std_logic_1164.all;

entity FF_D is 
	port (
		D, clock, clear: in std_logic;
		Q, notQ: out std_logic
	); 
end FF_D;

architecture arch_fripefrope of FF_D is
signal tempQ: std_logic;

begin

PROCESS(clock, clear)
	BEGIN
	IF clock'EVENT and clock='1' THEN
		IF clear = '1' then
			Q <= '0';
		else
			Q <= D;
			tempQ <= D;
		END IF;
	END IF;
	END PROCESS;

notQ <= not(tempQ);
	
end arch_fripefrope;