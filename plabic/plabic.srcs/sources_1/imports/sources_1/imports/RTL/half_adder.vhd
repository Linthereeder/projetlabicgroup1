library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity half_adder is
port (
	a	:	in	std_logic;
	b	:	in	std_logic;
	 
	s	:	out	std_logic;
	cout	:	out	std_logic
);
attribute dont_touch : string;
attribute dont_touch of half_adder : entity is "true";
end entity;

architecture Behavioral of half_adder is
signal g, p : std_logic;
begin

p <= a xor b;
g <= a and b;

s <= p ;

cout <= g  ;

end Behavioral;