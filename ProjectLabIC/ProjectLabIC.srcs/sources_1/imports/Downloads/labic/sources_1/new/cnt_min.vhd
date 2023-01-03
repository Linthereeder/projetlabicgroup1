----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/01 12:32:44
-- Design Name: 
-- Module Name: cnt_min - Behavioral
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

entity cnt_min is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_alarm : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           alm_m : out std_logic_vector(5 downto 0);
           carry_flag : out std_logic_vector(1 downto 0)
            );
end cnt_min;
-- time can only be set under the alarm mode
architecture Behavioral of cnt_min is
signal cnt_min : integer := 0;
begin
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if(reset = '1') then
                cnt_min <= 16;
                carry_flag <= "00";
            elsif(en_alarm = '1') then
                if (key_plus_imp = '1') then
                    if(cnt_min = 59) then
                        cnt_min <= 0;
                        carry_flag <= "01";
                    else
                        cnt_min <= cnt_min + 1;
                        carry_flag <= "00";
                    end if;
                elsif (key_minus_imp = '1') then
                    if(cnt_min = 0) then
                        cnt_min <= 59;
                        carry_flag <= "10";
                    else
                        cnt_min <= cnt_min - 1;
                        carry_flag <= "00";
                    end if;
                end if;
            end if;
        end if;
    end process;
    alm_m(5 downto 0) <= std_logic_vector(to_unsigned(cnt_min, 6));
end Behavioral;
