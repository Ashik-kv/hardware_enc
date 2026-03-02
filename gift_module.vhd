----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 09:19:19 AM
-- Design Name: 
-- Module Name: gift_module - Behavioral
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

use work.gift_subcells_pkg.all;
use work.gift_perm_pkg.all;
use work.gift_addkey_pkg.all;
use work.gift_addroundconstant_pkg.all;

entity gift64_core is
  port (
    clk       : in  std_logic;
    rst_n     : in  std_logic;
    start     : in  std_logic;
    enc_dec   : in  std_logic;
    key_in    : in  std_logic_vector(127 downto 0);
    data_in   : in  std_logic_vector(63 downto 0);
    data_out  : out std_logic_vector(63 downto 0);
    done      : out std_logic
  );
end entity;

architecture rtl of gift64_core is

  type state_t is (IDLE_S, ROUND_S, DONE_S);
  signal curr_st, next_st : state_t;

  constant LAST_ROUND : integer := 27;

  signal state_reg   : std_logic_vector(63 downto 0);
  signal round_cnt   : integer range 0 to LAST_ROUND;
  signal round_key   : std_logic_vector(31 downto 0);

  signal ks_load     : std_logic;
  signal ks_enable   : std_logic;

  signal enc_reg     : std_logic;

begin

  -- Latch enc_dec at start
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      enc_reg <= '0';
    elsif rising_edge(clk) then
      if curr_st = IDLE_S and start = '1' then
        enc_reg <= enc_dec;
      end if;
    end if;
  end process;

  ks : entity work.gift_keyschedule
    port map (
      clk       => clk,
      rst_n     => rst_n,
      load      => ks_load,
      enable    => ks_enable,
      key_in    => key_in,
      round_key => round_key
    );

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      curr_st <= IDLE_S;
    elsif rising_edge(clk) then
      curr_st <= next_st;
    end if;
  end process;

  process(curr_st, start, round_cnt, enc_reg)
  begin
    next_st   <= curr_st;
    done      <= '0';
    ks_load   <= '0';
    ks_enable <= '0';

    case curr_st is

      when IDLE_S =>
        if start = '1' then
          next_st   <= ROUND_S;
          ks_load   <= '1';
          ks_enable <= '1';
        end if;

      when ROUND_S =>
        ks_enable <= '1';

        if (round_cnt = LAST_ROUND and enc_reg = '1') or
           (round_cnt = 0          and enc_reg = '0') then
          next_st <= DONE_S;
        end if;

      when DONE_S =>
        done    <= '1';
        next_st <= IDLE_S;

    end case;
  end process;

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      round_cnt <= 0;
    elsif rising_edge(clk) then

      if curr_st = IDLE_S and start = '1' then
        if enc_reg = '1' then
          round_cnt <= 0;
        else
          round_cnt <= LAST_ROUND;
        end if;

      elsif curr_st = ROUND_S then
        if enc_reg = '1' then
          round_cnt <= round_cnt + 1;
        else
          round_cnt <= round_cnt - 1;
        end if;
      end if;

    end if;
  end process;

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      state_reg <= (others => '0');

    elsif rising_edge(clk) then

      if curr_st = IDLE_S and start = '1' then
        state_reg <= data_in;

      elsif curr_st = ROUND_S then

        if enc_reg = '1' then
          state_reg <= add_const(add_key(perm(subcells(state_reg)),round_key),round_cnt);
        else
          state_reg <= inv_subcells(inv_perm(add_key(add_const(state_reg,round_cnt),round_key)));
        end if;

      end if;

    end if;
  end process;

  data_out <= state_reg;

end architecture;
