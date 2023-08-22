Organização de Computadores, Roteiro da Aula Prática 3, 01 de agosto de 2023.

---

**Sumário**


## Objetivo da aula

Implementar um somador com o adder, mux e registrador.

## Roteiro 1

### Criar projeto

- New project wizard
- Selecione uma pasta .../ex04
- O nome do projeto é: `reg_count`
- Clique em Next
- Selecione qualquer FPGA, pois não faremos o uso de alguma placa em específica.
- Clique em Next
- Finish

### Arquivo adder8

TODO: descrever o papel do adder e suas entradas e saídas.

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity adder8 is 
	port (
		a,b: in std_logic_vector(7 downto 0);
		s: out std_logic_vector(7 downto 0)
	);
end adder8;

architecture behavioral of adder8 is
begin
	process (a,b)
	variable temp: std_logic_vector (7 downto 0);
	
	begin
		temp := a + b;
		s <= temp;
	end process;
end behavioral;
```

### Arquivo mux88

TODO: descrever o papel do mux88 e suas entradas e saídas.

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;

entity mux88 is 
	port (
		s: in std_logic;
		a, b: in std_logic_vector (7 downto 0);
		y: out std_logic_vector(7 downto 0)
	);
end mux88;

architecture mux88 of mux88 is
begin
	process (s, a, b)
	begin
		case s is 
			when '0' => y <= a; -- caso s seja igual a 0, y recebe a.
			when '1' => y <= b;
			when others => y <= X"00"; -- y sera 0.
			end case;
	end process;
end mux88;
```

### Arquivo reg

TODO: descrever o papel do componente e suas entradas e saídas.

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;

entity reg is 
	port (
		clk: in std_logic;
		clr: in std_logic;
		d: in std_logic_vector (7 downto 0);
		q: out std_logic_vector (7 downto 0)
	);
end reg;

architecture reg of reg is 
begin
	process (clr, clk)
	begin
		if (clr = '1') then
			-- q <= X"00";
			q <= (others => '0');
		else
			if (clk'event and clk = '1') then
				q <= d;
			end if;
		end if;
	end process;
end reg;
```

### Arquivo reg_count

TODO: descrever o papel do componente e suas entradas e saídas.

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity reg_count is 
	port (
		d: in std_logic_vector(7 downto 0);
		q: out std_logic_vector(7 downto 0);
		s: in std_logic;
		clr, clk: in std_logic
	);
end reg_count;

architecture structural of reg_count is
	signal adder_out: std_logic_vector(7 downto 0);
	signal reg_out: std_logic_vector(7 downto 0);
	signal mux_out: std_logic_vector(7 downto 0);
	
	component adder8
	port (
		a,b: in std_logic_vector(7 downto 0);
		s: out std_logic_vector(7 downto 0)
	);
	end component;
	
	component reg
	port (
		clk: in std_logic;
		clr: in std_logic;
		d: in std_logic_vector (7 downto 0);
		q: out std_logic_vector (7 downto 0)
	);
	end component;
	
	component mux88
	port (
		s: in std_logic;
		a, b: in std_logic_vector (7 downto 0);
		y: out std_logic_vector(7 downto 0)
	);	
	end component;
	
	begin
		ADDER: adder8 port map (
			a => reg_out,
			b => X"01", -- 01 em hexadecimal
			s => adder_out
		);
		
		MREG: reg port map (
			clk => clk,
			clr => '0',
			d => mux_out,
			q => reg_out
		);
		
		MUX: mux88 port map (
			s => s,
			a => adder_out,
			b => d,
			y => mux_out
		);
		
		q <= reg_out;
end structural;
```

 Obs.: O relatório dessa aula é até apenas essa parte. Daqui pra frente é outra história.

## Roteiro 2

Display de 7 segmentos varia de A até G, todos os segmentos dos displays estão ligados no mesmo pino do FPGA, são segmentos de anôdo. Para os dois displays funcionarem é necessário fazer a troca de padrão entre os displays muito rápido.

### 