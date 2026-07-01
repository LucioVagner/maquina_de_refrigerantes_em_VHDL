library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

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

    -- Flags combinacionais
    fichas_max <= '1' when fichas = "101" else '0'; -- "101" = 5 fichas
    estoque_ok <= '1' when estoque /= "0000" else '0';

    -- Ativa a venda quando chega a 5 fichas e tem refrigerante no estoque
    venda_ok <= fichas_max and estoque_ok;

    -- PROCESSO DAS FICHAS (CORRIGIDO)
    process (I_ticket, fichas_max, I_release)
    begin
        if I_release = '1' then
            -- PRIORIDADE 1: Venda liberada! Zera as fichas imediatamente (operação LOAD "01")
            op_fichas <= "01";       
            
        elsif I_ticket = '0' and fichas_max = '0' then
            -- PRIORIDADE 2: Botão KEY1 pressionado ('0') e não chegou a 5: Soma ficha (operação INCREMENTO "11")
            op_fichas <= "11";     
            
        else
            -- PADRÃO: Botão solto, ou máquina já cheia esperando a venda: Mantém o valor (operação HOLD "00")
            op_fichas <= "00";          
        end if;
    end process;


    -- PROCESSO DO ESTOQUE (MANTIDO)
    process (I_Mode, I_release, soma)
    begin
        if I_Mode = '1' then
            -- Modo Abastecimento: Carrega o novo valor somado
            op_estoque <= "01";        
            if soma > "01111" then      
                load_val <= "1111"; -- Limita o estoque em 15 max
            else
                load_val <= soma(3 downto 0);
            end if;
        elsif I_release = '1' then
            -- Venda autorizada: Decrementa estoque (-1)
            op_estoque <= "10";         
            load_val   <= (others => '0');
        else
            -- Mantém o estoque atual
            op_estoque <= "00";         
            load_val   <= (others => '0');
        end if;
    end process;

end arq;