----------------------------------------------------------------------------------
-- TUM
-- Engineer: Haoyuan Liu ge49nor
--
-- Create Date: 11/03/2022 01:05:23 PM
-- Design Name:
-- Module Name: time_date - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_date is
    port (
    --actually the de_set should be bin_set, they are all binary instead of bcd
        de_set : in STD_LOGIC ;
        de_dow : in STD_LOGIC_VECTOR ( 2 downto 0 ) ;
        de_day : in STD_LOGIC_VECTOR ( 6 downto 0 ) ;
        de_month : in STD_LOGIC_VECTOR ( 6 downto 0 ) ;
        de_year : in STD_LOGIC_VECTOR ( 6 downto 0 ) ;
        de_hour : in STD_LOGIC_VECTOR ( 6 downto 0 ) ;
        de_min : in STD_LOGIC_VECTOR ( 6 downto 0  ) ;
        clk: in std_logic;
        reset_extern: in std_logic;

        en_1k: in std_logic;
        
        o_hour : out STD_LOGIC_VECTOR(6 downto 0); --output in binary
        o_min : out STD_LOGIC_VECTOR(6 downto 0); 
        o_second : out STD_LOGIC_VECTOR (6 downto 0); 
        o_year : out STD_LOGIC_VECTOR(6 downto 0); 
        o_month : out STD_LOGIC_VECTOR(6 downto 0); 
        o_day : out STD_LOGIC_VECTOR(6 downto 0); 
        lcd_dcf: out std_logic;
        o_dow : out STD_LOGIC_VECTOR(2 downto 0);
        o_valid: out std_logic;--used for bcd converter
        
        o_second_d: out STD_LOGIC_VECTOR(7 downto 0);--output in bcd
        o_min_d: out STD_LOGIC_VECTOR(7 downto 0);
        o_day_d: out STD_LOGIC_VECTOR(7 downto 0);
        o_hour_d: out STD_LOGIC_VECTOR(7 downto 0);
        o_month_d: out STD_LOGIC_VECTOR(7 downto 0);
        o_year_d: out STD_LOGIC_VECTOR(7 downto 0)
        );
end entity;
architecture Behavioral of time_date is
signal        internal_hour,internal_hour_s :  unsigned(6 downto 0); 
signal        internal_min,internal_min_s :  unsigned(6 downto 0); 
signal        internal_second,internal_second_s :  unsigned (6 downto 0); 
signal        internal_year,internal_year_s :  unsigned(6 downto 0); 
signal        internal_month,internal_month_s :  unsigned(6 downto 0); 
signal        internal_day,calendar_out,internal_day_s :  unsigned(6 downto 0); 
signal        internal_lcd_dcf:  std_logic;
signal        internal_dow,internal_dow_s :  unsigned(2 downto 0);
signal        internal_set: std_logic;
signal        internal_MSEC,internal_MSEC_s: unsigned( 9 downto 0);
type          MY_STATE is (INIT, SEC, MIN, HOUR, DAY,MONTH, YEAR,WAIT_CLOCK);
signal        current_state, next_state : MY_STATE;  
signal        rst: std_logic;

signal        lcd_dcf_reg: std_logic;
signal        dcf_counter: unsigned( 2 downto 0); 
signal        MSEC_EN,min_en,sec_en,hour_en,day_en,month_en,year_en,dow_en,out_valid: std_logic;
signal        MSEC_EN_s,min_en_s,sec_en_s,hour_en_s,day_en_s,month_en_s,year_en_s,dow_en_s,out_valid_s: std_logic;
signal       internal_second_d_s, internal_min_d_s, internal_day_d_s, internal_hour_d_s, internal_month_d_s, internal_year_d_s: STD_LOGIC_VECTOR(7 downto 0);
signal       internal_second_d, internal_min_d, internal_day_d, internal_hour_d, internal_month_d, internal_year_d: STD_LOGIC_VECTOR(7 downto 0);
begin
rst<= reset_extern or de_set;

judge_logic:entity work.CALENDAR(Behavioral)--how many days in a month. leap year or not 
 port map (
   clk=>clk,
   de_day=> calendar_out,
   de_month=> std_logic_vector(internal_month),
   de_year=> std_logic_vector(internal_year)
    );
    
    o_hour<=STD_LOGIC_VECTOR(internal_hour_s);
    o_min<=STD_LOGIC_VECTOR(internal_min_s);
    o_second<=STD_LOGIC_VECTOR(internal_second_s);
    o_year<=STD_LOGIC_VECTOR(internal_year_s);
    o_month<=STD_LOGIC_VECTOR(internal_month_s);
    o_day<=STD_LOGIC_VECTOR(internal_day_s);
    o_dow<=STD_LOGIC_VECTOR(internal_dow_s); 
    
    o_hour_d<= internal_hour_d_s;
    o_min_d<= internal_min_d_s;
    o_second_d<= internal_second_d_s;
    o_year_d<= internal_year_d_s;
    o_month_d<= internal_month_d_s;
    o_day_d<= internal_day_d_s;
 

convert_sec: entity work.bcd_converter_opt(Behavioral) --bcd converter logic
    port map ( binary_in => std_logic_vector(internal_second),
                decimal_out=> internal_second_d);
                
convert_min: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => std_logic_vector(internal_min),
                decimal_out=> internal_min_d);
convert_day: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => std_logic_vector(internal_day),
                decimal_out=> internal_day_d);                
convert_hour: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => std_logic_vector(internal_hour),
                decimal_out=> internal_hour_d);
convert_month: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => std_logic_vector(internal_month),
                decimal_out=> internal_month_d);
convert_year: entity work.bcd_converter_opt(Behavioral)
    port map ( binary_in => std_logic_vector(internal_year),
                decimal_out=> internal_year_d);  
o_valid<= out_valid_s;    



to_lcd: process(clk)
begin
     if rising_edge(clk) then --reg the output, avoid invalid value
        if out_valid_s='1' then 
            internal_hour_s<=internal_hour;
            internal_min_s<=internal_min;
            internal_second_s<=internal_second;
            internal_year_s<=internal_year;
--            internal_Msec_s<=internal_msec;
            internal_month_s<=internal_month;
            internal_day_s<=internal_day;
            internal_dow_s<=internal_dow;
 
            internal_second_d_s<=internal_second_d;
            internal_min_d_s<= internal_min_d;
            internal_day_d_s<=internal_day_d;
            internal_hour_d_s<=internal_hour_d;
            internal_month_d_s<=internal_month_d;
            internal_year_d_s<=internal_year_d;
         else 
 
            internal_hour_s<=internal_hour_s;--keep the old value when not valid
            internal_min_s<=internal_min_s;
            internal_second_s<=internal_second_s;
            internal_year_s<=internal_year_s;
--            internal_Msec_s<=internal_Msec_s;
            internal_month_s<=internal_month_s;
            internal_day_s<=internal_day_s;
            internal_dow_s<=internal_dow_s;
            
            internal_second_d_s<=internal_second_d_s;
            internal_min_d_s<= internal_min_d_s;
            internal_day_d_s<=internal_day_d_s;
            internal_hour_d_s<=internal_hour_d_s;
            internal_month_d_s<=internal_month_d_s;
            internal_year_d_s<=internal_year_d_s;
         end if;
       end if;
 end process;
-- use look ahead buffer to reg the output, reduce jitter.            
out_reg: process(clk)
begin
    if rising_edge(clk) then 
        if rst='1' then 
             min_en_s<='0';
             sec_en_s<='0';
             
             hour_en_s<='0';
             day_en_s<='0';
             month_en_s<='0';
             year_en_s<='0';
             out_valid_s<='0';
 
        else
            min_en_s<=min_en;
             sec_en_s<=sec_en;
             
             hour_en_s<=hour_en;
             day_en_s<=day_en;
             month_en_s<=month_en;
             year_en_s<=year_en;
             out_valid_s<=out_valid;
 
        end if;
        ---
    end if;
end process;

proc_state_reg: process(clk)
begin
   if rising_edge(clk) then
        if rst='1' then
            current_state<=INIT;
        else
            current_state<=next_state;
        end if;
    end if;    
end process;

proc_nsl: process(all)
begin    
    next_state<=current_state;
    case (current_state) is  
        when INIT =>
            if internal_MSEC >=  999 then 
                next_state<= SEC;
            end if;
        
        when SEC =>
            if internal_second >=  59 then 
                next_state<= MIN;
            else 
                next_state<= WAIT_CLOCK;    
            end if;                            
        when MIN =>
            if internal_min >=  59 then 
                next_state<= HOUR;
            else 
                next_state<= WAIT_CLOCK;    
            end if;                                                   
        when HOUR=>
            if internal_hour >= 23 then 
                 next_state<= DAY;
            else 
                next_state<= WAIT_CLOCK;    
            end if; 
        when DAY=>
            if internal_day >= calendar_out then 
                 next_state<= MONTH;
            else 
                next_state<= WAIT_CLOCK;    
            end if;         
        when MONTH=>
            if internal_hour >= 12 then 
                 next_state<= YEAR;
            else 
                next_state<= WAIT_CLOCK;    
            end if;
        when YEAR=>
             next_state<= WAIT_CLOCK;
             
        when WAIT_CLOCK=> --this state is to avoid INIT entering the SEC state again,becasue MSEC counter still = 999 after processing . 
              if not(internal_MSEC >=  999) then 
                   next_state<= INIT;
              end if; 
        when others=>       
             next_state<= INIT;
    end case;
end process;              

proc_out: process(next_state)
begin
out_valid<='0';min_en<='0';sec_en<='0';hour_en<='0';day_en<='0';month_en<='0';year_en<='0'; 
    case(next_state) is 
    
        when INIT =>
            out_valid<='1';
 
        when SEC =>
            SEC_EN<='1';
        when MIN =>
            MIN_EN<='1'; 
        when HOUR =>
            MIN_EN<='1'; 
        when DAY =>
            DAY_EN<='1'; 
        when MONTH =>
            MONTH_EN<='1';
        when year =>
            year_en <='1';
            
        when wait_clock=>
            
        end case;
end process;
-- FSM end 

-- counters are all modulo counter        
 proc_msec: process(clk )
 begin
    if rising_edge(clk) then
      if rst='1' then 
          internal_msec<= (others=>'0');                     
      elsif en_1k='1' then
        if internal_msec<999 then 
               internal_msec<= internal_msec+1;
        else 
               internal_msec<= (others=>'0');
        end if;
       end if;
     end if;                                         
end process; 
      
 proc_sec: process(clk )
 begin
    if rising_edge(clk) then
      if rst='1' then 
          internal_second<= (others=>'0');                     
      elsif sec_en_s='1' then 
          if internal_second<59 then 
               internal_second<= internal_second+1;
          else 
               internal_second<= (others=>'0');
           end if;
       end if;
     end if;                                          
end process; 

 proc_min: process(clk )
 begin
      if rising_edge(clk) then
      if rst='1' then 
         if de_set='1' then  
              internal_min  <= unsigned(de_min);
          else
              internal_min<= (others=>'0');
          end if;                
      elsif min_en_s='1' then 
          if internal_min<59 then 
               internal_min<= internal_min+1;
          else 
               internal_min<= (others=>'0');
           end if;
         end if;
       end if;                                          
end process; 

 proc_hour: process(clk)
 begin
      if rising_edge(clk) then
      if rst='1' then 
         if de_set='1' then  
              internal_hour  <= unsigned(de_hour);
          else
              internal_hour<= (others=>'0');
          end if;                
      elsif hour_en_s='1' then 
          if internal_hour<23 then 
               internal_hour<= internal_hour+1;
          else 
               internal_hour<= (others=>'0');
           end if;
         end if;
       end if;                                          
end process; 

 proc_day: process(clk)
 begin
      if rising_edge(clk) then
      if rst='1' then 
         if de_set='1' then  
              internal_day  <= unsigned(de_day);
          else
              internal_day<= b"0000001";
          end if;                
      elsif day_en_s='1' then 
          if internal_day<calendar_out then 
               internal_day<= internal_day+1;
          else 
               internal_day<= b"0000001";
           end if;
         end if;
       end if;                                          
end process; 

 proc_month: process(clk)
 begin
      if rising_edge(clk) then
      if rst='1' then 
         if de_set='1' then  
              internal_month  <= unsigned(de_month);
          else
              internal_month<= b"0000001";
          end if;                
      elsif month_en_s='1' then 
          if internal_month<12 then 
               internal_month<= internal_month+1;
          else 
               internal_month<= b"0000001";
           end if;
         end if;
       end if;                                          
end process; 

 proc_year: process(clk)
 begin
      if rising_edge(clk) then
          if rst='1' then 
              if de_set='1' then  
                  internal_year  <= unsigned(de_year);
              else
                  internal_year  <=(others=>'0');
              end if;                
          elsif year_en_s='1' then 
              if internal_year<99 then  
                   internal_year<= internal_year+1;--when year > 99, output of bcd converter will be undefined. 
              else 
                    internal_year<= b"0000000";     
              end if; 
          end if;
       end if;
 end process;    
        
 proc_dow: process(clk)  
begin
      if rising_edge(clk) then
      if rst='1' then 
         if de_set='1' then  
              internal_dow <= unsigned(de_dow);
          else
              internal_dow<= b"001";
          end if;                
      elsif day_en_s='1' then 
          if internal_dow<7 then 
               internal_dow<= internal_dow+1;
          else 
               internal_dow<= b"001";
           end if;
         end if;
       end if;                                          
end process; 

dcf_reg : process(all)--dcf will be high for 3 sec after de_set
begin
    if rst='1' then
        dcf_counter<=(others=>'0'); 
         if de_set='1' then 
            lcd_dcf_reg<='1';
         else
            lcd_dcf_reg<='0';  
         end if;
    elsif sec_en_s = '1' then 
           if dcf_counter< 3 then 
            dcf_counter<=  dcf_counter+1;
           else
            lcd_dcf_reg<='0';  
           end if;
     end if;            
end process;
  lcd_dcf<=lcd_dcf_reg;
end Behavioral;
