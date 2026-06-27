library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--divisor de frequencia por 16
entity Divfreq_1Hz is
  port (
    clock, reset : in std_logic;-- frequencia de 27MHz
    q            : out std_logic); -- frequencia de 1 Hz
end Divfreq_1Hz;

architecture arq of Divfreq_1Hz is
begin

  process (clock, reset)
    variable count : std_logic_vector(24 downto 0);
    variable temp  : std_logic;
  begin
    if reset = '1' then
      count := (others => '0');
      temp  := '0';
    elsif clock'event and clock = '1' then
      if count = x"CDFE5F" then --(27M/2)-1 =13.499.999
        count := (others => '0');
        temp  := not temp;
      else
        count := count + 1;
      end if;
    end if;
    q <= temp;
  end process;

end arq;
