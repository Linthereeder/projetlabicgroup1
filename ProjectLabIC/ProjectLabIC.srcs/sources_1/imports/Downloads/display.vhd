----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:21:38 05/02/2013 
-- Design Name: 
-- Module Name:    display - Behavioral 
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
use work.charLib.all;

entity display is
    Port ( clk : in  std_logic;
           reset : in  std_logic;
           current_time : in  std_logic_vector(23 downto 0); -- bcd: hhhh hhhh mmmm mmmm ssss ssss
			  current_date : in  std_logic_vector(23 downto 0); -- bcd:yyyy yyyy mmmm mmmm dddd dddd
			  current_dow : in std_logic_vector(2 downto 0);
			  dcf_valid : in std_logic;
			  alarm_time : in std_logic_vector(15 downto 0); --bcd: hhhh hhhh mmmm mmmm
			  alarm_active : in std_logic;
			  alarm_snooze : in std_logic;
			  switch_on_time : in std_logic_vector(15 downto 0); --bcd: hhhh hhhh mmmm mmmm
			  switch_off_time : in std_logic_vector(15 downto 0); --bcd: hhhh hhhh mmmm mmmm
			  switch_active : in std_logic;
			  countdown_time : in std_logic_vector(15 downto 0); --bcd: hhhh hhhh mmmm mmmm
			  countdown_active : in std_logic;
			  stop_time : in std_logic_vector(31 downto 0); -- bcd: hhhh hhhh mmmm mmmm ssss ssss mmmm mmmm
			  stop_lap : in std_logic;
			  en_date : in std_logic;
           en_alarm : in  std_logic;
           en_switch_on : in  std_logic;
           en_switch_off : in  std_logic;
           en_stop : in  std_logic;
           en_countdown : in  std_logic;
			  --oled_en : out std_logic;
			  --oled_dc : out std_logic;
			  --oled_data : out std_logic;
			  --oled_reset : out std_logic;
			  --oled_vdd : out std_logic;
			  --oled_vbat : out std_logic);
			  lcd_en : out std_logic;
			  lcd_rw : out std_logic;
			  lcd_rs : out std_logic;
			  lcd_data : out std_logic_vector(7 downto 0));
			  
end display;

architecture Behavioral of display is

	type t_text_dow is array(0 to 2) of std_logic_vector(7 downto 0);
	signal current_text : t_text;
	signal current_text_dow : t_text_dow;
	
begin

	-- OLED driver
	--oled : entity work.oled
	--	port map(
	--		clk => clk,
	--		reset => reset,
	--		text => current_text,
	--		spi_en => oled_en,
	--		spi_dc => oled_dc,
	--		spi_data => oled_data,
	--		oled_reset => oled_reset,
	--		oled_vdd => oled_vdd,
	--		oled_vbat => oled_vbat
	--	);
	
	-- LCD driver
	lcd : entity work.lcd
	 port map(
		clk => clk,
		reset => reset,
		text => current_text,
		lcd_en => lcd_en,
		lcd_rw => lcd_rw,
		lcd_rs => lcd_rs,
		lcd_data => lcd_data
	);
		
	dow_gen : process(current_dow)
	begin
		case current_dow is
			when "001" => current_text_dow <= (CHAR_UP_M, CHAR_LOW_O, CHAR_LOW_N);	-- Mon
			when "010" => current_text_dow <= (CHAR_UP_T, CHAR_LOW_U, CHAR_LOW_E);	-- Tue
			when "011" => current_text_dow <= (CHAR_UP_W, CHAR_LOW_E, CHAR_LOW_D);	-- Wed
			when "100" => current_text_dow <= (CHAR_UP_T, CHAR_LOW_H, CHAR_LOW_U);	-- Thu
			when "101" => current_text_dow <= (CHAR_UP_F, CHAR_LOW_R, CHAR_LOW_I);	-- Fri
			when "110" => current_text_dow <= (CHAR_UP_S, CHAR_LOW_A, CHAR_LOW_T);	-- Sat
			when "111" => current_text_dow <= (CHAR_UP_S, CHAR_LOW_U, CHAR_LOW_N);	-- Sun
			when others => current_text_dow <= (CHAR_UP_E, CHAR_UP_R, CHAR_UP_R);	-- ERR
		end case;
	end process;

	text_gen : process(current_time, current_date, current_text_dow, dcf_valid,
		alarm_time, alarm_active, alarm_snooze,
		switch_on_time, switch_off_time, switch_active,
		countdown_time, countdown_active,
		stop_time, stop_lap,
		en_date, en_alarm, en_switch_off, en_switch_on, en_stop, en_countdown)
	begin
		-- Set every bits to blank before making any changes
		for line in 0 to 3 loop
			for char in 0 to 19 loop
				current_text(line)(char) <= CHAR_SPACE;
			end loop;
		end loop;
		
		-- Flags
		current_text(1)(0) <= CHAR_UP_A;
		if alarm_active='1' then
			if alarm_snooze='1' then
				current_text(2)(0) <= CHAR_UP_Z;
			else
				current_text(2)(0) <= CHAR_STAR;
			end if;
		end if;

		current_text(1)(19) <= CHAR_UP_S;
		if switch_active='1' then
			current_text(2)(19) <= CHAR_STAR;
		end if;

		
		if en_switch_off='0' and en_switch_on='0' then
			-- Time
			current_text(0)(7) <= CHAR_UP_T;
			current_text(0)(8) <= CHAR_LOW_I;
			current_text(0)(9) <= CHAR_LOW_M;
			current_text(0)(10) <= CHAR_LOW_E;
			current_text(0)(11) <= CHAR_DBL_POINT;
			
			current_text(1)(5) <= x"3" & current_time(23 downto 20);
			current_text(1)(6) <= x"3" & current_time(19 downto 16);
			current_text(1)(7) <= CHAR_DBL_POINT;
			current_text(1)(8) <= x"3" & current_time(15 downto 12);
			current_text(1)(9) <= x"3" & current_time(11 downto 8);
			current_text(1)(10) <= CHAR_DBL_POINT;
			current_text(1)(11) <= x"3" & current_time(7 downto 4);
			current_text(1)(12) <= x"3" & current_time(3 downto 0);
			
			if dcf_valid='1' then
				current_text(0)(15) <= CHAR_UP_D;
				current_text(0)(16) <= CHAR_UP_C;
				current_text(0)(17) <= CHAR_UP_F;
			end if;
		else
			-- Switch
			current_text(0)(8) <= CHAR_UP_O;
			current_text(0)(9) <= CHAR_LOW_N;
			current_text(0)(10) <= CHAR_DBL_POINT;
			
			current_text(1)(8) <= x"3" & switch_on_time(15 downto 12);
			current_text(1)(9) <= x"3" & switch_on_time(11 downto 8);
			current_text(1)(10) <= CHAR_DBL_POINT;
			current_text(1)(11) <= x"3" & switch_on_time(7 downto 4);
			current_text(1)(12) <= x"3" & switch_on_time(3 downto 0);

			current_text(2)(8) <= CHAR_UP_O;
			current_text(2)(9) <= CHAR_LOW_F;
			current_text(2)(10) <= CHAR_LOW_F;
			current_text(2)(11) <= CHAR_DBL_POINT;

			current_text(3)(8) <= x"3" & switch_off_time(15 downto 12);
			current_text(3)(9) <= x"3" & switch_off_time(11 downto 8);
			current_text(3)(10) <= CHAR_DBL_POINT;
			current_text(3)(11) <= x"3" & switch_off_time(7 downto 4);
			current_text(3)(12) <= x"3" & switch_off_time(3 downto 0);
			
			if en_switch_on='1' then
				current_text(1)(6) <= CHAR_STAR;
			elsif en_switch_off='1' then
				current_text(3)(6) <= CHAR_STAR;
			end if;
		end if;
		
		if en_date='1' then
			-- Date
			current_text(2)(7) <= CHAR_UP_D;
			current_text(2)(8) <= CHAR_LOW_A;
			current_text(2)(9) <= CHAR_LOW_T;
			current_text(2)(10) <= CHAR_LOW_E;
			current_text(2)(11) <= CHAR_DBL_POINT;
			
			current_text(3)(4) <= current_text_dow(0);
			current_text(3)(5) <= current_text_dow(1);
			current_text(3)(6) <= current_text_dow(2);
			current_text(3)(8) <= x"3" & current_date(7 downto 4);
			current_text(3)(9) <= x"3" & current_date(3 downto 0);
			current_text(3)(10) <= CHAR_POINT;
			current_text(3)(11) <= x"3" & current_date(15 downto 12);
			current_text(3)(12) <= x"3" & current_date(11 downto 8);
			current_text(3)(13) <= CHAR_POINT;
			current_text(3)(14) <= x"3" & current_date(23 downto 20);
			current_text(3)(15) <= x"3" & current_date(19 downto 16);
			
		elsif en_alarm='1' then
			--Alarm
			current_text(2)(6) <= CHAR_UP_A;
			current_text(2)(7) <= CHAR_LOW_L;
			current_text(2)(8) <= CHAR_LOW_A;
			current_text(2)(9) <= CHAR_LOW_R;
			current_text(2)(10) <= CHAR_LOW_M;
			current_text(2)(11) <= CHAR_DBL_POINT;
			
			current_text(3)(7) <= x"3" & alarm_time(15 downto 12);
			current_text(3)(8) <= x"3" & alarm_time(11 downto 8);
			current_text(3)(9) <= CHAR_DBL_POINT;
			current_text(3)(10) <= x"3" & alarm_time(7 downto 4);
			current_text(3)(11) <= x"3" & alarm_time(3 downto 0);
			
		elsif en_countdown='1' then
			-- Countdown Timer
			current_text(2)(7) <= CHAR_UP_T;
			current_text(2)(8) <= CHAR_LOW_I;
			current_text(2)(9) <= CHAR_LOW_M;
			current_text(2)(10) <= CHAR_LOW_E;
			current_text(2)(11) <= CHAR_LOW_R;
			current_text(2)(12) <= CHAR_DBL_POINT;
			
			current_text(3)(7) <= x"3" & countdown_time(15 downto 12);
			current_text(3)(8) <= x"3" & countdown_time(11 downto 8);
			current_text(3)(9) <= CHAR_DBL_POINT;
			current_text(3)(10) <= x"3" & countdown_time(7 downto 4);
			current_text(3)(11) <= x"3" & countdown_time(3 downto 0);
			
			if countdown_active='1' then
				current_text(3)(14) <= CHAR_UP_O;
				current_text(3)(15) <= CHAR_LOW_N;
			else
				current_text(3)(14) <= CHAR_UP_O;
				current_text(3)(15) <= CHAR_LOW_F;
				current_text(3)(16) <= CHAR_LOW_F;
			end if;
			
		elsif en_stop='1' then
			-- Stop Watch
			current_text(2)(4) <= CHAR_UP_S;
			current_text(2)(5) <= CHAR_LOW_T;
			current_text(2)(6) <= CHAR_LOW_O;
			current_text(2)(7) <= CHAR_LOW_P;
			
			current_text(2)(9) <= CHAR_UP_W;
			current_text(2)(10) <= CHAR_LOW_A;
			current_text(2)(11) <= CHAR_LOW_T;
			current_text(2)(12) <= CHAR_LOW_C;
			current_text(2)(13) <= CHAR_LOW_H;
			current_text(2)(14) <= CHAR_DBL_POINT;
			
			current_text(3)(4) <= x"3" & stop_time(31 downto 28); -- 0011 + number
			current_text(3)(5) <= x"3" & stop_time(27 downto 24);
			current_text(3)(6) <= CHAR_DBL_POINT;
			current_text(3)(7) <= x"3" & stop_time(23 downto 20);
			current_text(3)(8) <= x"3" & stop_time(19 downto 16);
			current_text(3)(9) <= CHAR_DBL_POINT;
			current_text(3)(10) <= x"3" & stop_time(15 downto 12);
			current_text(3)(11) <= x"3" & stop_time(11 downto 8);
			current_text(3)(12) <= CHAR_POINT;
			current_text(3)(13) <= x"3" & stop_time(7 downto 4);
			current_text(3)(14) <= x"3" & stop_time(3 downto 0);
			
			if stop_lap='1' then
				current_text(3)(0) <= CHAR_UP_L;
				current_text(3)(1) <= CHAR_LOW_A;
				current_text(3)(2) <= CHAR_LOW_P;
			end if;
		end if;
	end process;
	
end Behavioral;

