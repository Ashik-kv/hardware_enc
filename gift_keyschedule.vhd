----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2026 10:52:22 AM
-- Design Name: 
-- Module Name: gift_keyschedule - Behavioral
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

entity gift_keyschedule is
    Port ( clk     : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           load    : in STD_LOGIC;
           enable  : in STD_LOGIC;
           
           key_in    : in STD_LOGIC_VECTOR (127 downto 0);
           round_key : out STD_LOGIC_VECTOR (31 downto 0));
end gift_keyschedule;

architecture Behavioral of gift_keyschedule is
    signal key_state : std_logic_vector(127 downto 0);
     
    begin
    
    process(key_state)
    begin
    for i in 0 to 31 loop
      round_key(i) <= key_state(2*i);
    end loop;
    end process;
    
    process(clk, rst_n)
    variable rotated   : std_logic_vector(127 downto 0);
    variable tmp       : std_logic_vector(15  downto 0);
    begin
        if rst_n = '0' then
            key_state <= (others => '0');
    
        elsif rising_edge(clk) then
            if load = '1' then
                key_state <= key_in;
            elsif enable = '1' then
                rotated := key_state(31 downto 0) & key_state(127 downto 32); --rotate by 32 bits >>>
                key_state <= rotated;
                
                tmp                   := rotated(95 downto 80);
                rotated(95 downto 80) := rotated(79 downto 64);
                rotated(79 downto 64) := tmp;

                key_state <= rotated;

            end if;
        end if;
    end process;
 
end architecture;
