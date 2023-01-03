----------------------------------------------------------------------------------
-- TUM
-- Engineer: Haoyuan Liu ge49nor
-- 
-- Create Date: 12/15/2022 02:40:03 PM
-- Design Name: 
-- Module Name: bcd_decode - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--since the bcd decode module is only used for once, I didnt bother to optimse it like I did for the bcd converter
entity bcd_decode is
  Port ( input1 : in std_logic_vector(7 downto 0);
         output1: out std_logic_vector(6 downto 0)
          );
end bcd_decode;

architecture Behavioral of bcd_decode is
    signal a0,a1,a2,a3,a4,a5,a6,a7 : unsigned(5 downto 0);    
begin

a1<="000001" when input1(1)='1' else "000000";
a2<="000010" when input1(2)='1' else "000000";
a3<="000100" when input1(3)='1' else "000000";
a4<="000101" when input1(4)='1' else "000000";
a5<="001010" when input1(5)='1' else "000000";
a6<="010100" when input1(6)='1' else "000000";
a7<="101000" when input1(7)='1' else "000000";
output1(6 downto 1)<=std_logic_vector( a1+a2+a3+a4+a5+a6+a7);
output1(0)<= input1(0);
end Behavioral;
