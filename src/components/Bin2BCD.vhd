library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Bin2BCD is
    port (
        bin     : in  std_logic_vector(3 downto 0); 
        dezena  : out std_logic_vector(3 downto 0);
        unidade : out std_logic_vector(3 downto 0) 
    );
end Bin2BCD;

architecture arq of Bin2BCD is
begin
    process (bin)
    begin
        if bin >= "1010" then   
            dezena  <= "0001";
            unidade <= bin - "1010"; 
        else
            dezena  <= "0000";
            unidade <= bin;
        end if;
    end process;
end arq;
