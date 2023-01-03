----------------------------------------------------------------------------------
-- TUM
-- Engineer: Haoyuan Liu ge49nor
-- 
-- Create Date: 12/15/2022 02:30:56 PM
-- Design Name: 
-- Module Name: bcd_converter_opt - Behavioral
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
-- reference :https://ieeexplore.ieee.org/abstract/document/6725995
-- fast bcd converter 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- rtl level discription of fast bcd converter. not clocked.
-- I reference this paper here: reference :https://ieeexplore.ieee.org/abstract/document/6725995  
entity bcd_converter_opt is
  Port ( binary_in: in std_logic_vector(6 downto 0);
         decimal_out: out std_logic_vector( 7 downto 0)
           );
end bcd_converter_opt;

architecture Behavioral of bcd_converter_opt is
    signal t,H,l,c,z,tmp2: std_logic_vector(3 downto 0);
    signal y,x,tmp:std_logic_vector(2 downto 0);
    signal c1,c2,c3,c3t,c4,c5:std_logic;
begin
    decimal_out(0)<=binary_in(0);
    bit_contribuation_HSB: process(binary_in(6 downto 4))
    begin 
        case binary_in(6 downto 4) is 
        when "000"=>
            y<="000";
            t<="0000";
        when "001"=>
            y<="011";
            t<="0001";
        when "010"=>
            y<="001";
            t<="0011";
        when "011"=>
            y<="100";
            t<="0100";
        when "100"=>
            y<="010";
            t<="0110";
        when "101"=>
            y<="000";
            t<="1000";
        when others=>
            y<="001";
            t<="0011";
        end case;
    end process;
    
    -- if LHS>4 then add3 to get c1 x2 x1 x0(carry 1)
    c1<=binary_in(3) and (binary_in(2) OR binary_in(1));
    x(2)<='0' when c1='1' else  binary_in(3) ;
    x(1)<=binary_in(3) and binary_in(2) AND binary_in(1) when c1='1' else  binary_in(2) ;
    x(0)<=not(binary_in(1)) when c1='1' else  binary_in(1) ;
    
    
    --3 bit adder
    a3bit: entity work.adder(Behavioral)
        generic map( input_width=>4)
        port map(a=>x,b=>y,neg_b=>'0',s=>z);
    c2<=z(3);   
    
    
    -- if LHS>4 or c2==1 then add3 to get c3 L3 L2 L1(carry 1)
    a3bit2: entity work.adder(Behavioral)
        generic map( input_width=>4)
        port map(a=>z(2 downto 0),b=>"011",neg_b=>'0',s=>tmp2);
    c3t<=(z(2) and (z(1) OR z(0))) or c2;
    decimal_out(3)<=tmp2(2) when c3t='1' else  z(2) ;
    decimal_out(2)<=tmp2(1) when c3t='1' else  z(1) ;
    decimal_out(1)<=tmp2(0) when c3t='1' else  z(0);
    c3<=tmp2(3);
    
    --2 bit adder
    c4<=c2 or c3;
    a2bit: entity work.adder(Behavioral)
        generic map( input_width=>3)
        port map(a=>t(1 downto 0),b=>(c1 and c4 )&(c4 XOR C1),neg_b=>'0',s=>tmp);
        
    c5<=tmp(2);
    decimal_out(5 downto 4)<= tmp(1 downto 0);
    decimal_out(6)<=t(2) or c5;
    decimal_out(7)<=t(3);
    
end Behavioral;
