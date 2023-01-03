----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 17:17:50
-- Design Name: 
-- Module Name: lcd_fsm - Behavioral
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

entity lcd_fsm is
    Port (clk: in std_logic ;
          reset: in std_logic;
          char_addr: in std_logic_vector (7 downto 0);
          char_data: in std_logic_vector (7 downto 0);
          en_update: out std_logic ;
          lcd_en: out std_logic ;
          lcd_rw: out std_logic ;
          lcd_rs: out std_logic ;
          lcd_data: out std_logic_vector (7 downto 0) );
end lcd_fsm;

architecture Behavioral of lcd_fsm is
    type state is (INIT, DATA, ADDR, UPDATE);
    signal current_state, next_state: state;
    signal en_counter: std_logic ;
    signal counter: integer range 0 to 15;
    signal en_display : std_logic ;
begin
    lcd_en <= clk and en_display ;
    
    nsl_proc: process(current_state, counter)
    begin
        next_state <= current_state ;
        case current_state is 
            when INIT => 
                if counter = 15 then
                    next_state <= DATA;
                end if;
            when DATA => 
                next_state <= UPDATE ;
            when UPDATE => 
                next_state <= ADDR ;
            when ADDR => 
                next_state <= DATA ;
        end case;
    end process ;
    
    mem_proc: process(clk)
    begin
        if rising_edge (clk) then 
            if (reset = '1') then 
                current_state <= INIT;
            else 
                current_state <= next_state ;
            end if;
        end if;
    end process ;
    
    ols_proc: process(current_state, counter, char_addr ,char_data )
    begin 
        en_display <= '1';
        en_update <= '0';
        en_counter <= '0';
        lcd_rw <= '0';
        lcd_rs <= '0';
        lcd_data <= x"00";
        
        case current_state is 
            when INIT => 
                en_counter <= '1'; 
                case counter is 
                    when 0 => lcd_data <= b"0011_1000"; -- function set
                    when 12 => lcd_data <= b"0011_1000"; -- function set
                    when 13 => lcd_data <= b"0000_0110"; -- entry mode
                    when 14 => lcd_data <= b"0000_1100"; -- dispaly on, cursor off 
                    when others => en_display <= '0';
                end case ;
            when DATA => 
                en_update <= '1';
                lcd_rs <= '1';
                lcd_data <= char_data ;
            when ADDR => 
                lcd_data <= char_addr ;
            when UPDATE => 
                en_display <= '0';
        end case ;
    end process ;
    
    counter_proc: process (clk) 
    begin 
        if rising_edge (clk) then
            if (reset = '1') then 
                counter <= 0;
            elsif (en_counter = '1') then
                counter <= counter + 1;
            end if;
        end if;
    end process ;     
        

end Behavioral;
