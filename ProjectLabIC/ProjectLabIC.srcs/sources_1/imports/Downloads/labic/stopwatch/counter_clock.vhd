
-- Module Name: counter_clock - Behavioral
 
-- reference: http://esd.cs.ucr.edu/labs/tutorial/counter.vhd
 
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use ieee.std_logic_unsigned.All;

 

Entity counter_clock Is
	Port (
		clk : In STD_LOGIC;
		en_100 : In STD_LOGIC;  -- centi second measurement 
		en_stp : In STD_LOGIC;  --  fsm_stopwatch_start           
		sw_reset : In std_logic;
		key_plus_imp : In STD_LOGIC;
		count_ena : In std_logic;
		csec : Out std_logic_vector(6 Downto 0);
		sec : Out std_logic_vector(6 Downto 0);
		min : Out std_logic_vector(6 Downto 0);
		hr : Out std_logic_vector(6 Downto 0) 
	);
End counter_clock;

Architecture Behavioral Of counter_clock Is 
 
	Signal csec_signal : std_logic_vector(6 Downto 0) := "0000000";
	Signal sec_signal : std_logic_vector(6 Downto 0) := "0000000";
	Signal min_signal : std_logic_vector(6 Downto 0) := "0000000";
	Signal hr_signal : std_logic_vector(6 Downto 0) := "0000000";
Begin
	Process (clk) --en_100
	Begin
		If (clk = '1' And clk'event) Then
 
			If sw_reset = '1' or (key_plus_imp = '1' and en_stp = '1') Then -- key_plus_imp  local reset 
				csec_signal <= "0000000";
				sec_signal <= "0000000";
				min_signal <= "0000000";
				hr_signal <= "0000000";
 
			Else
				If count_ena = '1' Then
					If key_plus_imp = '1' and en_stp = '1' Then 
						csec_signal <= "0000000";
						sec_signal <= "0000000";
						min_signal <= "0000000";
						hr_signal <= "0000000";
					Else
					   if (en_100='1') then -- en_100'event and   for centi second                                 
                            csec_signal <= csec_signal + 1; -- "0000001"
                            If csec_signal = "1100011" Then -- 99 when centi second is 99 
                                csec_signal <= "0000000";
                                sec_signal <= sec_signal + 1;-- "0000001" 
                                If sec_signal = "0111011" Then --- 111011 is 59 
                                    sec_signal <= "0000000";
                                    min_signal <= min_signal + 1; -- "0000001"
                                    If min_signal = "0111011" Then -- 0111011 is 59 
                                        min_signal <= "0000000";   -- min counter reset after 60 count 
                                        hr_signal <= hr_signal + 1; -- "0000001"
                                        If hr_signal = "0010111" Then  -- 0010111 is 23 -- hour reset after 23 
                                            csec_signal <= csec_signal - csec_signal;
                                            sec_signal <= sec_signal - sec_signal;
                                            min_signal <= min_signal - min_signal;
                                            hr_signal <= hr_signal - hr_signal;
                                        End If;
                                    End If;
                                End If;
                            End If;
                         End If;
					End If;
				End If;
			End If;
		End If;
	End Process; 
 
	csec <= csec_signal;
	sec <= sec_signal;
	min <= min_signal;
	hr <= hr_signal;

End Behavioral;
