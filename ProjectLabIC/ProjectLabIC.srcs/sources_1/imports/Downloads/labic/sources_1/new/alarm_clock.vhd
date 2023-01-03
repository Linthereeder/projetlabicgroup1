----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/01 13:23:56
-- Design Name: 
-- Module Name: alarm_clock - Behavioral
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

entity alarm_clock is
    Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            key_minus_imp : in STD_LOGIC;
            key_plus_imp : in STD_LOGIC;
            key_act_long : in STD_LOGIC;
            key_act_short : in STD_LOGIC;
            en_alarm : in STD_LOGIC;
            cur_s : in std_logic_vector(5 downto 0);
            cur_m : in std_logic_vector(5 downto 0);
            cur_h : in std_logic_vector(4 downto 0);
            one_hHz_pulse : in STD_LOGIC;
            led_alarm_ring : out STD_LOGIC;
            alm_m : out std_logic_vector(5 downto 0);
            alm_h : out std_logic_vector(4 downto 0);
            led_alarm_act : out STD_LOGIC;
            snooze_act : out STD_LOGIC
            );
end alarm_clock;

architecture Behavioral of alarm_clock is

    COMPONENT control_unit is
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
                --snooze_act_b : out STD_LOGIC
                );
    end COMPONENT;
    
    COMPONENT cnt_min is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_alarm : in STD_LOGIC;
               key_minus_imp : in STD_LOGIC;
               key_plus_imp : in STD_LOGIC;
               alm_m : out std_logic_vector(5 downto 0);
               carry_flag : out std_logic_vector(1 downto 0)
                );
    end COMPONENT;

    COMPONENT blink_2Hz_cnt is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               one_hHz_pulse : in STD_LOGIC;
               alm_act : in STD_LOGIC;
               snooze_act  :   in STD_LOGIC;
               led_alarm_act :   out STD_LOGIC );
    end COMPONENT;

    COMPONENT cnt_hour is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               carry_flag : in std_logic_vector(1 downto 0);
               alm_h : out std_logic_vector(4 downto 0)
                );
    end COMPONENT;

    COMPONENT one_min_cnt is
        Port (  clk : in STD_LOGIC;
                one_min_rst : in STD_LOGIC;
                one_min_en : in STD_LOGIC;
                one_hHz_pulse : in STD_LOGIC;
                one_min_flag : out STD_LOGIC
            );
    end COMPONENT;
    
    signal alm_m_sig : std_logic_vector(5 downto 0);
    signal alm_h_sig : std_logic_vector(4 downto 0);
    signal carry_flag_sig : std_logic_vector(1 downto 0);
    signal one_min_flag_sig, alm_act_sig, one_min_rst_sig, one_min_en_sig, snooze_act_sig : STD_LOGIC;
    begin
    U1: cnt_min Port Map ( 
                clk => clk,
                reset => reset,
                en_alarm => en_alarm,
                key_minus_imp => key_minus_imp,
                key_plus_imp => key_plus_imp,
                alm_m => alm_m_sig,
                carry_flag => carry_flag_sig
                );

    U2: cnt_hour Port Map ( 
                clk => clk,
                reset => reset,
                carry_flag => carry_flag_sig,
                alm_h => alm_h_sig
                );
    U3: control_unit Port Map ( 
                clk => clk,
                reset => reset,
                key_act_long => key_act_long,
                key_act_short => key_act_short,
                one_min_flag => one_min_flag_sig,
                en_alarm => en_alarm,
                alm_m => alm_m_sig,
                alm_h => alm_h_sig,
                cur_s => cur_s,
                cur_m => cur_m,
                cur_h => cur_h,
                led_alarm_ring => led_alarm_ring,
                alm_act => alm_act_sig,
                one_min_rst => one_min_rst_sig,
                one_min_en => one_min_en_sig,
                snooze_act => snooze_act_sig
                --snooze_act_b => snooze_act_b_sig
                );
    U4: one_min_cnt Port Map ( 
                clk => clk,
                one_min_rst => one_min_rst_sig,
                one_min_en => one_min_en_sig,
                one_hHz_pulse => one_hHz_pulse,
                one_min_flag => one_min_flag_sig
                );

    U5: blink_2Hz_cnt Port Map ( 
                clk => clk,
                reset => reset,
                one_hHz_pulse => one_hHz_pulse,
                alm_act => alm_act_sig,
                snooze_act => snooze_act_sig,
                led_alarm_act => led_alarm_act 
                );
    alm_m <= alm_m_sig;
    alm_h <= alm_h_sig;  
    snooze_act <= snooze_act_sig;
end Behavioral;
