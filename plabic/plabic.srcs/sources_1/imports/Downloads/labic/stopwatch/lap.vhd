 
-- Module Name: lap - Behavioral
 
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;

 

Entity lap Is
	Port (
		clk : In STD_LOGIC;
		en_stp : In STD_LOGIC; --- fsm_stopwatch_start
		sw_reset : In STD_LOGIC;
		key_plus_imp : In STD_LOGIC;
		counter_ena : In STD_LOGIC;
		key_minus_imp : In STD_LOGIC;
		transmitter_ena : Out STD_LOGIC
	);
End lap;

Architecture Behavioral Of lap Is

	Signal Pre_transmitter_ena : STD_LOGIC := '1';
Begin
	Process (clk)
	Begin
		If (clk = '1' And clk'event) Then
			If sw_reset = '1' Then  Pre_transmitter_ena <= '1';
			Else
				If en_stp = '1' Then     --- fsm_stopwatch_start
					If key_plus_imp = '1' Then Pre_transmitter_ena <= '1';
					Else
						If counter_ena = '1' Then
							If Pre_transmitter_ena = '0' Then
								If key_minus_imp = '1' Then Pre_transmitter_ena <= '1';
								End If;
							Else
								If key_minus_imp = '1' Then Pre_transmitter_ena <= '0';
								End If;
							End If;
						End If;
					End If;
				End If;
			End If;
		End If;

	End Process;
 
	transmitter_ena <= Pre_transmitter_ena;

End Behavioral;       
