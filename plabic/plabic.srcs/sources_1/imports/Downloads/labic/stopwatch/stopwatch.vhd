----------------------------------------------------------------------------------
-- Module Name: stopwatch                               
----------------------------------------------------------------------------------

Library IEEE;
Use IEEE.STD_LOGIC_1164.All; 
Use IEEE.NUMERIC_STD.All; -- arithmetic functions with Signed or Unsigned values 

 

Entity stopwatch Is
	Port (
		clk : In STD_LOGIC;
		en_100 : In STD_LOGIC;
		en_stp : In STD_LOGIC;  --- fsm_stopwatch_start  
		reset : In STD_LOGIC;
		key_plus_imp : In STD_LOGIC;
		key_minus_imp : In STD_LOGIC;
		key_action_imp : In STD_LOGIC;
		lcd_stopwatch_act: Out STD_LOGIC;
		cs : Out STD_LOGIC_vector(6 Downto 0);
		ss : Out STD_LOGIC_vector(6 Downto 0);
		mm : Out STD_LOGIC_vector(6 Downto 0);
		hh : Out STD_LOGIC_vector(6 Downto 0)
	);
End stopwatch;

Architecture Behavioral Of stopwatch Is

	Component counter_controller
		Port (
			clk : In STD_LOGIC := '0';
			en_stp : In STD_LOGIC := '0';
			sw_reset : In STD_LOGIC := '0';
			key_plus_imp : In STD_LOGIC;
			key_action_imp : In STD_LOGIC := '0';
			counter_ena : Out STD_LOGIC
		);
	End Component counter_controller;

	Component counter_clock
		Port (
			clk : In std_logic;
		    en_100 : In STD_LOGIC:= '0';
			en_stp : In STD_LOGIC;
			sw_reset : In std_logic;
			key_plus_imp : In STD_LOGIC;
			count_ena : In std_logic;
			csec : Out std_logic_vector(6 Downto 0);
			sec : Out std_logic_vector(6 Downto 0);
			min : Out std_logic_vector(6 Downto 0);
			hr : Out std_logic_vector(6 Downto 0)
		);
	End Component counter_clock;
	Component lap
		Port (
			clk : In STD_LOGIC;
			en_stp : In STD_LOGIC;
			sw_reset : In STD_LOGIC;
			key_plus_imp : In STD_LOGIC;
			counter_ena : In STD_LOGIC;
			key_minus_imp : In STD_LOGIC;
			transmitter_ena : Out STD_LOGIC
		);
	End Component lap;

	Component transmitter
		Port (
			clk : In STD_LOGIC;
			en_stp : In STD_LOGIC;
			sw_reset : In STD_LOGIC;
			key_plus_imp : In STD_LOGIC;
			transmitter_ena : In STD_LOGIC;
			in_csec : In std_logic_vector(6 Downto 0);
			in_sec : In std_logic_vector(6 Downto 0);
			in_min : In std_logic_vector(6 Downto 0);
			in_hr : In std_logic_vector(6 Downto 0);
			csec : Out std_logic_vector(6 Downto 0);
			sec : Out std_logic_vector(6 Downto 0);
			min : Out std_logic_vector(6 Downto 0);
			hr : Out std_logic_vector(6 Downto 0)
		);
	End Component transmitter;

	Signal counter_ena_signal : std_logic;
	Signal transmitter_ena_signal : std_logic;
	Signal csec_signal : std_logic_vector(6 Downto 0);
	Signal sec_signal : std_logic_vector(6 Downto 0);
	Signal min_signal : std_logic_vector(6 Downto 0);
	Signal hr_signal : std_logic_vector(6 Downto 0);

Begin
    -- Concurrent assignment
    lcd_stopwatch_act <= not transmitter_ena_signal;
    
	counter_controller_port : counter_controller
	Port Map(
		clk => clk, 
		en_stp => en_stp, 
		sw_reset => reset, 
		key_plus_imp => key_plus_imp, 

		key_action_imp => key_action_imp, 
		counter_ena => counter_ena_signal
	);

	counter_clock_port : counter_clock
	Port Map(
		clk => clk, 
		en_100 => en_100,
		en_stp => en_stp,
		sw_reset => reset, 
		key_plus_imp => key_plus_imp, 
		count_ena => counter_ena_signal, 
		csec => csec_signal, 
		sec => sec_signal, 
		min => min_signal, 
		hr => hr_signal
	);

	lap_port : lap
	Port Map(
		clk => clk, 
		en_stp => en_stp, 
		sw_reset => reset, 
		key_plus_imp => key_plus_imp, 

		counter_ena => counter_ena_signal, 
		key_minus_imp => key_minus_imp, 
		transmitter_ena => transmitter_ena_signal
	);
 
	transmitter_port : transmitter
	Port Map(
		clk => clk, 
		en_stp => en_stp, 
		sw_reset => reset, 
		key_plus_imp => key_plus_imp, 
		transmitter_ena => transmitter_ena_signal, 
		in_csec => csec_signal, 
		in_sec => sec_signal, 
		in_min => min_signal, 
		in_hr => hr_signal, 
		csec => cs, 
		sec => ss, 
		min => mm, 
	    hr => hh); 
 
End Behavioral;