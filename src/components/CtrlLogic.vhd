library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--
-- Entradas:
--   I_Mode      : modo de repor os trem ativo
--   I_CanNumber : quantidade a repor (4 bits)
--   I_ticket    : ficha inserida
--   I_release   : sinal interno: venda autorizada vulgo detector de borda(edge detect)
--   fichas      : valor atual do contador de fichas (3 bits)
--   estoque     : valor atual do contador de estoque (4 bits)
--

entity CtrlLogic is
    port (
        I_Mode      : in  std_logic;
        I_CanNumber : in  std_logic_vector(3 downto 0);
        I_ticket    : in  std_logic;
        I_release   : in  std_logic;  -- pulso de 1 ciclo vindo do EdgeDetect
        fichas      : in  std_logic_vector(2 downto 0);
        estoque     : in  std_logic_vector(3 downto 0);
        op_fichas   : out std_logic_vector(1 downto 0);
        op_estoque  : out std_logic_vector(1 downto 0);
        load_val    : out std_logic_vector(3 downto 0);
        venda_ok    : out std_logic
    );
end CtrlLogic;

architecture arq of CtrlLogic is
    signal soma       : std_logic_vector(4 downto 0); -- 5 bits para detectar overflow
    signal fichas_max : std_logic;                    -- fichas atingiram 5
    signal estoque_ok : std_logic;                    -- estoque > 0
begin

    -- Soma do estoque atual com a reposicao (5 bits para capturar carry)
    soma <= ('0' & estoque) + ('0' & I_CanNumber);

    -- Flags combilacionais
    fichas_max <= '1' when fichas = "101" else '0';
    estoque_ok <= '1' when estoque /= "0000" else '0';

    
    venda_ok <= fichas_max and estoque_ok;

    process (I_ticket, fichas_max)
    begin
        if fichas_max = '1' and I_ticket = '0' then
            
            op_fichas <= "01";       
        elsif I_ticket = '1' and fichas_max = '0' then
            
            op_fichas <= "11";     
        else
            
            op_fichas <= "00";          
        end if;
    end process;


    process (I_Mode, I_release, soma)
    begin
        if I_Mode = '1' then
            
            op_estoque <= "01";        
            if soma > "01111" then      
                load_val <= "1111";
            else
                load_val <= soma(3 downto 0);
            end if;
        elsif I_release = '1' then
            -- Venda autorizada: decrementa estoque
            op_estoque <= "10";         -- decrementa
            load_val   <= (others => '0');
        else
            op_estoque <= "00";         
            load_val   <= (others => '0');
        end if;
    end process;

end arq;
