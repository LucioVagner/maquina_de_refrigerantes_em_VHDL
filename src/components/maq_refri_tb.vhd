library IEEE;
use IEEE.std_logic_1164.all;

entity maq_refri_tb is
end maq_refri_tb;

architecture sim of maq_refri_tb is

    
    component maq_refri is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            I_Mode      : in  std_logic;
            I_CanNumber : in  std_logic_vector(3 downto 0);
            I_ticket    : in  std_logic;
            O_Number    : out std_logic_vector(3 downto 0);
            O_Value     : out std_logic_vector(2 downto 0);
            O_Release   : out std_logic;
            HEX0        : out std_logic_vector(6 downto 0);
            HEX1        : out std_logic_vector(6 downto 0);
            HEX2        : out std_logic_vector(6 downto 0)
        );
    end component;

    
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal I_Mode      : std_logic := '0';
    signal I_CanNumber : std_logic_vector(3 downto 0) := "0000";
    signal I_ticket    : std_logic := '0';
    
    signal O_Number    : std_logic_vector(3 downto 0);
    signal O_Value     : std_logic_vector(2 downto 0);
    signal O_Release   : std_logic;
    signal HEX0, HEX1, HEX2 : std_logic_vector(6 downto 0);

    constant T : time := 20 ns; 

begin

    
    clk <= not clk after T / 2;

    
    uut : maq_refri port map (
        clk => clk, rst => rst, I_Mode => I_Mode, I_CanNumber => I_CanNumber,
        I_ticket => I_ticket, O_Number => O_Number, O_Value => O_Value,
        O_Release => O_Release, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2
    );

    stimulus : process
    begin

        rst <= '1'; wait for 100 ns;
        rst <= '0'; wait for 100 ns;

        -- Repor 5 latinhas
        I_Mode <= '1'; I_CanNumber <= "0101"; wait for 100 ns;
        I_Mode <= '0'; I_CanNumber <= "0000"; wait for 100 ns;

        -- Inserir 5 ficas segurando o botao
        I_ticket <= '1';
        wait for 300 ns; 
        I_ticket <= '0'; 
        wait for 100 ns;

        wait;
    end process stimulus;

end sim;
