----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 06:09:01 AM
-- Design Name: 
-- Module Name: gift_sbox - Behavioral
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

--package declaration

package gift_sbox_pkg is
 
  function sbox (x : std_logic_vector(3 downto 0)
  )
  return std_logic_vector;

  function inv_sbox (x : std_logic_vector(3 downto 0)
  )
  return std_logic_vector;

end package gift_sbox_pkg;

-- package body sbox
package body gift_sbox_pkg is

 function sbox(
    x : std_logic_vector(3 downto 0)
  ) return std_logic_vector is
  begin
    case x is
      when "0000" => return "0001"; -- 0  -> 1
      when "0001" => return "1010"; -- 1  -> A
      when "0010" => return "0100"; -- 2  -> 4
      when "0011" => return "1100"; -- 3  -> C
      when "0100" => return "0110"; -- 4  -> 6
      when "0101" => return "1111"; -- 5  -> F
      when "0110" => return "0011"; -- 6  -> 3
      when "0111" => return "1001"; -- 7  -> 9
      when "1000" => return "0010"; -- 8  -> 2
      when "1001" => return "1101"; -- 9  -> D
      when "1010" => return "1011"; -- A  -> B
      when "1011" => return "0111"; -- B  -> 7
      when "1100" => return "0101"; -- C  -> 5
      when "1101" => return "0000"; -- D  -> 0
      when "1110" => return "1000"; -- E  -> 8
      when others => return "1110"; -- F  -> E
    end case;
  end function sbox;
  
  function inv_sbox(
    x: std_logic_vector(3 downto 0)
    ) return std_logic_vector is 
    
    begin
        case x is 
          when "0001" => return "0000"; -- 1  -> 0
          when "1010" => return "0001"; -- A  -> 1
          when "0100" => return "0010"; -- 4  -> 2
          when "1100" => return "0011"; -- C  -> 3
          when "0110" => return "0100"; -- 6  -> 4
          when "1111" => return "0101"; -- F  -> 5
          when "0011" => return "0110"; -- 3  -> 6
          when "1001" => return "0111"; -- 9  -> 7
          when "0010" => return "1000"; -- 2  -> 8
          when "1101" => return "1001"; -- D  -> 9
          when "1011" => return "1010"; -- B  -> A
          when "0111" => return "1011"; -- 7  -> B
          when "0101" => return "1100"; -- 5  -> C
          when "0000" => return "1101"; -- 0  -> D
          when "1000" => return "1110"; -- 8  -> E
          when others => return "1111"; -- E  -> F
        end case;
  end function inv_sbox;

end package body gift_sbox_pkg;
    
