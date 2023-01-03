----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/01 12:32:44
-- Design Name: 
-- Module Name: cnt_hour - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_hour is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           carry_flag : in std_logic_vector(1 downto 0);
           alm_h : out std_logic_vector(4 downto 0)
            );
end cnt_hour;
-- time can only be set under the alarm mode
architecture Behavioral of cnt_hour is
signal cnt_hour : integer := 0;
begin
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if(reset = '1') then
                cnt_hour <= 0;
            elsif (carry_flag = "01") then
                if(cnt_hour = 23) then
                    cnt_hour <= 0;
                else
                    cnt_hour <= cnt_hour + 1;
                end if;
            elsif (carry_flag = "10") then
                if(cnt_hour = 0) then
                    cnt_hour <= 23;
                else
                    cnt_hour <= cnt_hour - 1;
                end if;
            end if;
        end if;
    end process;
    alm_h(4 downto 0) <= std_logic_vector(to_unsigned(cnt_hour, 5));
end Behavioral;

