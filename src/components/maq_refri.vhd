library IEEE;
use IEEE.std_logic_1164.all;

entity maq_refri is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        I_Mode      : in  std_logic;
        I_CanNumber : in  std_logic_vector(3 downto 0);
        I_ticket    : in  std_logic;
        
        O_Number    : out std_logic_vector(3 downto 0);
        O_Value     : out std_logic_vector(2 downto 0);
        O_Release   : out std_logic;
        
        HEX0        : out std_logic_vector(6 downto 0); -- Unidade estoque
        HEX1        : out std_logic_vector(6 downto 0); -- Dezena estoque
        HEX2        : out std_logic_vector(6 downto 0)  -- Fichas
    );
end maq_refri;

architecture estrutural of maq_refri is

    component div_freq1hz
        port (
            clock : in  std_logic;
            reset : in  std_logic;
            q     : out std_logic
        );
    end component;

    component EdgeDetect
        port (
            clock : in  std_logic;
            reset : in  std_logic;
            D     : in  std_logic;
            pulse : out std_logic
        );
    end component;

    component CtrlLogic
        port (
            I_Mode      : in  std_logic;
            I_CanNumber : in  std_logic_vector(3 downto 0);
            I_ticket    : in  std_logic;
            I_release   : in  std_logic;
            fichas      : in  std_logic_vector(2 downto 0);
            estoque     : in  std_logic_vector(3 downto 0);
            op_fichas   : out std_logic_vector(1 downto 0);
            op_estoque  : out std_logic_vector(1 downto 0);
            load_val    : out std_logic_vector(3 downto 0);
            venda_ok    : out std_logic
        );
    end component;

    component Contador
        port (
            clock : in  std_logic;
            reset : in  std_logic;
            op    : in  std_logic_vector(1 downto 0);
            a     : in  std_logic_vector(3 downto 0);
            q     : out std_logic_vector(3 downto 0)
        );
    end component;

    component Bin2BCD
        port (
            bin     : in  std_logic_vector(3 downto 0);
            dezena  : out std_logic_vector(3 downto 0);
            unidade : out std_logic_vector(3 downto 0)
        );
    end component;

    component Dec7seg
        port (
            bcd : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- 2. Sinais internos para interligar os blocos
    signal clk_1Hz        : std_logic;
    signal pulse_release  : std_logic;
    signal venda_ok_sig   : std_logic;
    
    signal fichas_4b      : std_logic_vector(3 downto 0);
    signal estoque_sig    : std_logic_vector(3 downto 0);
    
    signal op_fichas_sig  : std_logic_vector(1 downto 0);
    signal op_estoque_sig : std_logic_vector(1 downto 0);
    signal load_val_sig   : std_logic_vector(3 downto 0);
    
    signal bcd_dezena     : std_logic_vector(3 downto 0);
    signal bcd_unidade    : std_logic_vector(3 downto 0);

begin

    
    
    divisor: Div_freq1Hz 
        port map (clock => clk, reset => rst, q => clk_1Hz);

    detector_venda: EdgeDetect 
        port map (clock => clk_1Hz, reset => rst, D => venda_ok_sig, pulse => pulse_release);

    cerebro: CtrlLogic 
        port map (
            I_Mode => I_Mode, I_CanNumber => I_CanNumber, I_ticket => I_ticket,
            I_release => pulse_release, fichas => fichas_4b(2 downto 0), 
            estoque => estoque_sig, op_fichas => op_fichas_sig, 
            op_estoque => op_estoque_sig, load_val => load_val_sig, 
            venda_ok => venda_ok_sig
        );

    cnt_fichas: Contador 
        port map (clock => clk_1Hz, reset => rst, op => op_fichas_sig, a => "0000", q => fichas_4b);

    cnt_estoque: Contador 
        port map (clock => clk_1Hz, reset => rst, op => op_estoque_sig, a => load_val_sig, q => estoque_sig);

    conversor_bcd: Bin2BCD 
        port map (bin => estoque_sig, dezena => bcd_dezena, unidade => bcd_unidade);

    -- Gambiarra padrao pra transformar 3 bits de ficha em 4 bits pro display
    disp_fichas: Dec7seg 
        port map (bcd => ('0' & fichas_4b(2 downto 0)), seg => HEX2);

    disp_estoque_dez: Dec7seg 
        port map (bcd => bcd_dezena, seg => HEX1);

    disp_estoque_uni: Dec7seg 
        port map (bcd => bcd_unidade, seg => HEX0);


    O_Number  <= estoque_sig;
    O_Value   <= fichas_4b(2 downto 0);
    O_Release <= pulse_release;

end estrutural;
