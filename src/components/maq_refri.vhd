Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

entity maq_refri is
    port(
        clock, reset: in std_logic;
        I_mode: in std_logic;
        I_CanNumber: in std_logic_vector(3 downto 0);
        I_ticket : in std_logic;
		  displata1 : out std_logic_vector(6 downto 0);
		  displata0 : out std_logic_vector(6 downto 0);
		  dispficha : out std_logic_vector(6 downto 0);
        O_Number : out std_logic_vector(3 downto 0);
        O_Value : out std_logic_vector(2 downto 0);
        O_Release : out std_logic
);

end maq_refri;

architecture sim of maq_refri is

component Reg_1bit
    Port(
            clock,carga, clear, d : in std_logic;
            q : out std_logic
    );

end component;

component fripefrope 
    port(
            D, clock, clear: in std_logic;
            Q, notQ: out std_logic
        ); 

end component;


component Divfreq 
    port(clock,reset : in std_logic;
            q : out std_logic); -- frequencia divida por 16

end component;


component Divfreq_1Hz

    port(clock,reset : in std_logic;-- frequencia de 27MHz
            q : out std_logic_vector(1 downto 0)); -- frequencia de 1 Hz

end component;



component cont
    port(
            clock,clear : in std_logic;
            op : in std_logic_vector(1 downto 0);
            a : in std_logic_vector(3 downto 0);
            q : out std_logic_vector(3 downto 0)
        );
end component;
component seg71
		port(
				entrada : in std_logic_vector(3 downto 0); -- Aumentado para 6 bits (-32 a 31)
				saida1 : out std_logic_vector(6 downto 0); -- Dezenas
				saida2 : out std_logic_vector(6 downto 0) -- Unidades
		);
end component;

signal clock1 : std_logic;
signal fichas: std_logic_vector(3 downto 0);
signal quanti_fichas: std_logic_vector(3 downto 0);
signal opfichas : std_logic_vector(1 downto 0);
signal estoque : std_logic_vector(3 downto 0);
signal freq : std_logic_vector(1 downto 0);
signal venda : std_logic;
signal opestoque: std_logic_vector (1 downto 0);
signal quanti_estoque : std_logic_vector(3 downto 0);
signal release : std_logic;

begin
        contaficha: cont
        port map(clock => clock1, clear => reset, op => opfichas, a => quanti_fichas, q => fichas);
        
        contaestoque: cont
        port map(clock => clock1, clear => reset, op => opestoque, a => quanti_estoque, q => estoque );

        O_number <= estoque;
        O_value <=  fichas(2 downto 0); --gemini falo q da pra converter assim sem ter q criar mais um contador separado so pra contar 3 bits

        venda <= '1' when (	fichas = "0101" and estoque /= "0000")
                         else '0';

        divisor: Divfreq_1Hz 
        port map(clock => clock, reset => reset, q => freq);
		  
        clock1 <= freq(0);
		  
		  displaylata : seg71
		  port map(entrada => estoque, saida1 => displata1, saida2 => displata0);
		  
		  displayficha: seg71
		  port map(entrada => fichas, saida2 => dispficha);
		  
		  ff: fripefrope
		  port map(clock => clock1, clear => reset, D => venda, q => release);
		  
		  o_release <= release;
			
        process(I_ticket, fichas, venda)
        begin
            quanti_fichas <= "0000";
            if I_ticket = '0' then
                opfichas<= "00"; 
				

            elsif I_ticket = '1' and fichas < "0101" then
                opfichas<= "11"; --soma 1 nas fichas ate chegar em 0101, nao podendo ser mais nem menos que isso para libera
					
            else
                opfichas<= "00";
				end if;
        end process;

        process (I_mode, i_canNumber, estoque, venda )
            variable temp: std_logic_vector(4 downto 0);
        begin
            opestoque <= "00";
            quanti_estoque <= "0000";
				
            if i_mode = '1' then
                temp(4) := '0';
                temp(3 downto 0) := estoque;

                temp := temp + i_canNumber;                
                opestoque <= "01";
                
                if temp > "01111" then
                    quanti_estoque <= "1111";
                else 
                    quanti_estoque <= temp(3 downto 0);
                end if;
            elsif release = '1' then
                opestoque <= "10";
            end if;
        end process;

end sim; 