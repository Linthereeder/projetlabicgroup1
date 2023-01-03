----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/11/19 17:17:50
-- Design Name: 
-- Module Name: lcd_top - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lcd_top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en_date : in STD_LOGIC;
           en_alarm : in STD_LOGIC;
           en_switch_on : in STD_LOGIC;
           en_switch_off : in STD_LOGIC;
           en_stp : in STD_LOGIC;
           en_ctd : in STD_LOGIC;
           normal_time : in STD_LOGIC_VECTOR (23 downto 0);-- hour, minute, second in BCD
           date : in STD_LOGIC_VECTOR (23 downto 0);-- month,day,year in BCD
           dow : in STD_LOGIC_VECTOR (2 downto 0);
           dcf_ready : in STD_LOGIC;
           alarm_time : in STD_LOGIC_VECTOR (15 downto 0);-- hour, minute
           alarm_act : in STD_LOGIC;
           alarm_snz : in STD_LOGIC;
           stp_time : in STD_LOGIC_VECTOR (31 downto 0);--hour, minute,second, millisec
           stp_lap : in STD_LOGIC;
           ctd_time : in STD_LOGIC_VECTOR (23 downto 0);
           ctd_act : in STD_LOGIC;          
           switch_act : in STD_LOGIC;
           switch_on : in STD_LOGIC_VECTOR (23 downto 0);
           switch_off : in STD_LOGIC_VECTOR (23 downto 0);
           lcd_en : out STD_LOGIC;
           lcd_rw : out STD_LOGIC;
           lcd_rs : out STD_LOGIC;
           lcd_data : out STD_LOGIC_VECTOR (7 downto 0));
end lcd_top;

architecture Behavioral of lcd_top is
    signal fsm_en_update :std_logic ;
    signal display_char: char_all ;
    signal update_addr, update_data: std_logic_vector (7 downto 0);
begin
    inst_gen_new: entity work.gen_new port map(en_date ,en_alarm ,en_switch_on ,en_switch_off , en_stp ,
                                               en_ctd, normal_time ,date ,dow ,dcf_ready ,alarm_time ,alarm_act ,
                                               alarm_snz ,stp_time ,stp_lap ,ctd_time ,ctd_act , switch_on, switch_off, switch_act,
                                               display_char);
    inst_compare: entity work.compare port map(clk,fsm_en_update ,display_char ,update_addr ,update_data);
    inst_fsm: entity work.lcd_fsm port map(clk,rst,update_addr ,update_data ,fsm_en_update ,lcd_en ,lcd_rw ,lcd_rs,lcd_data );

end Behavioral;
