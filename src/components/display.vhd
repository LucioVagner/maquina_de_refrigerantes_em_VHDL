library ieee;
use ieee.std_logic_1164.all;

entity seg71 is
port(
    entrada : in std_logic_vector(3 downto 0); -- Aumentado para 6 bits (-32 a 31)
    saida1 : out std_logic_vector(6 downto 0); -- Dezenas
    saida2 : out std_logic_vector(6 downto 0); -- Unidades
);
end seg71;

architecture arq of seg71 is
  
begin

    with entrada select
        saida1 <= 
        
        -- FAIXA POSITIVA (10 a 31)
        "1111001" when "1010", -- 10 (Mostra 1)
        "1111001" when "1011", -- 11
        "1111001" when "1100", -- 12
        "1111001" when "1101", -- 13
        "1111001" when "1110", -- 14
        "1111001" when "1111", -- 15
        "1111111" when others; 

    -- SAIDA 2: UNIDADES
    -- Usa os mesmos códigos do seu "saida2" original
 
    with entrada select
        saida2 <= 
		  
        "1000000" when "0000", -- 0
        "1111001" when "0001", -- 1
        "0100100" when "0010", -- 2
        "0110000" when "0011", -- 3
        "0011001" when "0100", -- 4
        "0010010" when "0101", -- 5
        "0000010" when "0110", -- 6
        "1111000" when "0111", -- 7
        "0000000" when "1000", -- 8
        "0010000" when "1001", -- 9
        "1000000" when "1010", -- 10 (Termina em 0)
        "1111001" when "1011", -- 11 (Termina em 1)
        "0100100" when "1100", -- 12 (Termina em 2)
        "0110000" when "1101", -- 13 (Termina em 3)
        "0011001" when "1110", -- 14 (Termina em 4)
        "0010010" when "1111", -- 15 (Termina em 5)

        
        "1111111" when others; -- Segurança (tudo apagado)

end arq;