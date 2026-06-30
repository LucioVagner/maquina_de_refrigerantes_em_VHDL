library IEEE;
use IEEE.std_logic_1164.all;

entity fripefrope is 
	port (
		D, clock, clear: in std_logic;
		Q, notQ: out std_logic
	); 
end fripefrope;

architecture arch_fripefrope of fripefrope is
signal tempQ: std_logic;

begin

PROCESS(clock, clear)
	BEGIN
	IF clock'EVENT and clock='1' THEN
		IF clear = '1' then
			tempQ <= '0';
		else
			tempQ <= D;
		END IF;
	END IF;
	END PROCESS;

notQ <= not(D and (not tempq));
Q <= D and (not tempQ);

end arch_fripefrope;