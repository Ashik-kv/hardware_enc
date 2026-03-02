----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 09:21:27 AM
-- Design Name: 
-- Module Name: uart_module - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
  generic(
    CLKS_PER_BIT : integer := 868  -- 100MHz / 115200
  );
  port(
    clk       : in  std_logic;
    rst_n     : in  std_logic;
    rx_serial : in  std_logic;
    rx_data   : out std_logic_vector(7 downto 0);
    rx_valid  : out std_logic
  );
end entity;

architecture rtl of uart_rx is

  type state_t is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
  signal state : state_t;

  signal clk_count : integer range 0 to CLKS_PER_BIT-1;
  signal bit_index : integer range 0 to 7;
  signal rx_shift  : std_logic_vector(7 downto 0);

begin

process(clk, rst_n)
begin
  if rst_n = '0' then
    state <= IDLE;
    rx_valid <= '0';
    clk_count <= 0;
    bit_index <= 0;

  elsif rising_edge(clk) then

    rx_valid <= '0';

    case state is

      when IDLE =>
        if rx_serial = '0' then
          state <= START_BIT;
          clk_count <= 0;
        end if;

      when START_BIT =>
        if clk_count = CLKS_PER_BIT/2 then
          clk_count <= 0;
          state <= DATA_BITS;
        else
          clk_count <= clk_count + 1;
        end if;

      when DATA_BITS =>
        if clk_count = CLKS_PER_BIT-1 then
          clk_count <= 0;
          rx_shift(bit_index) <= rx_serial;

          if bit_index = 7 then
            bit_index <= 0;
            state <= STOP_BIT;
          else
            bit_index <= bit_index + 1;
          end if;
        else
          clk_count <= clk_count + 1;
        end if;

      when STOP_BIT =>
        if clk_count = CLKS_PER_BIT-1 then
          rx_valid <= '1';
          rx_data  <= rx_shift;
          clk_count <= 0;
          state <= IDLE;
        else
          clk_count <= clk_count + 1;
        end if;

    end case;

  end if;
end process;

end architecture;

