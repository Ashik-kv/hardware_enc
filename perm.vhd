----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 06:50:19 AM
-- Design Name: 
-- Module Name: perm - Behavioral
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

package gift_perm_pkg is 

    function perm (x: std_logic_vector(63 downto 0)
    )
    return std_logic_vector ;
    
    function inv_perm(x: std_logic_vector(63 downto 0)
    )
    return std_logic_vector ;
    
end package gift_perm_pkg ;

package body gift_perm_pkg is
    
    function perm(x:std_logic_vector(63 downto 0)
    )
    return std_logic_vector is variable y: std_logic_vector(63 downto 0) ;
    
    variable dst : integer ;
    begin
        for i in 0 to 63 loop
          dst := (i mod 4) * 16 + (i / 4);
          y(dst) := x(i);
        end loop;
    
        return y;
    end function perm;
  
    function inv_perm(x : std_logic_vector(63 downto 0)
    )
    return std_logic_vector is variable y : std_logic_vector(63 downto 0);
    
    variable src : integer;
    begin
        for i in 0 to 63 loop
          src := (i mod 16) * 4 + (i / 16);
          y(src) := x(i);
        end loop;
    
        return y;
    end function inv_perm;

end package body gift_perm_pkg;