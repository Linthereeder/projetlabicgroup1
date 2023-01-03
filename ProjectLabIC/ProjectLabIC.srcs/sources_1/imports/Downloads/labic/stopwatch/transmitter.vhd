 
-- Module Name: transmitter - Behavioral

 
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use ieee.std_logic_unsigned.All; 
Use IEEE.NUMERIC_STD.All;

 

Entity transmitter Is
	Port (
		clk : In std_logic;
		en_stp : In std_logic; --- fsm_stopwatch_start 
		sw_reset : In std_logic;
		key_plus_imp : In STD_LOGIC;
		transmitter_ena : In std_logic := '1';
		in_csec : In std_logic_vector(6 Downto 0) := "0000000"; -- csec_in
		in_sec : In std_logic_vector(6 Downto 0) := "0000000"; -- sec_in
		in_min : In std_logic_vector(6 Downto 0) := "0000000"; --  min_in 
		in_hr : In std_logic_vector(6 Downto 0) := "0000000"; --  hr_in 
		csec : Out std_logic_vector(6 Downto 0) := "0000000"; 
		sec : Out std_logic_vector(6 Downto 0) := "0000000"; 
		min : Out std_logic_vector(6 Downto 0) := "0000000";
		hr : Out std_logic_vector(6 Downto 0) := "0000000"
	);
End transmitter;

Architecture Behavioral Of transmitter Is

	Signal csec_old : std_logic_vector(6 Downto 0) := "0000000";
	Signal sec_old : std_logic_vector(6 Downto 0) := "0000000";
	Signal min_old : std_logic_vector(6 Downto 0) := "0000000";
	Signal hr_old : std_logic_vector(6 Downto 0) := "0000000";

Begin
	Process (clk)
 
	Begin
		If (clk = '1' And clk'event) Then
			If sw_reset = '1' Then
				csec_old <= "0000000";
				sec_old <= "0000000";
				min_old <= "0000000";
				hr_old <= "0000000";
				csec <= "0000000";
				sec <= "0000000";
				min <= "0000000";
				hr <= "0000000";
			Else
				If en_stp = '1' Then --- fsm_stopwatch_start 
					If key_plus_imp = '1' Then
						csec_old <= "0000000";
						sec_old <= "0000000";
						min_old <= "0000000";
						hr_old <= "0000000";
						csec <= "0000000";
						sec <= "0000000";
						min <= "0000000";
						hr <= "0000000";
					Else
 
						If transmitter_ena = '1' Then 
							csec <= in_csec;
							csec_old <= in_csec;
							sec <= in_sec;
							sec_old <= in_sec;
							min <= in_min;
							min_old <= in_min;
							hr <= in_hr;
							hr_old <= in_hr; 
						Else
							csec <= csec_old;
							sec <= sec_old;
							min <= min_old;
							hr <= hr_old; 
						End If;
					End If;
                
				End If;
				
			End If;
 
		End If;
	End Process;
End Behavioral;