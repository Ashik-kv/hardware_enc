----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 06:26:21 AM
-- Design Name: 
-- Module Name: subcells - Behavioral
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

use work.gift_sbox_pkg.all;

package gift_subcells_pkg is 
    
    function subcells (x: std_logic_vector(63 downto 0)
    )
    return std_logic_vector;
    
    function inv_subcells (x: std_logic_vector(63 downto 0)
    )
    return std_logic_vector;
    
end package gift_subcells_pkg ;


package body gift_subcells_pkg is

  function subcells (x : std_logic_vector(63 downto 0)
  )
  return std_logic_vector is variable y : std_logic_vector(63 downto 0);
    
  begin
  
    for i in 0 to 15 loop
      y(i*4 + 3 downto i*4) := sbox(x(i*4 + 3 downto i*4));
    end loop;

    return y;
  end function subcells;
  
  
  function inv_subcells (x : std_logic_vector(63 downto 0)
  )
  return std_logic_vector is variable y : std_logic_vector(63 downto 0);
  
  begin
    
    for i in 0 to 15 loop
      y(i*4 + 3 downto i*4) := inv_sbox(x(i*4 + 3 downto i*4));
    end loop;

    return y;
  end function inv_subcells;
  
  end package body gift_subcells_pkg ;
