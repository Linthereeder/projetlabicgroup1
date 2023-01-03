----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 17:17:50
-- Design Name: 
-- Module Name: gen_new - Behavioral
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
use work.parameters.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gen_new is
    Port (en_date: in std_logic ;
          en_alarm: in std_logic ;
          en_switch_on: in std_logic ;
          en_switch_off: in std_logic;
          en_stp: in std_logic ;
          en_ctd: in std_logic ;
          normal_time: in std_logic_vector (23 downto 0);
          date: in std_logic_vector (23 downto 0);
          dow: in std_logic_vector (2 downto 0);
          dcf_ready: in std_logic ;
          alarm_time: in std_logic_vector (15 downto 0);
          alarm_act: in std_logic ;
          alarm_snz: in std_logic ;
          stp_time: in std_logic_vector (31 downto 0);
          stp_lap: in std_logic ;
          ctd_time: in std_logic_vector (23 downto 0);
          ctd_act: in std_logic ;
          sw_on: in std_logic_vector (23 downto 0);
          sw_off: in std_logic_vector (23 downto 0);
          switch_act: in std_logic ;          
          new_char: out char_all);

end gen_new;

architecture Behavioral of gen_new is
    signal new_dow: char_dow ;
begin
    dow_gen : process(dow)
	begin
		case dow is
			when "001" => new_dow <= (CHAR_HIGH_M, CHAR_LOW_O, CHAR_LOW_N);	-- Mon
			when "010" => new_dow <= (CHAR_HIGH_T, CHAR_LOW_U, CHAR_LOW_E);	-- Tue
			when "011" => new_dow <= (CHAR_HIGH_W, CHAR_LOW_E, CHAR_LOW_D);	-- Wed
			when "100" => new_dow <= (CHAR_HIGH_T, CHAR_LOW_H, CHAR_LOW_U);	-- Thu
			when "101" => new_dow <= (CHAR_HIGH_F, CHAR_LOW_R, CHAR_LOW_I);	-- Fri
			when "110" => new_dow <= (CHAR_HIGH_S, CHAR_LOW_A, CHAR_LOW_T);	-- Sat
			when "111" => new_dow <= (CHAR_HIGH_S, CHAR_LOW_U, CHAR_LOW_N);	-- Sun
			when others => new_dow <= (CHAR_HIGH_E, CHAR_HIGH_R, CHAR_HIGH_O);	-- error
		end case;
	end process;
    
    new_text_gen: process(en_date ,en_alarm ,en_switch_on ,en_switch_off , en_ctd ,en_stp, normal_time ,date ,new_dow ,dcf_ready ,alarm_time ,alarm_act ,
                          alarm_snz ,stp_time ,stp_lap ,ctd_time ,ctd_act , sw_on, sw_off, switch_act)
    begin
        
        for row in 0 to 3 loop
			for col in 0 to 19 loop
				new_char(row)(col) <= CHAR_BLANK;
			end loop;
		end loop;
		
		new_char(1)(0) <= CHAR_HIGH_A ;
		new_char(1)(19) <= CHAR_HIGH_S ;
		new_char(1)(7) <= CHAR_COLON ;
		new_char(1)(10) <= CHAR_COLON ;
		
		if alarm_act = '1' then
            if alarm_snz = '1' then
                new_char (2)(0) <= CHAR_HIGH_Z;
            else
                new_char (2)(0) <= CHAR_STAR;
            end if;
		end if;
		if dcf_ready ='1' then
			new_char (0)(15) <= CHAR_HIGH_D;
			new_char (0)(16) <= CHAR_HIGH_C;
			new_char (0)(17) <= CHAR_HIGH_F;
	    end if;
			                      
        if switch_act='1' then
			new_char (2)(19) <= CHAR_STAR;
		end if;
        
        if en_switch_off='0' and en_switch_on='0' then
			new_char (0)(7) <= CHAR_HIGH_T;
			new_char (0)(8) <= CHAR_LOW_I;
			new_char(0)(9) <= CHAR_LOW_M;
			new_char(0)(10) <= CHAR_LOW_E;
			new_char(0)(11) <= CHAR_COLON;
			
			new_char(1)(5) <= x"3"& normal_time(23 downto 20); -- 0101+data in bcd
			new_char(1)(6) <= x"3"& normal_time(19 downto 16);
			new_char(1)(8) <= x"3"& normal_time(15 downto 12);
			new_char(1)(9) <= x"3"& normal_time(11 downto 8);
			new_char(1)(11) <= x"3"& normal_time(7 downto 4);
			new_char(1)(12) <= x"3"& normal_time(3 downto 0);
			
		else
		    if en_switch_on = '1' then
		        new_char(1)(3) <= CHAR_STAR ;
		    elsif en_switch_off = '1' then
		        new_char(3)(4) <= CHAR_STAR ;
		    end if; 
		
		    new_char(0)(8) <= CHAR_HIGH_O ;
		    new_char(0)(9) <= CHAR_LOW_N ;
		    new_char(0)(10) <= CHAR_COLON ;
		    
		    new_char(1)(5)<= x"3"& x"0"; -- set time to 0 
		    new_char(1)(6)<= x"3"& x"0";
		    new_char(1)(8)<= x"3"& x"0"; 
		    new_char(1)(9)<= x"3"& x"0";
		    new_char(1)(11)<= x"3"& x"0";
		    new_char(1)(12)<= x"3"& x"0";
		    
		    new_char(2)(8)<= CHAR_HIGH_O ;
		    new_char(2)(9) <= CHAR_LOW_F ;
		    new_char(2)(10) <= CHAR_LOW_F ;
		    new_char(2)(11) <= CHAR_COLON ;
		    
		    new_char(3)(5)<= x"3"& x"0"; -- set time to 0 
		    new_char(3)(6)<= x"3"& x"0";
		    new_char(3)(7) <= CHAR_COLON ;
		    new_char(3)(8)<= x"3"& x"0"; 
		    new_char(3)(9)<= x"3"& x"0";
		    new_char(3)(10) <= CHAR_COLON ;
		    new_char(3)(11)<= x"3"& x"0";
		    new_char(3)(12)<= x"3"& x"0";
		end if;
		
		if en_date = '1' then 
		    new_char(2)(7) <= CHAR_HIGH_D ;
		    new_char(2)(8) <= CHAR_LOW_A ;
		    new_char(2)(9) <= CHAR_LOW_T ;
		    new_char(2)(10) <= CHAR_LOW_E ;
		    new_char(2)(11) <= CHAR_COLON ;
		    
		    new_char(3)(4) <= new_dow(0);
		    new_char(3)(5) <= new_dow(1);
		    new_char(3)(6) <= new_dow(2);
		    
		    new_char(3)(8) <= x"3" & date(23 downto 20); -- month/day/year
		    new_char(3)(9) <= x"3"& date(19 downto 16);
		    new_char(3)(10) <= CHAR_SLASH ;
			new_char(3)(11) <= x"3"& date(15 downto 12);
			new_char(3)(12) <= x"3"& date(11 downto 8);
			new_char(3)(13) <= CHAR_SLASH ;
			new_char(3)(14) <= x"3"& date(7 downto 4);
			new_char(3)(15) <= x"3"& date(3 downto 0);
			
        elsif en_alarm = '1' then
            new_char(2)(6) <= CHAR_HIGH_A ;
		    new_char(2)(7) <= CHAR_LOW_L ;
		    new_char(2)(8) <= CHAR_LOW_A ;
		    new_char(2)(9) <= CHAR_LOW_R ;
		    new_char(2)(10) <= CHAR_LOW_M ;
		    new_char(2)(11) <= CHAR_COLON ;
            
            new_char(3)(7) <= x"3"& alarm_time(15 downto 12);
            new_char(3)(8) <= x"3"& alarm_time(11 downto 8);
            new_char(3)(9) <= CHAR_COLON ;
            new_char(3)(10) <= x"3"& alarm_time(7 downto 4);
            new_char(3)(11) <= x"3"& alarm_time(3 downto 0);
            
        elsif en_stp = '1' then
            if stp_lap = '1'then 
                new_char(3)(0) <= CHAR_HIGH_L ;
		        new_char(3)(1) <= CHAR_LOW_A ;
		        new_char(3)(2) <= CHAR_LOW_P ;
		    end if;
		        
            new_char(2)(3) <= CHAR_HIGH_S ;
		    new_char(2)(4) <= CHAR_LOW_T ;
		    new_char(2)(5) <= CHAR_LOW_O ;
		    new_char(2)(6) <= CHAR_LOW_P ;
		    
		    new_char(2)(8) <= CHAR_HIGH_W ;
		    new_char(2)(9) <= CHAR_LOW_A ;
		    new_char(2)(10) <= CHAR_LOW_T;
		    new_char(2)(11) <= CHAR_LOW_C ;
		    new_char(2)(12) <= CHAR_LOW_H ;
		    new_char(2)(13) <= CHAR_COLON ;
		    
		    new_char(3)(4) <= x"3"& stp_time(31 downto 28);
		    new_char(3)(5) <= x"3"& stp_time(27 downto 24);
		    new_char(3)(6) <= CHAR_COLON ;
		    new_char(3)(7) <= x"3"& stp_time(23 downto 20);
		    new_char(3)(8) <= x"3"& stp_time(19 downto 16);
		    new_char(3)(9) <= CHAR_COLON ;
		    new_char(3)(10) <= x"3"& stp_time(15 downto 12);
		    new_char(3)(11) <= x"3"& stp_time(11 downto 8);
		    new_char(3)(12) <= CHAR_DOT ;
		    new_char(3)(13) <= x"3"& stp_time(7 downto 4);
		    new_char(3)(14) <= x"3"& stp_time(3 downto 0);
		    
		elsif en_ctd = '1' then
		    if ctd_act = '1' then
		        new_char(3)(14) <= CHAR_HIGH_O ;
		        new_char(3)(15) <= CHAR_LOW_N ;
		    else
		        new_char(3)(14) <= CHAR_HIGH_O ;
		        new_char(3)(15) <= CHAR_LOW_F ;
		        new_char(3)(16) <= CHAR_LOW_F ;
		    end if;
		    
		    new_char(2)(6) <= CHAR_HIGH_T ;
		    new_char(2)(7) <= CHAR_LOW_I ;
		    new_char(2)(8) <= CHAR_LOW_M ;
		    new_char(2)(9) <= CHAR_LOW_E ;
		    new_char(2)(10) <= CHAR_LOW_R ;
		    new_char(2)(11) <= CHAR_COLON ;
		    
		    new_char(3)(5)<= x"3"& x"0"; -- set time to 0 
		    new_char(3)(6)<= x"3"& x"0";
		    new_char(3)(7) <= CHAR_COLON ;
		    new_char(3)(8)<= x"3"& x"0"; 
		    new_char(3)(9)<= x"3"& x"0";
		    new_char(3)(10) <= CHAR_COLON ;
		    new_char(3)(11)<= x"3"& x"0";
		    new_char(3)(12)<= x"3"& x"0";
		    
		end if;
    end process ;
	    
end Behavioral;
