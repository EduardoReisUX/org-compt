Organização de Computadores, Roteiro da Aula Prática 6, 12 de setembro de 2023.

---

**Sumário**

- [Objetivo da aula](#objetivo-da-aula)
- [Roteiro](#roteiro)
	- [Criar projeto](#criar-projeto)
	- [Arquivo importado x7seg](#arquivo-importado-x7seg)
	- [Arquivo rom](#arquivo-rom)
	- [Arquivo neader\_rom](#arquivo-neader_rom)
	- [Pin Planner](#pin-planner)

## Objetivo da aula

Foi criado uma ROM do Neander. Visualização através do display de 7 segmentos.

TODO: imagem do circuito

## Roteiro

### Criar projeto

- New project wizard
- Selecione uma pasta .../ex7
- O nome do projeto é: `neander_rom`
- Selecione o seguinte arquivo .VHD da aula prática 4, disponíveis no site https://sites.google.com/view/fpgacomputer: "x7seg"
- Selecione FPGA Cyclone V, modelo EP4CE6E22C8
- Clique em Next
- Finish

### Arquivo importado x7seg

```VHD
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity x7seg is
	port (
	x: in std_logic_vector(15 downto 0);
	clk: in std_logic ;
	clr: in std_logic ;
	a_to_g: out	std_logic_vector (6 downto 0);
	an:     out std_logic_vector (3 downto 0);
	dp: out std_logic 
	);
end x7seg;

architecture x7seg of x7seg is

signal s:	  std_logic_vector (1 downto 0 );
signal digit:	  std_logic_vector (3 downto 0 );
signal aen: std_logic_vector (3 downto 0);
signal clkdiv: std_logic_vector (19 downto 0);

begin
	 s <= clkdiv (19 downto 18);
	
	aen <= "1111";
	dp <= '1';    
	

	
	
	
	--quad to 1 mux: mux44
	process (s,x)
	begin 
		case s is
			when "00" => digit <= x(3 downto 0);
			when "01" => digit <= x(7  downto 4);
			when "10" => digit <= x(11 downto 8);
			when others => digit <= x(15 downto 12);
		end case;
	end process;
   
	-- 7 segment decoder
	process ( digit)
	begin 
		case digit is 
			when X"0" => a_to_g <= "0000001"; --0 
			when X"1" => a_to_g <= "1001111"; --1
			when X"2" => a_to_g <= "0010010"; --2
			when X"3" => a_to_g <= "0000110"; --3
			when X"4" => a_to_g <= "1001100"; --4
			when X"5" => a_to_g <= "0100100"; --5
			when X"6" => a_to_g <= "0100000"; --6
			when X"7" => a_to_g <= "0001101"; --7
			when X"8" => a_to_g <= "0000000"; --8
			when X"9" => a_to_g <= "0000100"; --9
			when X"A" => a_to_g <= "0001000"; --A
			when X"B" => a_to_g <= "1100000"; --b
			when X"C" => a_to_g <= "0110001"; --C
			when X"D" => a_to_g <= "1000010"; --d
			when X"E" => a_to_g <= "0110000"; --E
			when others => a_to_g <= "0111000"; --F
		end case;
	end process; 
	
	-- digit select: ancode
	process (s,aen)
	begin
		an <= "1111";
		if aen(conv_integer(s)) = '1' then 
			an(conv_integer(s)) <= '0'; 
		end if;
	end process;
	
	-- clock divider
	process(clk,clr)
	begin
		if 	clr = '1' then
			clkdiv <= (others => '0');
		else 
			 if clk'event and clk = '1' then 
			   clkdiv <= clkdiv+1;
		     end if;
	   end if;
	end process;
	
end x7seg;
```

### Arquivo rom

```VHD
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity rom is 
	port (
		addr: in std_logic_vector(3 downto 0); -- quantas posições sua ROM tem
															-- 2^x; 4 bits = 16 posições; 
		M : out std_logic_vector(7 downto 0)
	);
end rom;

architecture rom of rom is 
	type rom_array is array (natural range <>) of std_logic_vector(7 downto 0);
	constant mrom: rom_array := (
		X"20", X"0E", X"30", X"0F",
		X"22", X"2E", X"A0", X"AF",
		X"2E", X"AE", X"3A", X"2F",
		X"2B", X"CE", X"3D", X"EF"
	);
	
begin 
	process (addr)
	variable j: integer;
	begin
		j := conv_integer(addr);
		M <= mrom (j);
	end process;
end rom;
```

### Arquivo neader_rom

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity neander_rom is 
	port(
		mclk: in std_logic;
		btn: in std_logic_vector(3 downto 0);
		a_to_g: out std_logic_vector(6 downto 0);
		an: out std_logic_vector(3 downto 0); -- anodo
		dp: out std_logic -- ponto decimal
	);
end neander_rom;

architecture neander_rom of neander_rom is
component x7seg
	port (
		x: in std_logic_vector(15 downto 0);
		clk: in std_logic ;
		clr: in std_logic ;
		a_to_g: out	std_logic_vector (6 downto 0);
		an:     out std_logic_vector (3 downto 0);
		dp: out std_logic 
		);
end component;

component rom
	port (
			addr: in std_logic_vector(3 downto 0); -- quantas posições sua ROM tem
																-- 2^x; 4 bits = 16 posições; 
			M : out std_logic_vector(7 downto 0)
		);
end component;

signal memory_address: std_logic_vector(3 downto 0);
signal memory_output: std_logic_vector(7 downto 0);

begin
	memory_address <= not btn;
	U1: rom port map (
		addr => memory_address,
		M => memory_output
	);
	U2: x7seg port map (
		x => X"00" & memory_output, -- 00 hexadecimal concatenado com output
		clk => mclk,
		clr => '0',
		a_to_g => a_to_g,
		an => an,
		dp => dp
	);

end neander_rom;
```

### Pin Planner

Assignments -> Pin Planner

![Pin Planner](imgs/pin-planner.png)