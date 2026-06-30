Library IEEE;
USE IEEE.std_logic_1164.all;

Entity Reg_1bit is
Port(
		clock,carga, clear, d : in std_logic;
		q : out std_logic
);
end Reg_1bit;


architecture arq of Reg_1bit is

signal q_temp : std_logic;
begin

processo1: PROCESS(clock, clear)
BEGIN
	IF clear = '1' THEN
		q_temp <= '0';
	ELSIF clock'EVENT and clock='1' THEN
	IF carga = '1' THEN
		q_temp <= d;
	ELSE
		q_temp <= q_temp;
	END IF;
	END IF;
	END PROCESS processo1;
	q <= q_temp;


end arq;	  