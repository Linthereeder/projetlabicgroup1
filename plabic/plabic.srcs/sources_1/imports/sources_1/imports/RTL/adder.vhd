-- TUM
-- Engineer: Haoyuan Liu ge49nor
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
Generic (
        input_width : integer := 64
);
Port (
        a       :       in      STD_LOGIC_VECTOR(input_width-2 downto 0);
        b       :       in      STD_LOGIC_VECTOR(input_width-2 downto 0);
	neg_b	:	in	STD_LOGIC;
        s       :       out	STD_LOGIC_VECTOR(input_width-1 downto 0)
);
attribute dont_touch : string;
attribute dont_touch of adder : entity is "true";
end adder;

architecture Behavioral of adder is

signal  s_int, c_int : std_logic_vector(input_width-1 downto 0);
signal  a_int, b_int: std_logic_vector(input_width-2 downto 0);
begin

negate_b: process(all)
begin
	if neg_b = '1' then
		b_int <= not(b);
	else
		b_int <= b;
	end if;
end process;

a_int <= a;

fa_0: entity work.full_adder(Behavioral)
port map (
        a       =>      a_int(0),
        b       =>      b_int(0),
        cin     =>      neg_b,
        s       =>      s_int(0),
        cout    =>      c_int(1)
);

g_full_adders: for i in 1 to input_width - 2 generate
fa_i: entity work.full_adder(Behavioral)
port map (
	a	=>	a_int(i),
	b	=>	b_int(i),
	cin	=>	c_int(i),
	s	=>	s_int(i),
	cout	=>	c_int(i+1)
);
end generate g_full_adders;

s_int(input_width - 1)<=c_int(input_width - 1);
s <= s_int;

end Behavioral;
