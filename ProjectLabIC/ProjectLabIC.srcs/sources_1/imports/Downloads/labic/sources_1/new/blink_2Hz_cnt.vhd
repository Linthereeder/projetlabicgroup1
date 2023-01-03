----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/01 11:26:26
-- Design Name: 
-- Module Name: blink_2Hz_cnt - Behavioral
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

entity blink_2Hz_cnt is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           one_hHz_pulse : in STD_LOGIC;
           alm_act : in STD_LOGIC;
           snooze_act  :   in STD_LOGIC;
           led_alarm_act :   out STD_LOGIC );
end blink_2Hz_cnt;

architecture Behavioral of blink_2Hz_cnt is
signal cnt : integer := 0;
begin
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if reset = '1' then
                cnt <= 0;
            elsif (alm_act = '1') and (snooze_act = '1') then
                if (cnt = 50) then
                    cnt <= 0;
                elsif one_hHz_pulse = '1' then
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if reset = '1' then
                led_alarm_act <= '0';
            elsif (alm_act = '1') and (snooze_act = '1') then
                if (cnt = 0) then
                    led_alarm_act <= '1';
                elsif (cnt = 25) then
                    led_alarm_act <= '0';
                end if;
            elsif (alm_act = '1') and (snooze_act = '0') then
                led_alarm_act <= '1';
            else 
                led_alarm_act <= '0';
            end if;
        end if;
    end process;




end Behavioral;
