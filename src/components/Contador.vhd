library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Contador is
    port (
        clock : in  std_logic;
        reset : in  std_logic;
        op    : in  std_logic_vector(1 downto 0);
        a     : in  std_logic_vector(3 downto 0); 
        q     : out std_logic_vector(3 downto 0)
    );
end Contador;

architecture arq of Contador is
begin
    process (clock, reset)
        variable cnt : std_logic_vector(3 downto 0);
    begin
        if reset = '1' then
            cnt := (others => '0');
        elsif clock'event and clock = '1' then
            case op is
                when "01"   => cnt := a;
                when "10"   => cnt := cnt - 1;
                when "11"   => cnt := cnt + 1;
                when others => cnt := cnt;  
            end case;
        end if;
        q <= cnt;
    end process;
end arq;
