library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity clkdiv_top is
	port (
		mclk: in std_logic;
		ld: out std_logic_vector (2 downto 0)
	);
end clkdiv_top;

architecture clkdiv_top of clkdiv_top is
component clkdiv
	port (
		mclk: in std_logic;
		clr: in std_logic;
		clk1: out std_logic;
		clk2: out std_logic;
		clk3: out std_logic
	);
end component;

begin
	C1: clkdiv port map (
		mclk => mclk,
		clr => '0',
		clk1 => ld(0),
		clk2 => ld(1),
		clk3 => ld(2)
	);
end clkdiv_top;