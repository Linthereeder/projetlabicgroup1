----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/04 15:20:27
-- Design Name: 
-- Module Name: alarm_modified_gen - Behavioral
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

entity alarm_modified_gen is
    Port (  clk : in STD_LOGIC;
            alm_modified_rst : in STD_LOGIC;
            alm_modified_cnt : in STD_LOGIC;
            alm_modified_control : in STD_LOGIC;
            alm_modified : out STD_LOGIC
           );
end alarm_modified_gen;

architecture Behavioral of alarm_modified_gen is

begin
    process(clk)
    begin
        if(clk = '1' and clk'event)then
            if(alm_modified_rst = '1')then
                alm_modified <= '0';
            elsif (alm_modified_control = '1') or (alm_modified_cnt = '1') then
                alm_modified <= '1';
            end if;
        end if;
    end process;

end Behavioral;
