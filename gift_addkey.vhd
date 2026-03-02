----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 07:50:31 AM
-- Design Name: 
-- Module Name: gift_addkey - Behavioral
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

package gift_addkey_pkg is
    function add_key( state : std_logic_vector(63 downto 0);
                      rk    : std_logic_vector(31 downto 0)
    )
    return std_logic_vector ;
    
end package gift_addkey_pkg ;

package body gift_addkey_pkg is
    function add_key( state : std_logic_vector(63 downto 0);
                      rk    : std_logic_vector(31 downto 0)
    )
    return std_logic_vector is variable y : std_logic_vector(63 downto 0) ;
    
    begin
    
    y := state;
    for i in 0 to 31 loop
      y(2*i) := state(2*i) xor rk(i);
    end loop;
    return y;
     
    end function add_key ;
end package body gift_addkey_pkg ;