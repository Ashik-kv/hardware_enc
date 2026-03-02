----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 08:53:38 AM
-- Design Name: 
-- Module Name: gift_addroundconstant - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


package gift_addroundconstant_pkg is 
    subtype round_t is integer range 0 to 27;
 
    function add_const(state : std_logic_vector(63 downto 0);
                       round : round_t
)
return std_logic_vector ;

end package gift_addroundconstant_pkg ;

package body gift_addroundconstant_pkg is 

    function add_const(state : std_logic_vector(63 downto 0);
                       round : round_t
    )
    return std_logic_vector is variable y : std_logic_vector(63 downto 0) ;
                               variable rc: std_logic_vector( 5 downto 0) ;
    
    begin
    y  := state;
    
    case round is
        when 0  => rc := "000001";
        when 1  => rc := "000011";
        when 2  => rc := "000111";
        when 3  => rc := "001111";
        when 4  => rc := "011111";
        when 5  => rc := "111110";
        when 6  => rc := "111101";
        when 7  => rc := "111011";
        when 8  => rc := "110111";
        when 9  => rc := "101111";
        when 10 => rc := "011110";
        when 11 => rc := "111100";
        when 12 => rc := "111001";
        when 13 => rc := "110011";
        when 14 => rc := "100111";
        when 15 => rc := "001110";
        when 16 => rc := "011101";
        when 17 => rc := "111010";
        when 18 => rc := "110101";
        when 19 => rc := "101011";
        when 20 => rc := "010110";
        when 21 => rc := "101100";
        when 22 => rc := "011000";
        when 23 => rc := "110000";
        when 24 => rc := "100001";
        when 25 => rc := "000010";
        when 26 => rc := "000101";
        
        when others => rc := "001011"; 
  end case;

    y(3)  := state(3)  xor rc(0);
    y(7)  := state(7)  xor rc(1);
    y(11) := state(11) xor rc(2);
    y(15) := state(15) xor rc(3);
    y(19) := state(19) xor rc(4);
    y(23) := state(23) xor rc(5);

    y(63) := state(63) xor '1';

    return y;
  end function add_const;
end package body gift_addroundconstant_pkg ;
    
