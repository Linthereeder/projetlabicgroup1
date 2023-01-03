----------------------------------------------------------------------------------
-- TUM
-- Engineer: Haoyuan Liu ge49nor
-- 
-- Create Date: 11/13/2022 04:12:04 PM
-- Design Name: 
-- Module Name: JUDGE_DATE - Behavioral
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

entity CALENDAR is
 Port ( de_day : out unsigned(6 downto 0) ;
        
        de_month : in std_logic_vector(6 downto 0);
        de_year : in std_logic_vector(6 downto 0);
        
        clk : in std_logic
        );
end CALENDAR;

architecture Behavioral of CALENDAR is
 
constant thirtyone:unsigned(6 downto 0) :=   to_unsigned(31,7) ;
constant thirty:unsigned(6 downto 0) := to_unsigned(30,7) ;
constant twentyeight:unsigned(6 downto 0) := to_unsigned(28,7) ;
constant twentyseven:unsigned(6 downto 0) := to_unsigned(27,7) ;
constant onehundred:std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(100,7) );
 
begin
 
    judge:process(clk)
        begin 
        if rising_edge(clk) then 
            case to_integer(unsigned(de_month)) is 
                when 1 =>
                    de_day<= thirtyone;
                when 2 =>
                    if de_year(1 downto 0)=b"00" then
                       
                            de_day<= twentyeight;
                     else
                            de_day<= twentyseven;  
                     end if;            
                when 3 =>
                    de_day<= thirtyone;
                when 4 =>
                    de_day<= thirty;             
                when 5 =>
                    de_day<= thirtyone;
                when 6 =>
                    de_day<= thirty;
                when 7 =>
                    de_day<= thirtyone;
                when 8 =>
                    de_day<= thirtyone;             
                when 9 =>
                    de_day<= thirty;
                when 10 =>
                    de_day<= thirtyone;
                when 11 =>
                    de_day<= thirty;
                when 12 =>
                    de_day<= thirtyone;             
                 when others=>
                    de_day<= thirtyone;
                end case;
          end if;  
     end process;
                  
end Behavioral;
