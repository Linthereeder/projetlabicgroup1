----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 17:17:50
-- Design Name: 
-- Module Name: compare - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compare is
    Port (clk : in std_logic ;
          --reset: in std_logic ;
          en_update: in std_logic ; 
          new_char: in char_all;
          char_addr: out std_logic_vector (7 downto 0);
          char_data: out std_logic_vector (7 downto 0));
end compare;

architecture Behavioral of compare is
    --type change is array (0 to 19) of std_logic_vector (0 to 3);
    
    signal old_char: char_all ;
    signal pos_change: std_logic_vector (0 to 79); -- determine all the different positions
    signal comp_addr: std_logic_vector (7 downto 0);
    signal update_delay: std_logic_vector (7 downto 0);
    signal addr_row: integer range 0 to 4;
    signal addr_col: integer range 0 to 20;
begin
    -- when receieve 
--    rst_old: process (clk) 
--    begin
--        if rising_edge (clk) then
--            if reset = '1' then
--                for row in 0 to 3 loop
--			        for col in 0 to 19 loop
--				        old_char(row)(col) <= CHAR_BLANK;
--			        end loop;
--		        end loop;
--		    end if;
--		end if;
--    end process;
    
    -- set the comp_change singal bit to 1 if new and old char are different
    comp_proc: process (new_char,old_char)
    begin
        for row in 0 to 3 loop
            for col in 0 to 19 loop
                pos_change(20*row+col) <= '0';
                if (old_char(row)(col) /= new_char(row)(col)) then
                    pos_change(20*row+col) <= '1';
                end if;
            end loop ;
        end loop; 
    end process ;
    
    -- translate the 80 bits signal into corresponding 7-bit DDR address, we are only interested in the first '1' bit  (the first different char)
    -- update the old char with the new char 
    char_addr <= '1'& comp_addr (6 downto 0);
    
--    process(clk, reset)  
--    begin
--        if rising_edge (clk) then
--            if reset = '1' then
--                comp_addr <= x"00";
--                char_data <= CHAR_BLANK ;
--            end if;
--        end if;
--    end process ;        
                        
    encode_proc: process(clk)
    begin
        if rising_edge (clk) then 
            if (en_update = '1') then                           
                if pos_change(0) = '1' then
                    comp_addr <= x"00";
                    char_data <= new_char(0)(0);
                    old_char (0)(0)<= new_char(0)(0);
                elsif pos_change(1) = '1'then
                    comp_addr <= x"01";
                    char_data <= new_char(0)(1);
                    old_char (0)(1)<= new_char(0)(1);
                elsif pos_change(2) = '1'then
                    comp_addr <= x"02";
                    char_data <= new_char(0)(2);
                    old_char (0)(2)<= new_char(0)(2);
                elsif pos_change(3) = '1'then 
                    comp_addr <= x"03";
                    char_data <= new_char(0)(3);
                    old_char (0)(3)<= new_char(0)(3);
                elsif pos_change(4) = '1'then 
                    comp_addr <= x"04";
                    char_data <= new_char(0)(4);
                    old_char (0)(4)<= new_char(0)(4);
                elsif pos_change(5) = '1'then
                    comp_addr <= x"05";
                    char_data <= new_char(0)(5);
                    old_char (0)(5)<= new_char(0)(5);
                elsif pos_change(6) = '1'then
                    comp_addr <= x"06";
                    char_data <= new_char(0)(6);
                    old_char (0)(6)<= new_char(0)(6);
                elsif pos_change(7) = '1'then
                    comp_addr <= x"07";
                    char_data <= new_char(0)(7);
                    old_char (0)(7)<= new_char(0)(7);
                elsif pos_change(8) = '1'then 
                    comp_addr <= x"08";
                    char_data <= new_char(0)(8);
                    old_char (0)(8)<= new_char(0)(8);
                elsif pos_change(9) = '1'then 
                    comp_addr <= x"09";
                    char_data <= new_char(0)(9);
                    old_char (0)(9)<= new_char(0)(9);
                elsif pos_change(10) = '1'then 
                    comp_addr <= x"0a";
                    char_data <= new_char(0)(10);
                    old_char (0)(10)<= new_char(0)(10);
                elsif pos_change(11) = '1'then
                    comp_addr <= x"0b";
                    char_data <= new_char(0)(11);
                    old_char (0)(11)<= new_char(0)(11);
                elsif pos_change(12) = '1'then 
                    comp_addr <= x"0c";
                    char_data <= new_char(0)(12);
                    old_char (0)(12)<= new_char(0)(12);
                elsif pos_change(13) = '1'then
                    comp_addr <= x"0d";
                    char_data <= new_char(0)(13);
                    old_char (0)(13)<= new_char(0)(13);
                elsif pos_change(14) = '1'then
                    comp_addr <= x"0e";
                    char_data <= new_char(0)(14);
                    old_char (0)(14)<= new_char(0)(14);
                elsif pos_change(15) = '1'then 
                    comp_addr <= x"0f";
                    char_data <= new_char(0)(15);
                    old_char (0)(15)<= new_char(0)(15);
                elsif pos_change(16) = '1'then
                    comp_addr <= x"10";
                    char_data <= new_char(0)(16);
                    old_char (0)(16)<= new_char(0)(16);
                elsif pos_change(17) = '1'then
                    comp_addr <= x"11";
                    char_data <= new_char(0)(17);
                    old_char (0)(17)<= new_char(0)(17);
                elsif pos_change(18) = '1'then
                    comp_addr <= x"12";
                    char_data <= new_char(0)(18);
                    old_char (0)(18)<= new_char(0)(18);
                elsif pos_change(19) = '1'then
                    comp_addr <= x"13";
                    char_data <= new_char(0)(19);
                    old_char (0)(19)<= new_char(0)(19);
                elsif pos_change(20) = '1'then
                    comp_addr <= x"40";
                    char_data <= new_char(1)(0);
                    old_char (1)(0)<= new_char(1)(0);
                elsif pos_change(21) = '1'then 
                    comp_addr <= x"41";
                    char_data <= new_char(1)(1);
                    old_char (1)(1)<= new_char(1)(1);
                elsif pos_change(22) = '1'then
                    comp_addr <= x"42";
                    char_data <= new_char(1)(2);
                    old_char (1)(2)<= new_char(1)(2);
                elsif pos_change(23) = '1'then
                    comp_addr <= x"43";
                    char_data <= new_char(1)(3);
                    old_char (1)(3)<= new_char(1)(3);
                elsif pos_change(24) = '1'then 
                    comp_addr <= x"44";
                    char_data <= new_char(1)(4);
                    old_char (1)(4)<= new_char(1)(5);
                elsif pos_change(25) = '1'then 
                    comp_addr <= x"45";
                    char_data <= new_char(1)(5);
                    old_char (1)(5)<= new_char(1)(5);
                elsif pos_change(26) = '1'then
                    comp_addr <= x"46";
                    char_data <= new_char(1)(6);
                    old_char (1)(6)<= new_char(1)(6);
                elsif pos_change(27) = '1'then 
                    comp_addr <= x"47";
                    char_data <= new_char(1)(7);
                    old_char (1)(7)<= new_char(1)(7);
                elsif pos_change(28) = '1'then
                    comp_addr <= x"48";
                    char_data <= new_char(1)(8);
                    old_char (1)(8)<= new_char(1)(8);
                elsif pos_change(29) = '1'then
                    comp_addr <= x"49";
                    char_data <= new_char(1)(9);
                    old_char (1)(9)<= new_char(1)(9);
                elsif pos_change(30) = '1'then 
                    comp_addr <= x"4a";
                    char_data <= new_char(1)(10);
                    old_char (1)(10)<= new_char(1)(10);
                elsif pos_change(31) = '1'then
                    comp_addr <= x"4b";
                    char_data <= new_char(1)(11);
                    old_char (1)(11)<= new_char(1)(11);
                elsif pos_change(32) = '1'then 
                    comp_addr <= x"4c";
                    char_data <= new_char(1)(12);
                    old_char (1)(12)<= new_char(1)(12);
                elsif pos_change(33) = '1'then 
                    comp_addr <= x"4d";
                    char_data <= new_char(1)(13);
                    old_char (1)(13)<= new_char(1)(13);
                elsif pos_change(34) = '1'then
                    comp_addr <= x"4e";
                    char_data <= new_char(1)(14);
                    old_char (1)(14)<= new_char(1)(14);
                elsif pos_change(35) = '1'then
                    comp_addr <= x"4f";
                    char_data <= new_char(1)(15);
                    old_char (1)(15)<= new_char(1)(15);
                elsif pos_change(36) = '1'then
                    comp_addr <= x"50";
                    char_data <= new_char(1)(16);
                    old_char (1)(16)<= new_char(1)(16);
                elsif pos_change(37) = '1'then
                    comp_addr <= x"51";
                    char_data <= new_char(1)(17);
                    old_char (1)(17)<= new_char(1)(17);
                elsif pos_change(38) = '1'then
                    comp_addr <= x"52";
                    char_data <= new_char(1)(18);
                    old_char (1)(18)<= new_char(1)(18);
                elsif pos_change(39) = '1'then
                    comp_addr <= x"53";
                    char_data <= new_char(1)(19);
                    old_char (1)(19)<= new_char(1)(19);
                elsif pos_change(40) = '1'then
                    comp_addr <= x"14";
                    char_data <= new_char(2)(0);
                    old_char (2)(0)<= new_char(2)(0);
                elsif pos_change(41) = '1'then
                    comp_addr <= x"15";
                    char_data <= new_char(2)(1);
                    old_char (2)(1)<= new_char(2)(1);
                elsif pos_change(42) = '1'then
                    comp_addr <= x"16";
                    char_data <= new_char(2)(2);
                    old_char (2)(2)<= new_char(2)(2);
                elsif pos_change(43) = '1'then
                    comp_addr <= x"17";
                    char_data <= new_char(2)(3);
                    old_char (2)(3)<= new_char(2)(3);
                elsif pos_change(44) = '1'then
                    comp_addr <= x"18";
                    char_data <= new_char(2)(4);
                    old_char (2)(4)<= new_char(2)(4);
                elsif pos_change(45) = '1'then
                    comp_addr <= x"19";
                    char_data <= new_char(2)(5);
                    old_char (2)(5)<= new_char(2)(5);
                elsif pos_change(46) = '1'then 
                    comp_addr <= x"1a";
                    char_data <= new_char(2)(6);
                    old_char (2)(6)<= new_char(2)(6);
                elsif pos_change(47) = '1'then
                    comp_addr <= x"1b";
                    char_data <= new_char(2)(7);
                    old_char (2)(7)<= new_char(2)(7);
                elsif pos_change(48) = '1'then 
                    comp_addr <= x"1c";
                    char_data <= new_char(2)(8);
                    old_char (2)(8)<= new_char(2)(8);
                elsif pos_change(49) = '1'then
                    comp_addr <= x"1d";
                    char_data <= new_char(2)(9);
                    old_char (2)(9)<= new_char(2)(9);
                elsif pos_change(50) = '1'then 
                    comp_addr <= x"1e";
                    char_data <= new_char(2)(10);
                    old_char (2)(10)<= new_char(2)(10);
                elsif pos_change(51) = '1'then
                    comp_addr <= x"1f";
                    char_data <= new_char(2)(11);
                    old_char (2)(11)<= new_char(2)(11);
                elsif pos_change(52) = '1'then
                    comp_addr <= x"20";
                    char_data <= new_char(2)(12);
                    old_char (2)(12)<= new_char(2)(12);
                elsif pos_change(53) = '1'then
                    comp_addr <= x"21";
                    char_data <= new_char(2)(13);
                    old_char (2)(13)<= new_char(2)(13);
                elsif pos_change(54) = '1'then
                    comp_addr <= x"22";
                    char_data <= new_char(2)(14);
                    old_char (2)(14)<= new_char(2)(14);
                elsif pos_change(55) = '1'then
                    comp_addr <= x"23";
                    char_data <= new_char(2)(15);
                    old_char (2)(15)<= new_char(2)(15);
                elsif pos_change(56) = '1'then
                    comp_addr <= x"24";
                    char_data <= new_char(2)(16);
                    old_char (2)(16)<= new_char(2)(16);
                elsif pos_change(57) = '1'then 
                    comp_addr <= x"25";
                    char_data <= new_char(2)(17);
                    old_char (2)(17)<= new_char(2)(17);
                elsif pos_change(58) = '1'then 
                    comp_addr <= x"26";
                    char_data <= new_char(2)(18);
                    old_char (2)(18)<= new_char(2)(18);
                elsif pos_change(59) = '1'then
                    comp_addr <= x"27";
                    char_data <= new_char(2)(19);
                    old_char (2)(19)<= new_char(2)(19);
                elsif pos_change(60) = '1'then
                    comp_addr <= x"54";
                    char_data <= new_char(3)(0);
                    old_char (3)(0)<= new_char(3)(0);
                elsif pos_change(61) = '1'then 
                    comp_addr <= x"55";
                    char_data <= new_char(3)(1);
                    old_char (3)(1)<= new_char(3)(1);
                elsif pos_change(62) = '1'then
                    comp_addr <= x"56";
                    char_data <= new_char(3)(2);
                    old_char (3)(2)<= new_char(3)(2);
                elsif pos_change(63) = '1'then
                    comp_addr <= x"57";
                    char_data <= new_char(3)(3);
                    old_char (3)(3)<= new_char(3)(3);
                elsif pos_change(64) = '1'then
                    comp_addr <= x"58";
                    char_data <= new_char(3)(4);
                    old_char (3)(4)<= new_char(3)(4);
                elsif pos_change(65) = '1'then
                    comp_addr <= x"59";
                    char_data <= new_char(3)(5);
                    old_char (3)(5)<= new_char(3)(5);
                elsif pos_change(66) = '1'then
                    comp_addr <= x"5a";
                    char_data <= new_char(3)(6);
                    old_char (3)(6)<= new_char(3)(6);
                elsif pos_change(67) = '1'then
                    comp_addr <= x"5b";
                    char_data <= new_char(3)(7);
                    old_char (3)(7)<= new_char(3)(7);
                elsif pos_change(68) = '1'then
                    comp_addr <= x"5c";
                    char_data <= new_char(3)(8);
                    old_char (3)(8)<= new_char(3)(8);
                elsif pos_change(69) = '1'then
                    comp_addr <= x"5d";
                    char_data <= new_char(3)(9);
                    old_char (3)(9)<= new_char(3)(9);
                elsif pos_change(70) = '1'then 
                    comp_addr <= x"5e";
                    char_data <= new_char(3)(10);
                    old_char (3)(10)<= new_char(3)(10);
                elsif pos_change(71) = '1'then
                    comp_addr <= x"5f";
                    char_data <= new_char(3)(11);
                    old_char (3)(11)<= new_char(3)(11);
                elsif pos_change(72) = '1'then
                    comp_addr <= x"60";
                    char_data <= new_char(3)(12);
                   old_char (3)(12)<= new_char(3)(12);
                elsif pos_change(73) = '1'then 
                    comp_addr <= x"61";
                    char_data <= new_char(3)(13);
                    old_char (3)(13)<= new_char(3)(13);
                elsif pos_change(74) = '1'then
                    comp_addr <= x"62";
                    char_data <= new_char(3)(14);
                    old_char (3)(14)<= new_char(3)(14);
                elsif pos_change(75) = '1'then 
                    comp_addr <= x"63";
                    char_data <= new_char(3)(15);
                    old_char (3)(15)<= new_char(3)(15);
                elsif pos_change(76) = '1'then
                    comp_addr <= x"64";
                    char_data <= new_char(3)(16);
                    old_char (3)(16)<= new_char(3)(16);
                elsif pos_change(77) = '1'then
                    comp_addr <= x"65";
                    char_data <= new_char(3)(17);
                    old_char (3)(17)<= new_char(3)(17);
                elsif pos_change(78) = '1'then
                    comp_addr <= x"66";
                    char_data <= new_char(3)(18);
                    old_char (3)(18)<= new_char(3)(18);
                elsif pos_change(79) = '1'then 
                    comp_addr <= x"67";
                    char_data <= new_char(3)(19);
                    old_char (3)(19)<= new_char(3)(19);
                else 
                    --comp_addr <= x"ff";
                    comp_addr <= x"00";
                    char_data <= CHAR_BLANK ;
                end if;
            end if;
        end if;
    end process ;

end Behavioral;
