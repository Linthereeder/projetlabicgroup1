----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2022 10:30:03 PM
-- Design Name: 
-- Module Name: timer3s - Behavioral
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

entity timer is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           timeover : out STD_LOGIC);
end timer;

architecture Behavioral of timer is

signal timeout: std_logic := '0';
signal t: integer:= 0;

begin

counting: process(clk)

begin
if(rising_edge(clk)) then 
    if reset = '1' then
        t <= 0;
        timeout <= '0'; 
    else    
        if start = '1' then
            t <= t + 1;
        else 
            t <= 0;
            timeout <= '0';
        end if;
   
        if  t > 30000  then
            timeout <= '1';
            else timeout <= '0';    
            end if;
            
    end if;
end if;

end process counting;

timeover <= timeout;

end Behavioral;
