----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/10/31 20:42:25
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            key_act_long : in STD_LOGIC;
            key_act_short : in STD_LOGIC;
            one_min_flag : in STD_LOGIC;
            en_alarm : in STD_LOGIC;
            alm_m : in std_logic_vector(5 downto 0);
            alm_h : in std_logic_vector(4 downto 0);
            cur_s : in std_logic_vector(5 downto 0);
            cur_m : in std_logic_vector(5 downto 0);
            cur_h : in std_logic_vector(4 downto 0);
            led_alarm_ring : out STD_LOGIC;
            alm_act : out STD_LOGIC;
            one_min_rst : out STD_LOGIC;
            one_min_en : out STD_LOGIC;
            snooze_act : out STD_LOGIC
            --snooze_act_b : out STD_LOGIC -- for blink module
            );
end control_unit;
architecture Behavioral of control_unit is
    type states is (Deactive, Active, Ring, Snooze);
    signal st_cur, st_next: states;
    signal out_sig : std_logic_vector(4 downto 0);
begin
    statemem: process(clk,reset)
    begin
        if reset ='1' then
            st_cur <= Deactive;
            --out_sig <= "00100";
        else 
            if clk = '1' and clk'event then
                st_cur <= st_next;
            end if ;
        end if;
    end process statemem;

    inputlogic: process(en_alarm,key_act_long,key_act_short,one_min_flag,alm_m,alm_h,cur_h,cur_m,cur_s,st_cur)
    begin
        case st_cur is
            -- from deactive to active, can only be set under the alarm mode
            -- but from active to ring or from ring to snooze, can happen under the other mode
            when Deactive =>
                            if (en_alarm = '1')  then 
                                if (key_act_short = '1') then
                                    st_next <= Active;
                                else 
                                    st_next <= Deactive;
                                end if ;
                            else 
                                st_next <= Deactive;
                            end if ;
            when Active => if (alm_m = cur_m) and (alm_h = cur_h) and (cur_s = "000000")then
                                st_next <= Ring;
                            elsif (key_act_short = '1') and (en_alarm = '1') then
                                st_next <= Deactive; 
                            else
                                st_next <= Active;
                            end if ; 
                            --the sequence of key_act_short and long should be confirmed later
            when Ring =>   if (one_min_flag = '1') or (key_act_long = '1')then
                                st_next <= Active;
                            elsif (key_act_short = '1') then
                                st_next <= Snooze;
                            else 
                                st_next <= Ring;
                            end if ;
            when Snooze => if(one_min_flag = '1')then
                                st_next <= Ring;
                            else 
                                st_next <= Snooze;
                            end if ;
            when others => st_next <= Deactive;                 
        end case;
    end process inputlogic;

    outputlogic: process(clk)
    begin
        if clk = '1' and clk'event then
            case st_cur is
                when Deactive => if(st_next = Active) then
                                    out_sig <= "01000";
                                else 
                                    out_sig <= "00000";    
                                end if;
                when Active =>  if(st_next = Ring) then
                                    out_sig <= "11110";
                                elsif (st_next = Active) then
                                    out_sig <= "01000";    
                                else 
                                    out_sig <= "00000";    
                                end if;
                when Ring =>    if(st_next = Active) then
                                    out_sig <= "01000";
                                elsif (st_next = Snooze) then
                                    out_sig <= "01111";   
                                elsif (st_next = Ring) then
                                    out_sig <= "11010";
                                else
                                    out_sig <= "00000";    
                                end if;
                when Snooze =>  if(st_next = Ring) then
                                    out_sig <= "11110";
                                elsif (st_next = Snooze) then
                                    out_sig <= "01011";    
                                else 
                                    out_sig <= "00000";    
                                end if;
                when others => out_sig <= "00000";               
            end case;
        end if;

    end process outputlogic;

    out_signal: process(out_sig)
    begin
        led_alarm_ring <= out_sig(4);
        alm_act <= out_sig(3);
        one_min_rst <= out_sig(2);
        one_min_en <= out_sig(1);
        snooze_act <= out_sig(0);
        --snooze_act_b <= out_sig(0);
    end process out_signal;

    

end Behavioral;
