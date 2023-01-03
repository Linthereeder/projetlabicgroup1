----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 17:26:49
-- Design Name: 
-- Module Name: parameters - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package parameters is
    type char_line is array (0 to 19) of std_logic_vector (7 downto 0);
    type char_all is array (0 to 3) of char_line ;
    type char_dow is array (0 to 2) of std_logic_vector (7 downto 0);
    
    constant CHAR_HIGH_A : std_logic_vector(7 downto 0) := x"41";
	constant CHAR_HIGH_B : std_logic_vector(7 downto 0) := x"42";
	constant CHAR_HIGH_C : std_logic_vector(7 downto 0) := x"43";
	constant CHAR_HIGH_D : std_logic_vector(7 downto 0) := x"44";
	constant CHAR_HIGH_E : std_logic_vector(7 downto 0) := x"45";
	constant CHAR_HIGH_F : std_logic_vector(7 downto 0) := x"46";
	constant CHAR_HIGH_G : std_logic_vector(7 downto 0) := x"47";
	constant CHAR_HIGH_H : std_logic_vector(7 downto 0) := x"48";
	constant CHAR_HIGH_I : std_logic_vector(7 downto 0) := x"49";
	constant CHAR_HIGH_J : std_logic_vector(7 downto 0) := x"4A";
	constant CHAR_HIGH_K : std_logic_vector(7 downto 0) := x"4B";
	constant CHAR_HIGH_L : std_logic_vector(7 downto 0) := x"4C";
	constant CHAR_HIGH_M : std_logic_vector(7 downto 0) := x"4D";
	constant CHAR_HIGH_N : std_logic_vector(7 downto 0) := x"4E";
	constant CHAR_HIGH_O : std_logic_vector(7 downto 0) := x"4F";
	constant CHAR_HIGH_P : std_logic_vector(7 downto 0) := x"50";
	constant CHAR_HIGH_Q : std_logic_vector(7 downto 0) := x"51";
	constant CHAR_HIGH_R : std_logic_vector(7 downto 0) := x"52";
	constant CHAR_HIGH_S : std_logic_vector(7 downto 0) := x"53";
	constant CHAR_HIGH_T : std_logic_vector(7 downto 0) := x"54";
	constant CHAR_HIGH_U : std_logic_vector(7 downto 0) := x"55";
	constant CHAR_HIGH_V : std_logic_vector(7 downto 0) := x"56";
	constant CHAR_HIGH_W : std_logic_vector(7 downto 0) := x"57";
	constant CHAR_HIGH_X : std_logic_vector(7 downto 0) := x"58";
	constant CHAR_HIGH_Y : std_logic_vector(7 downto 0) := x"59";
	constant CHAR_HIGH_Z : std_logic_vector(7 downto 0) := x"5A";

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
	
	constant CHAR_BLANK : std_logic_vector(7 downto 0) := x"20";
	constant CHAR_STAR : std_logic_vector(7 downto 0) := x"2A";
	--constant CHAR_KOMMA : std_logic_vector(7 downto 0) := x"2C";
	constant CHAR_DOT : std_logic_vector(7 downto 0) := x"2E";
	constant CHAR_SLASH: std_logic_vector (7 downto 0) := x"2F";
	constant CHAR_COLON: std_logic_vector(7 downto 0) := x"3A";
end package ;

