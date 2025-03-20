-------------------------------------------------------------------------------
-- Design     : pulse_extender.vhd
-- Author     : Steffen Staerz
-- Maintainer : Alessandra Camplani
-- Email      : alessandra.camplani@cern.ch
-- Comments   : Extends a pulse
-------------------------------------------------------------------------------
-- Details    :
-- Whenever a high input is seen, its duration is extended for 'pulse_length'
-------------------------------------------------------------------------------
--
-- Instantiation template:
--
--  [inst_name]: entity work.PULSE_EXTENDER
--  generic map (
--      PULSE_LENGTH    => [integer := 1000]    -- number of counts
--  )
--  port map (
--      CLK             => [in  std_logic],     -- clock
--      RST             => [in  std_logic],     -- sync reset
--      SIG_IN          => [in  std_logic],     -- input signal
--      SIG_OUT         => [out std_logic]      -- output signal
--  );
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.common_lib.all;

entity PULSE_EXTENDER is
generic (
    PULSE_LENGTH    : integer := 1000
);
port (
    CLK             : in  std_logic;
    RST             : in  std_logic;

    SIG_IN          : in  std_logic;
    SIG_OUT         : out std_logic := '0'
);
end PULSE_EXTENDER;

architecture behavorial of PULSE_EXTENDER is

begin
    assert (PULSE_LENGTH > 1)
    report "Minimum value for 'pulse_length' is 2!"
    severity failure;

    GEN_OUTPUT: block
        constant CL         : positive := log2ceil(PULSE_LENGTH);
        constant CNT_INIT   : signed(CL downto 0) := to_signed(PULSE_LENGTH-2, CL+1);
        signal COUNTER      : signed(CL downto 0) := (others => '1');
    begin
------------------------------  <-  80 chars  ->  ------------------------------
--  default_counter makes use of the sign flip at counter(counter'left)
--  that's why the initial value is pulse_length-2 and it only works for 
--  pulse_length > 1
--------------------------------------------------------------------------------
        process(CLK)
        begin
            if rising_edge(CLK) then
                if RST = '1' then
                    COUNTER <= (others => '1');
                    SIG_OUT <= '0';
                elsif SIG_IN = '1' then
--! input signal initialises counter
                    COUNTER <= CNT_INIT;
                    SIG_OUT <= '1';
                elsif COUNTER(COUNTER'left) = '0' then
--! if counter is still positive, keep counting down
                    COUNTER <= COUNTER - 1;
                    SIG_OUT <= '1';
                else
--! if counter reaches -1, stop counting and indicate 0 signal
                    COUNTER <= COUNTER;
                    SIG_OUT <= '0';
                end if;
            end if;
        end process;
    end block;

end behavorial;
