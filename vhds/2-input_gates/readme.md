## Multiplexador 2 para 1

### Design Digital

![gates2](imgs/gates2.png)

### Tabela Verdade

![tabela verdade](imgs/tabela-verdade.png)

$\text{and\_gate} = a * b$

$\text{nand\_gate} = \overline{a * b}$

$\text{or\_gate} = a + b$

$\text{nor\_gate} = \overline{a + b}$

$\text{xor\_gate} = a \oplus b$

$\text{nxor\_gate} = \overline{a \oplus b}$

### Código VHDL

[Link para o arquivo VHDL](/vhds/mux_2-to-1/mux21.vhd)

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;

entity mux21 is
	port (
		a : in STD_LOGIC;
		b : in STD_LOGIC;
		s : in STD_LOGIC;
		y : out STD_LOGIC
	);
end mux21;

architecture mux21 of mux21 is
	signal aout : STD_LOGIC;
	signal bout : STD_LOGIC;
	signal nots : STD_LOGIC

begin
	aout <= nots and a;
	bout <= s and b;
	nots <= not(s);
	y <= bout or aout;
end mux21;
```