----------------------------------------------------------------------------------
 
-- Module Name: counter_controller - Behavioral
 
----------------------------------------------------------------------------------
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;

 

Entity counter_controller Is
	Port (
		clk : In STD_LOGIC;
		en_stp : In STD_LOGIC;  --- fsm_stopwatch_start 
		sw_reset : In STD_LOGIC;
		key_plus_imp : In STD_LOGIC;
		key_action_imp : In STD_LOGIC;
		counter_ena : Out STD_LOGIC
	);
End counter_controller;

Architecture Behavioral Of counter_controller Is
 
	Signal Pre_counter_ena : STD_LOGIC := '0';
 

Begin
	Process (clk)
	Begin
		If (clk = '1' And clk'event) Then
			If sw_reset = '1' Then Pre_counter_ena <= '0';
			Else
				If en_stp = '1' Then  -- --- fsm_stopwatch_start 
					If key_plus_imp = '1' Then Pre_counter_ena <= '0';
					Else
 
						If key_action_imp = '1' Then 
							If Pre_counter_ena = '1' Then Pre_counter_ena <= '0';
							Else
								Pre_counter_ena <= '1';
							End If;
						Else
							Pre_counter_ena <= Pre_counter_ena; 
						End If;  ------ key_action_imp = '1' 
					End If;   --------- key_plus_imp = '1' Then  
				End If;  --------fsm_stopwatch_start = '1'  
			End If;  ---- sw_reset = '1'
		End If; ------- clk = '1' 
	End Process;

	counter_ena <= Pre_counter_ena;       ------- Internal signal
End Behavioral;
