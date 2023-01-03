----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:51:38 04/30/2013 
-- Design Name: 
-- Module Name:    char - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package charLib is
	subtype t_char is std_logic_vector(7 downto 0);
	type t_char_image is array (0 to 6) of std_logic_vector (7 downto 0);
	type t_small_char_image is array(0 to 4) of std_logic_vector (7 downto 0);
	type t_font is array (0 to 127) of t_small_char_image;
	
	type t_line is array (0 to 19) of t_char;
	type t_text is array (0 to 3) of t_line;

	constant test_text : t_text :=
	( (x"20", x"21", x"22", x"23", x"24", x"25", x"26", x"27", x"28", x"29", x"2A", x"2B", x"2C", x"2D", x"2E", x"2F", x"30", x"31", x"32", x"33"),
	  (x"34", x"35", x"36", x"37", x"38", x"39", x"3A", x"3B", x"3C", x"3D", x"23", x"3F", x"40", x"41", x"42", x"43", x"44", x"45", x"46", x"47"),
	  (x"48", x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F", x"50", x"51", x"52", x"53", x"54", x"55", x"56", x"57", x"58", x"59", x"5A", x"5B"),
	  (x"5C", x"5D", x"5E", x"5F", x"60", x"61", x"62", x"63", x"64", x"65", x"66", x"67", x"68", x"69", x"6A", x"6B", x"6C", x"6D", x"6E", x"6F") );

	constant default_font : t_font := (
		(x"00", x"00", x"00", x"00", x"00"), -- 00  
		(x"FF", x"00", x"00", x"00", x"00"), -- 01  |
		(x"FF", x"FF", x"00", x"00", x"00"), -- 02  ||
		(x"FF", x"FF", x"FF", x"00", x"00"), -- 03  |||
		(x"FF", x"FF", x"FF", x"FF", x"00"), -- 04  ||||
		(x"FF", x"FF", x"FF", x"FF", x"FF"), -- 05  |||||
		(x"00", x"FE", x"00", x"FE", x"00"), -- 06   | |
		(x"08", x"78", x"FC", x"78", x"08"), -- 07  Bell
		(x"00", x"00", x"00", x"00", x"00"), -- 08
		(x"00", x"00", x"00", x"00", x"00"), -- 09
		(x"00", x"00", x"00", x"00", x"00"), -- 0A
		(x"00", x"00", x"00", x"00", x"00"), -- 0B
		(x"00", x"00", x"00", x"00", x"00"), -- 0C
		(x"00", x"00", x"00", x"00", x"00"), -- 0D
		(x"00", x"00", x"00", x"00", x"00"), -- 0E
		(x"00", x"00", x"00", x"00", x"00"), -- 0F
		(x"00", x"00", x"00", x"00", x"00"), -- 10
		(x"00", x"00", x"00", x"00", x"00"), -- 11
		(x"00", x"00", x"00", x"00", x"00"), -- 12
		(x"00", x"00", x"00", x"00", x"00"), -- 13
		(x"00", x"00", x"00", x"00", x"00"), -- 14
		(x"00", x"00", x"00", x"00", x"00"), -- 15
		(x"00", x"00", x"00", x"00", x"00"), -- 16
		(x"00", x"00", x"00", x"00", x"00"), -- 17
		(x"00", x"00", x"00", x"00", x"00"), -- 18
		(x"00", x"00", x"00", x"00", x"00"), -- 19
		(x"00", x"00", x"00", x"00", x"00"), -- 1A
		(x"00", x"00", x"00", x"00", x"00"), -- 1B
		(x"00", x"00", x"00", x"00", x"00"), -- 1C
		(x"00", x"00", x"00", x"00", x"00"), -- 1D
		(x"00", x"00", x"00", x"00", x"00"), -- 1E
		(x"00", x"00", x"00", x"00", x"00"), -- 1F
		(x"00", x"00", x"00", x"00", x"00"), -- 20
		(x"00", x"00", x"F2", x"00", x"00"), -- 21  !
		(x"00", x"E0", x"00", x"E0", x"00"), -- 22  "
		(x"28", x"FE", x"28", x"FE", x"28"), -- 23  #
		(x"24", x"54", x"FE", x"54", x"48"), -- 24  $
		(x"C4", x"C8", x"10", x"26", x"46"), -- 25  %
		(x"6C", x"92", x"AA", x"44", x"0A"), -- 26  &
		(x"00", x"A0", x"C0", x"00", x"00"), -- 27  '
		(x"00", x"38", x"44", x"82", x"00"), -- 28  (
		(x"00", x"82", x"44", x"38", x"00"), -- 29  )
		(x"28", x"10", x"7C", x"10", x"28"), -- 2A  *
		(x"10", x"10", x"7C", x"10", x"10"), -- 2B  +
		(x"00", x"0A", x"0C", x"00", x"00"), -- 2C  ,
		(x"10", x"10", x"10", x"10", x"10"), -- 2D  -
		(x"00", x"06", x"06", x"00", x"00"), -- 2E  .
		(x"04", x"08", x"10", x"20", x"40"), -- 2F  /
		(x"7C", x"8A", x"92", x"A2", x"7C"), -- 30  0
		(x"00", x"42", x"FE", x"02", x"00"), -- 31  1
		(x"42", x"86", x"8A", x"92", x"62"), -- 32  2
		(x"84", x"82", x"A2", x"D2", x"8C"), -- 33  3
		(x"18", x"28", x"48", x"FE", x"08"), -- 34  4
		(x"E4", x"A2", x"A2", x"A2", x"9C"), -- 35  5
		(x"3C", x"52", x"92", x"92", x"0C"), -- 36  6
		(x"80", x"8E", x"90", x"A0", x"C0"), -- 37  7
		(x"6C", x"92", x"92", x"92", x"6C"), -- 38  8
		(x"60", x"92", x"92", x"94", x"78"), -- 39  9
		(x"00", x"6C", x"6C", x"00", x"00"), -- 3A  :
		(x"00", x"6A", x"6C", x"00", x"00"), -- 3B  ;
		(x"10", x"28", x"44", x"82", x"00"), -- 3C  <
		(x"28", x"28", x"28", x"28", x"28"), -- 3D  =
		(x"00", x"82", x"44", x"28", x"10"), -- 3E  >
		(x"40", x"80", x"8A", x"90", x"60"), -- 3F  ?
		(x"4C", x"92", x"9E", x"82", x"7C"), -- 40  @
		(x"7E", x"88", x"88", x"88", x"7E"), -- 41  A
		(x"FE", x"92", x"92", x"92", x"6C"), -- 42  B
		(x"7C", x"82", x"82", x"82", x"44"), -- 43  C
		(x"FE", x"82", x"82", x"44", x"38"), -- 44  D
		(x"FE", x"92", x"92", x"92", x"82"), -- 45  E
		(x"FE", x"90", x"90", x"90", x"80"), -- 46  F
		(x"7C", x"82", x"92", x"92", x"5E"), -- 47  G
		(x"FE", x"10", x"10", x"10", x"FE"), -- 48  H
		(x"00", x"82", x"FE", x"82", x"00"), -- 49  I
		(x"04", x"02", x"82", x"FC", x"80"), -- 4A  J
		(x"FE", x"10", x"28", x"44", x"82"), -- 4B  K
		(x"FE", x"02", x"02", x"02", x"02"), -- 4C  L
		(x"FE", x"40", x"30", x"40", x"FE"), -- 4D  M
		(x"FE", x"20", x"10", x"08", x"FE"), -- 4E  N
		(x"7C", x"82", x"82", x"82", x"7C"), -- 4F  O
		(x"FE", x"90", x"90", x"90", x"60"), -- 50  P
		(x"7C", x"82", x"8A", x"84", x"7A"), -- 51  Q
		(x"FE", x"90", x"98", x"94", x"C2"), -- 52  R
		(x"62", x"92", x"92", x"92", x"8C"), -- 53  S
		(x"80", x"80", x"FE", x"80", x"80"), -- 54  T
		(x"FC", x"02", x"02", x"02", x"FC"), -- 55  U
		(x"F8", x"04", x"02", x"04", x"F8"), -- 56  V
		(x"FC", x"02", x"1C", x"02", x"FC"), -- 57  W
		(x"C6", x"28", x"10", x"28", x"C6"), -- 58  X
		(x"E0", x"10", x"0E", x"10", x"E0"), -- 59  Y
		(x"86", x"8A", x"92", x"A2", x"C2"), -- 5A  Z
		(x"00", x"FE", x"82", x"82", x"00"), -- 5B  [
		(x"40", x"20", x"10", x"08", x"04"), -- 5C  \
		(x"00", x"82", x"82", x"FE", x"00"), -- 5D  ]
		(x"20", x"40", x"80", x"40", x"20"), -- 5E  ^
		(x"02", x"02", x"02", x"02", x"02"), -- 5F  _
		(x"00", x"80", x"40", x"20", x"00"), -- 60  `
		(x"04", x"2A", x"2A", x"2A", x"1E"), -- 61  a
		(x"FE", x"0A", x"12", x"12", x"0C"), -- 62  b
		(x"1C", x"22", x"22", x"22", x"04"), -- 63  c
		(x"0C", x"12", x"12", x"0A", x"FE"), -- 64  d
		(x"1C", x"2A", x"2A", x"2A", x"18"), -- 65  e
		(x"10", x"7E", x"90", x"80", x"40"), -- 66  f
		(x"30", x"4A", x"4A", x"4A", x"7C"), -- 67  g
		(x"FE", x"10", x"20", x"20", x"1E"), -- 68  h
		(x"00", x"00", x"5E", x"00", x"00"), -- 69  i
		(x"04", x"02", x"22", x"BC", x"00"), -- 6A  j
		(x"FE", x"08", x"14", x"22", x"00"), -- 6B  k
		(x"00", x"82", x"FE", x"02", x"00"), -- 6C  l
		(x"3E", x"20", x"18", x"20", x"1E"), -- 6D  m
		(x"3E", x"10", x"20", x"20", x"1E"), -- 6E  n
		(x"1C", x"22", x"22", x"22", x"1C"), -- 6F  o
		(x"3E", x"28", x"28", x"28", x"10"), -- 70  p
		(x"10", x"28", x"28", x"18", x"3E"), -- 71  q
		(x"3E", x"10", x"20", x"20", x"10"), -- 72  r
		(x"12", x"2A", x"2A", x"2A", x"04"), -- 73  s
		(x"20", x"FC", x"22", x"02", x"04"), -- 74  t
		(x"3C", x"02", x"02", x"04", x"3E"), -- 75  u
		(x"38", x"04", x"02", x"04", x"38"), -- 76  v
		(x"3C", x"02", x"3C", x"02", x"3C"), -- 77  w
		(x"22", x"14", x"08", x"14", x"22"), -- 78  x
		(x"30", x"0A", x"0A", x"0A", x"3C"), -- 79  y
		(x"22", x"26", x"2A", x"32", x"22"), -- 7A  z
		(x"00", x"10", x"6C", x"82", x"00"), -- 7B  {
		(x"00", x"00", x"FE", x"00", x"00"), -- 7C  |
		(x"00", x"82", x"6C", x"10", x"00"), -- 7D  }
		(x"10", x"10", x"54", x"38", x"10"), -- 7E  ->
		(x"10", x"38", x"54", x"10", x"10")  -- 7F  <-
	);
	
	constant CHAR_UP_A : std_logic_vector(7 downto 0) := x"41";
	constant CHAR_UP_B : std_logic_vector(7 downto 0) := x"42";
	constant CHAR_UP_C : std_logic_vector(7 downto 0) := x"43";
	constant CHAR_UP_D : std_logic_vector(7 downto 0) := x"44";
	constant CHAR_UP_E : std_logic_vector(7 downto 0) := x"45";
	constant CHAR_UP_F : std_logic_vector(7 downto 0) := x"46";
	constant CHAR_UP_G : std_logic_vector(7 downto 0) := x"47";
	constant CHAR_UP_H : std_logic_vector(7 downto 0) := x"48";
	constant CHAR_UP_I : std_logic_vector(7 downto 0) := x"49";
	constant CHAR_UP_J : std_logic_vector(7 downto 0) := x"4A";
	constant CHAR_UP_K : std_logic_vector(7 downto 0) := x"4B";
	constant CHAR_UP_L : std_logic_vector(7 downto 0) := x"4C";
	constant CHAR_UP_M : std_logic_vector(7 downto 0) := x"4D";
	constant CHAR_UP_N : std_logic_vector(7 downto 0) := x"4E";
	constant CHAR_UP_O : std_logic_vector(7 downto 0) := x"4F";
	constant CHAR_UP_P : std_logic_vector(7 downto 0) := x"50";
	constant CHAR_UP_Q : std_logic_vector(7 downto 0) := x"51";
	constant CHAR_UP_R : std_logic_vector(7 downto 0) := x"52";
	constant CHAR_UP_S : std_logic_vector(7 downto 0) := x"53";
	constant CHAR_UP_T : std_logic_vector(7 downto 0) := x"54";
	constant CHAR_UP_U : std_logic_vector(7 downto 0) := x"55";
	constant CHAR_UP_V : std_logic_vector(7 downto 0) := x"56";
	constant CHAR_UP_W : std_logic_vector(7 downto 0) := x"57";
	constant CHAR_UP_X : std_logic_vector(7 downto 0) := x"58";
	constant CHAR_UP_Y : std_logic_vector(7 downto 0) := x"59";
	constant CHAR_UP_Z : std_logic_vector(7 downto 0) := x"5A";

	constant CHAR_LOW_A : std_logic_vector(7 downto 0) := x"61";
	constant CHAR_LOW_B : std_logic_vector(7 downto 0) := x"62";
	constant CHAR_LOW_C : std_logic_vector(7 downto 0) := x"63";
	constant CHAR_LOW_D : std_logic_vector(7 downto 0) := x"64";
	constant CHAR_LOW_E : std_logic_vector(7 downto 0) := x"65";
	constant CHAR_LOW_F : std_logic_vector(7 downto 0) := x"66";
	constant CHAR_LOW_G : std_logic_vector(7 downto 0) := x"67";
	constant CHAR_LOW_H : std_logic_vector(7 downto 0) := x"68";
	constant CHAR_LOW_I : std_logic_vector(7 downto 0) := x"69";
	constant CHAR_LOW_J : std_logic_vector(7 downto 0) := x"6A";
	constant CHAR_LOW_K : std_logic_vector(7 downto 0) := x"6B";
	constant CHAR_LOW_L : std_logic_vector(7 downto 0) := x"6C";
	constant CHAR_LOW_M : std_logic_vector(7 downto 0) := x"6D";
	constant CHAR_LOW_N : std_logic_vector(7 downto 0) := x"6E";
	constant CHAR_LOW_O : std_logic_vector(7 downto 0) := x"6F";
	constant CHAR_LOW_P : std_logic_vector(7 downto 0) := x"70";
	constant CHAR_LOW_Q : std_logic_vector(7 downto 0) := x"71";
	constant CHAR_LOW_R : std_logic_vector(7 downto 0) := x"72";
	constant CHAR_LOW_S : std_logic_vector(7 downto 0) := x"73";
	constant CHAR_LOW_T : std_logic_vector(7 downto 0) := x"74";
	constant CHAR_LOW_U : std_logic_vector(7 downto 0) := x"75";
	constant CHAR_LOW_V : std_logic_vector(7 downto 0) := x"76";
	constant CHAR_LOW_W : std_logic_vector(7 downto 0) := x"77";
	constant CHAR_LOW_X : std_logic_vector(7 downto 0) := x"78";
	constant CHAR_LOW_Y : std_logic_vector(7 downto 0) := x"79";
	constant CHAR_LOW_Z : std_logic_vector(7 downto 0) := x"7A";
	
	constant CHAR_SPACE : std_logic_vector(7 downto 0) := x"20";
	constant CHAR_STAR : std_logic_vector(7 downto 0) := x"2A";
	constant CHAR_KOMMA : std_logic_vector(7 downto 0) := x"2C";
	constant CHAR_POINT : std_logic_vector(7 downto 0) := x"2E";
	constant CHAR_DBL_POINT : std_logic_vector(7 downto 0) := x"3A";
	
end package;

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.charLib.all;

--entity char is
--    Port ( char : in  t_char;
--           image : out t_char_image
--			 );
--end char;

--architecture Behavioral of char is
--	signal char_id : integer range 0 to 127;
--	signal normal_image : t_char_image;
--	signal inverted_image : t_char_image;
--begin

--	char_id <= to_integer(unsigned(char(6 downto 0)));
	
--	normal_image(0) <= x"00";
--	normal_image(1) <= default_font(char_id)(0);
--	normal_image(2) <= default_font(char_id)(1);
--	normal_image(3) <= default_font(char_id)(2);
--	normal_image(4) <= default_font(char_id)(3);
--	normal_image(5) <= default_font(char_id)(4);
--	normal_image(6) <= x"00";
	
--	inverted_image(0) <= not(normal_image(0));
--	inverted_image(1) <= not(normal_image(1));
--	inverted_image(2) <= not(normal_image(2));
--	inverted_image(3) <= not(normal_image(3));
--	inverted_image(4) <= not(normal_image(4));
--	inverted_image(5) <= not(normal_image(5));
--	inverted_image(6) <= not(normal_image(6));

--	mux : process(char, normal_image, inverted_image)
--	begin
--		if(char(char'high) = '0') then
--			image <= normal_image;
--		else
--			image <= inverted_image;
--		end if;
--	end process;
--end Behavioral;
