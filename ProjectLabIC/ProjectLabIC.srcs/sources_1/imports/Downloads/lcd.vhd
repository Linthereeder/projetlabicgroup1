----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:43:15 08/19/2014 
-- Design Name: 
-- Module Name:    lcd - Behavioral 
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

entity lcd is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   text : in t_text;
           lcd_en : out  STD_LOGIC;
           lcd_rw : out  STD_LOGIC;
           lcd_rs : out  STD_LOGIC;
           lcd_data : out  STD_LOGIC_VECTOR (7 downto 0));
end lcd;

architecture Behavioral of lcd is

	type t_state is (
		s_init,
		s_addr,
		s_data
	);
	
	signal current_state : t_state;
	signal next_state : t_state;
	signal last_index : std_logic;
	signal line : integer range 0 to 3;
	signal index : integer range 0 to 20;
	signal enable_clk : std_logic;
	
begin
	lcd_en <= clk and enable_clk;

	next_state_logic : process(current_state)
	begin
		case current_state is
			when s_init => next_state <= s_addr;
			when s_addr => next_state <= s_data;
			when s_data => next_state <= s_addr;
		end case;
	end process;
		
	update_state_logic : process(clk)
	begin
		if rising_edge(clk) then
			if reset='1' then
				current_state <= s_init;
				index <= 0;
			elsif last_index='1' then
				current_state <= next_state;
				index <= 0;
			else
				index <= index+1;
			end if;
		end if;
	end process;
	
	line_counter : process(clk)
	begin
		if rising_edge(clk) then
			if reset='1' then
				line <= 0;
			elsif last_index='1' and next_state=s_addr then
				if line=3 then
					line <= 0;
				else
					line <= line+1;
				end if;
			end if;
		end if;
	end process;
	
	output_logic : process(current_state, index, line, text)
	begin
		-- Default values
		enable_clk <= '1';
		last_index <= '0';
		lcd_rs <= '0';
		lcd_rw <= '0';
		lcd_data <= x"00";
		
		case current_state is
			when s_init =>
				case index is
					when 0  => lcd_data <= "00111000"; -- Function Set 8bit, 2line
					when 10 => lcd_data <= "00111000"; -- Function Set 8bit, 2line
					when 11 => lcd_data <= "00000110"; -- Entry Mode
					when 12 => lcd_data <= "00001100"; -- Display on, cursor off
								last_index <= '1';
					when others => enable_clk <= '0';
				end case;
			when s_addr =>
				last_index <= '1';
				case line is
					when 0 => lcd_data <= "10000000"; -- Set Address x00
					when 1 => lcd_data <= "11000000"; -- Set Address x40
					when 2 => lcd_data <= "10010100"; -- Set Address x14
					when 3 => lcd_data <= "11010100"; -- Set Address x54					
				end case;
			when s_data =>
				lcd_rs <= '1';
				lcd_data <= text(line)(index);
				if index=19 then
					last_index <= '1';
				end if;
		end case;
	end process;
	
end Behavioral;

