----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2022 01:50:32 PM
-- Design Name: 
-- Module Name: gfsm - Behavioral
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

entity gfsm is
    Port ( CLK : in STD_LOGIC;
           reset: in STD_LOGIC;
           key_mode_imp : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           --timeout: in STD_LOGIC;
           --start: out std_logic;
           timedisplay_en : out STD_LOGIC;
           datedisplay_en : out STD_LOGIC;
           alarmclock_en : out STD_LOGIC;
           timeswitchon_en : out STD_LOGIC;
           timwswitchoff_en : out STD_LOGIC;
           countdown_en : out STD_LOGIC;
           stopwatch_en : out STD_LOGIC;
           timeswitch_active : out STD_LOGIC;
           countdown_active : out STD_LOGIC);
end gfsm;

architecture Behavioral of gfsm is



component timer is 

port(
    clk : in STD_LOGIC;
    reset : in STD_LOGIC; 
    start : in STD_LOGIC;
    timeover : out STD_LOGIC
);

end component;


type states is(timedisplay, datedisplay, alarmclock, newalarmclock, timeswitchon, newtimeswitchon, timeswitchoff1, timeswitchoff2, countdownclock, stopwatch);
signal currentstate, nextstate: states;


signal startgfsm: std_logic:= '0';
signal timeupgfsm: std_logic := '0';
signal timeswitchaction : boolean:= false;
signal countdownaction : boolean:= false;


begin


timer3s: timer port map(
                clk => CLK,
                reset => reset,
                start => startgfsm,
                timeover => timeupgfsm);
                


stateregister: process(CLK)

begin

if (rising_edge(CLK)) then
    if reset = '1' then
        currentstate <= timedisplay;
    else
        currentstate <= nextstate;
    end if;
end if;

end process stateregister;
          
nextstateblock: process(currentstate,key_mode_imp,key_action_imp, key_plus_imp,key_minus_imp, timeupgfsm)

begin

case currentstate is
    when timedisplay => 
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= datedisplay;
        elsif key_plus_imp = '1' or key_minus_imp = '1' then
            nextstate <= stopwatch;
        else nextstate <= timedisplay;
        end if;
        
    when datedisplay =>
        --startgfsm <= '1';
        if timeupgfsm = '1' then
           nextstate <= timedisplay;
        elsif key_mode_imp = '1' then
           nextstate <= alarmclock;
        else nextstate <= datedisplay;
        end if;
    
    when alarmclock =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timeswitchon;
        elsif key_plus_imp = '1' or key_minus_imp = '1' or key_action_imp = '1' then
            nextstate <= newalarmclock;
        else nextstate <= alarmclock;
        end if;
    
    when newalarmclock =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timedisplay;
        else nextstate <= newalarmclock;
        end if;
        
    when timeswitchon =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timeswitchoff2;
        elsif key_action_imp = '1' then
            timeswitchaction <= not timeswitchaction;
        elsif key_plus_imp = '1' or key_minus_imp = '1' then
            nextstate <= newtimeswitchon;
        else nextstate <= timeswitchon;
        end if;
        
    when newtimeswitchon =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timeswitchoff1;
        elsif key_action_imp = '1' then
            timeswitchaction <= not timeswitchaction;
        else nextstate <= newtimeswitchon;
        end if;
        
    when timeswitchoff1 =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timedisplay;
        elsif key_action_imp = '1' then
            timeswitchaction <= not timeswitchaction;
        else nextstate <= timeswitchoff1;
        end if;
    
    when timeswitchoff2 =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= countdownclock;
        elsif key_action_imp = '1' then
            timeswitchaction <= not timeswitchaction;
        elsif key_plus_imp = '1' or key_minus_imp = '1' then
            nextstate <= timeswitchoff1;
        else nextstate <= timeswitchoff2;
        end if;
        
    when countdownclock =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timedisplay;
        elsif key_action_imp = '1' then
            countdownaction <= not countdownaction;
        else nextstate <= countdownclock;
        end if;
        
    when stopwatch =>
        --startgfsm <= '0'; --do not activate 3stimer
        if key_mode_imp = '1' then
            nextstate <= timedisplay;
        else nextstate <= stopwatch;
        end if;
        
    end case;
     
end process nextstateblock;

outputblock: process(currentstate, timeswitchaction, countdownaction)

begin

case currentstate is
    when timedisplay =>          
        startgfsm <= '0';
        timedisplay_en <= '1';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
     
    when datedisplay =>
        startgfsm <= '1';        
        timedisplay_en <= '0';
        datedisplay_en <= '1';
        alarmclock_en <= '0';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        
    when stopwatch =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '1';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        
    when alarmclock =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '1';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        
    when newalarmclock =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '1';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        
    when timeswitchon =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '1';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        
    when newtimeswitchon =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '1';
        timwswitchoff_en <= '0';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;

    when timeswitchoff1 =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '1';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        
    when timeswitchoff2 =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '1';
        countdown_en <= '0';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;

    when countdownclock =>          
        startgfsm <= '0';
        timedisplay_en <= '0';
        datedisplay_en <= '0';
        alarmclock_en <= '0';
        timeswitchon_en <= '0';
        timwswitchoff_en <= '0';
        countdown_en <= '1';
        stopwatch_en <= '0';
        if timeswitchaction = true then
            timeswitch_active <= '1';
        else timeswitch_active <= '0';
        end if;
        
        if countdownaction = true then
            countdown_active <= '1';
        else countdown_active <= '0';
        end if;
        

        
end case;

end process outputblock;        


end Behavioral;
