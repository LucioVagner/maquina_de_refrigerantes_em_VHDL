library IEEE;
use IEEE.std_logic_1164.all;


entity EdgeDetect is
    port (
        clock : in  std_logic;
        reset : in  std_logic;
        D     : in  std_logic;
        pulse : out std_logic 
    );
end EdgeDetect;

architecture arq of EdgeDetect is
    signal d_prev : std_logic; 
begin
    process (clock, reset)
    begin
        if reset = '1' then
            d_prev <= '0';
        elsif clock'event and clock = '1' then
            d_prev <= D;
        end if;
    end process;

    
    pulse <= D and (not d_prev);
end arq;
