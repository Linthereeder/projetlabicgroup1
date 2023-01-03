----------------------------------------------------------------------------------
-- TUM
-- Engineer: Haoyuan Liu ge49nor
-- 
-- Create Date:    18:55:49 04/30/2013 
-- Design Name: 
-- Module Name:    clockMain - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity clock_module is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           en_1K : in  std_logic;
           en_100 : in  std_logic;
           en_10 : in  std_logic;
           en_1 : in  std_logic;
			  
           key_action_imp : in  std_logic;
			  key_action_long : in std_logic;
           key_mode_imp : in  std_logic;
           key_minus_imp : in  std_logic;
           key_plus_imp : in  std_logic;
           key_plus_minus : in  std_logic;
           key_enable : in  std_logic;
			  
           de_set : in  std_logic;
           de_dow : in  std_logic_vector (2 downto 0);
           de_day : in  std_logic_vector (5 downto 0);
           de_month : in  std_logic_vector (4 downto 0);
           de_year : in  std_logic_vector (7 downto 0);
           de_hour : in  std_logic_vector (5 downto 0);
           de_min : in  std_logic_vector (6 downto 0);
			  
           led_alarm_act : out  std_logic;
           led_alarm_ring : out  std_logic;
           led_countdown_act : out  std_logic;
           led_countdown_ring : out  std_logic;
           led_switch_act : out  std_logic;
           led_switch_on : out  std_logic;
			  
			  lcd_en : out std_logic;
			  lcd_rw : out std_logic;
			  lcd_rs : out std_logic;
			  lcd_data : out std_logic_vector(7 downto 0)
			  
			  -- OLED signal only for development
			  --oled_en : out std_logic;internal_year
			  --oled_dc : out std_logic;
			  --oled_data : out std_logic;
			  --oled_reset : out std_logic;
			  --oled_vdd : out std_logic;
			  --oled_vbat : out std_logic
		);
end clock_module;

architecture Behavioral of clock_module is
signal bin_dow, bin_dow_reg:  STD_LOGIC_VECTOR ( 2 downto 0 ) ;

signal bin_day,bin_month,bin_year,bin_hour,bin_min: STD_LOGIC_VECTOR ( 6 downto 0 );
signal bin_day_reg,bin_month_reg,bin_year_reg,bin_hour_reg,bin_min_reg: STD_LOGIC_VECTOR ( 6 downto 0 );	
signal bin_set:  STD_LOGIC;
signal o_hour ,o_min ,o_second ,o_year, o_month, o_day: STD_LOGIC_VECTOR ( 6 downto 0 );
signal o_hour_d ,o_min_d ,o_second_d ,o_year_d, o_month_d, o_day_d: STD_LOGIC_VECTOR ( 7 downto 0 );	
signal lcd_dcf: std_logic;
signal o_dow : STD_LOGIC_VECTOR(2 downto 0);
signal o_valid: std_logic; 

signal timedisplay_en , datedisplay_en  ,  alarmclock_en , timeswitchon_en  ,  timwswitchoff_en   , countdown_en  ,   stopwatch_en  , timeswitch_active  ,  countdown_active : std_logic; 
signal lcd_stopwatch_act, en_stp: std_logic;
signal cs_o ,ss_o, mm_o, hh_o : STD_LOGIC_vector(7 Downto 0);
signal cs ,ss, mm, hh : STD_LOGIC_vector(6 Downto 0);

signal  snooze_act, cur_s,  cur_m, cur_h,  one_hHz_pulse: std_logic;

signal alm_m :  std_logic_vector(5 downto 0);
signal     alm_h : std_logic_vector(4 downto 0);
signal alm_m_o, alm_h_o : STD_LOGIC_vector(7 Downto 0);
begin

--Haoyuan Liu, part TIME and DATE ,start 
--convert bcd to binary--
decode_bcd_year:entity work.bcd_decode(Behavioral)
    port map( input1 => de_year,
         output1 => bin_year);

decode_bcd_month:entity work.bcd_decode(Behavioral)
    port map( input1 => b"000" & de_month,
         output1 => bin_month);

decode_bcd_day:entity work.bcd_decode(Behavioral)
    port map( input1 => b"00" & de_day,
         output1 => bin_day);

decode_bcd_hour:entity work.bcd_decode(Behavioral)
    port map( input1 => b"00" & de_hour,
         output1 => bin_hour);

decode_bcd_min:entity work.bcd_decode(Behavioral)
    port map( input1 => b"0" & de_min,
         output1 => bin_min);

bin_dow<=de_dow;
                    
-- give converter enough time to do conversion, also stablize the output--
reg_bin_val: process(clk)
begin 
if rising_edge(clk) then 
    if de_set='1' then
        bin_set<='1';
        bin_day_reg<=bin_day;
        bin_month_reg<=bin_month;
        bin_year_reg<=bin_year;
        bin_hour_reg<=bin_hour;
        bin_min_reg<=bin_min;
        bin_dow_reg<=bin_dow;
    else
        bin_set<='0';
    end if;
 end if;           
 end process;   
--time and date--
TimeDate:entity work.time_date(Behavioral)
    port map(
    
        de_set => '0', 
        de_dow => bin_dow_reg,
        de_day => bin_day_reg,
        de_month => bin_month_reg,
        de_year => bin_year_reg,
        de_hour => bin_hour_reg,
        de_min => bin_min_reg,
        clk=> clk,
        reset_extern=> reset,
        
        en_1k=> en_1k ,
        
        o_hour =>   o_hour,
        o_min =>  o_min,
        o_second=> o_second ,
        o_year => o_year ,
        o_month=> o_month ,
        o_day =>  o_day,
        lcd_dcf=> lcd_dcf ,
        o_dow => o_dow ,
        o_valid=> o_valid ,
        o_second_d=> o_second_d ,
        o_min_d=> o_min_d ,
        o_day_d=> o_day_d ,
        o_hour_d=> o_hour_d ,
        o_month_d=> o_month_d ,
        o_year_d=> o_year_d 
       
        );
--convert bin output to bcd
               
               
                                          
--Haoyuan Liu, part TIME and DATE ,end 
-- lcd start
--lcd_part: entity work.display (Behavioral)
--port map(
--           clk => clk,
--           rst  => reset,
--           en_date  => datedisplay_en,
--           en_alarm  => alarmclock_en,
--           en_switch_on =>timeswitchon_en ,
--           en_switch_off =>timwswitchoff_en ,
--           en_stp => stopwatch_en,
--           en_ctd  => countdown_en,
--           normal_time => o_hour_d & o_min_d & o_second_d,-- hour, minute, second in BCD
--           date => o_month_d & o_day_d & o_year_d,-- month,day,year in BCD
--           dow  => o_dow,
--           dcf_ready  => lcd_dcf ,
--           alarm_time  => alm_h_o & alm_m_o,-- hour, minute
--           alarm_act  => led_alarm_act,
--           alarm_snz =>snooze_act ,
--           stp_time  => hh_o & mm_o & ss_o & cs_o,--hour, minute,second, millisec
--           stp_lap  => lcd_stopwatch_act,
--           ctd_time  =>  (others=>'0'),
--           ctd_act  => countdown_active,      
--           switch_act  => timeswitch_active,
--           switch_on  => (others=>'0'),
--           switch_off  => (others=>'0'),
--           lcd_en  => lcd_en,
--           lcd_rw  => lcd_rw,
--           lcd_rs  =>lcd_rs ,
--           lcd_data  =>lcd_data );
lcd_part: entity work.display (Behavioral)
port map(
           clk => clk,
           reset  => reset,
           en_date  => datedisplay_en,
           en_alarm  => alarmclock_en,
           en_switch_on =>timeswitchon_en ,
           en_switch_off =>timwswitchoff_en ,
           en_stop => stopwatch_en,
           en_countdown  => countdown_en,
           current_time => o_hour_d & o_min_d & o_second_d,-- hour, minute, second in BCD
           current_date => o_month_d & o_day_d & o_year_d,-- month,day,year in BCD
           current_dow  => o_dow,
           dcf_valid  => lcd_dcf ,
           alarm_time  => alm_h_o & alm_m_o,-- hour, minute
           alarm_active  => led_alarm_act,
           alarm_snooze =>snooze_act ,
           stop_time  => hh_o & mm_o & ss_o & cs_o,--hour, minute,second, millisec
           stop_lap  => lcd_stopwatch_act,
           countdown_time  =>  (others=>'0'),
           countdown_active  => countdown_active,      
           switch_active  => timeswitch_active,
           switch_on_time  => (others=>'0'),
           switch_off_time  => (others=>'0'),
           lcd_en  => lcd_en,
           lcd_rw  => lcd_rw,
           lcd_rs  =>lcd_rs ,
           lcd_data  =>lcd_data ); 

gfsm1:entity work.gfsm(Behavioral)
    Port map ( CLK  => clk,
           reset => reset,
           key_mode_imp  => key_mode_imp,
           key_action_imp => key_action_imp,
           key_plus_imp  => key_plus_imp,
           key_minus_imp  => key_minus_imp,
           --timeout: in STD_LOGIC;
           --start: out std_logic;
           timedisplay_en  => timedisplay_en,
           datedisplay_en => datedisplay_en,
           alarmclock_en  => alarmclock_en,
           timeswitchon_en => timeswitchon_en,
           timwswitchoff_en  => timwswitchoff_en,
           countdown_en =>countdown_en ,
           stopwatch_en => stopwatch_en,
           timeswitch_active  => timeswitch_active,
           countdown_active  =>countdown_active 
           );
 

stop_watch: Entity work.stopwatch (Behavioral)
	Port map (
		clk  => clk,
		en_100  => en_100,
		en_stp  => stopwatch_en,  --- fsm_stopwatch_start  
		reset  => reset,
		key_plus_imp  => key_plus_imp,
		key_minus_imp  => key_minus_imp,
		key_action_imp  => key_action_imp,
		lcd_stopwatch_act => lcd_stopwatch_act,
		cs  => cs,
		ss => ss,
		mm  => mm,
		hh  => hh
	);
	
convert_cs: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => cs,
                decimal_out=> cs_o);
                
convert_ss: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => ss,
                decimal_out=> ss_o);
convert_mm: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => mm,
                decimal_out=> mm_o);                
convert_hh: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => hh,
                decimal_out=> hh_o);

alarm_clock1:  entity work.alarm_clock(Behavioral)
    port map (   clk  => clk,
            reset  => reset ,
            key_minus_imp=> key_minus_imp,
            key_plus_imp   => key_plus_imp,
            key_act_long  => key_action_long,
            key_act_short   => key_action_imp,
            en_alarm   => alarmclock_en,
            cur_s   => o_second(5 downto 0),
            cur_m   => o_month(5 downto 0),
            cur_h   => o_hour(4 downto 0),
           
            one_hHz_pulse   => en_100,
            led_alarm_ring   => led_alarm_ring,
            alm_m  => alm_m,
            alm_h  => alm_h,
            led_alarm_act  => led_alarm_act,
            snooze_act  => snooze_act
           );
           
alm_m1: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => b"0" & alm_m,
                decimal_out=> alm_m_o);
                                
alm_h1: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => b"00" & alm_h,
                decimal_out=> alm_h_o);          
end Behavioral;           