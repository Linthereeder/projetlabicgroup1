----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/01 11:26:26
-- Design Name: 
-- Module Name: one_min_cnt - Behavioral
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

entity one_min_cnt is
    Port (  clk : in STD_LOGIC;
            one_min_rst : in STD_LOGIC;
            one_min_en : in STD_LOGIC;
            one_hHz_pulse : in STD_LOGIC;
            one_min_flag : out STD_LOGIC
        );
end one_min_cnt;

architecture Behavioral of one_min_cnt is
signal cnt : integer := 0;
begin
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if one_min_rst = '1' then
                cnt <= 0;
                one_min_flag <= '0';
            else 
                if(cnt > 5999 ) then
                    cnt <= 0;
                    one_min_flag <= '1';
                elsif (one_min_en = '1') and (one_hHz_pulse = '1') then
                    cnt <= cnt +1;
                else
                    one_min_flag <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
