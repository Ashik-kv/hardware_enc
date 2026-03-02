----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 09:17:29 AM
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top is
  port(
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    uart_rx : in  std_logic;
    uart_tx : out std_logic
  );
end entity;

architecture rtl of top is

  signal rx_data   : std_logic_vector(7 downto 0);
  signal rx_valid  : std_logic;

  signal key_reg   : std_logic_vector(127 downto 0);
  signal data_reg  : std_logic_vector(63 downto 0);
  signal enc_reg   : std_logic;

  signal byte_cnt  : integer range 0 to 24;
  signal gift_start: std_logic;
  signal gift_done : std_logic;
  signal gift_out  : std_logic_vector(63 downto 0);

begin

  uart_inst : entity work.uart_rx
    port map(
      clk       => clk,
      rst_n     => rst_n,
      rx_serial => uart_rx,
      rx_data   => rx_data,
      rx_valid  => rx_valid
    );

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      byte_cnt   <= 0;
      gift_start <= '0';

    elsif rising_edge(clk) then

      gift_start <= '0';

      if rx_valid = '1' then

        if byte_cnt = 0 then
          enc_reg <= rx_data(0);

        elsif byte_cnt <= 16 then
          key_reg <= key_reg(119 downto 0) & rx_data;

        elsif byte_cnt <= 24 then
          data_reg <= data_reg(55 downto 0) & rx_data;

        end if;

        if byte_cnt = 24 then
          gift_start <= '1';
          byte_cnt <= 0;
        else
          byte_cnt <= byte_cnt + 1;
        end if;

      end if;

    end if;
  end process;

  gift_inst : entity work.gift64_core
    port map(
      clk      => clk,
      rst_n    => rst_n,
      start    => gift_start,
      enc_dec  => enc_reg,
      key_in   => key_reg,
      data_in  => data_reg,
      data_out => gift_out,
      done     => gift_done
    );
    
    uart_tx <= gift_done ;
end architecture;
