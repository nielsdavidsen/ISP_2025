
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_top_tb is

end FIFO_top_tb;

architecture Behavioral of FIFO_top_tb is

    signal clock                : std_logic                     := '0';
    signal reset                : std_logic                     := '0';
    signal sw_1                 : std_logic                     := '0';
    signal sw_2                 : std_logic                     := '0';
    signal counter              : integer                       := 0;
    signal fifo_data_out        : std_logic_vector(3 downto 0)  := (others => '0');

begin

dut0: entity work.FIFO_top
    port map(
        clock           => clock,
        reset           => reset,
        sw_1            => sw_1,
        sw_2            => sw_2,
        fifo_data_out   => fifo_data_out

    );

-- Clock generator, also outputting a counter
    sim_basics_clk250 : entity work.simulation_basics
        generic map (
            reset_duration => 15,
            clk_offset     => 0 ns,
            clk_period     => 4 ns
        )
        port map (
            clk     => clock,
            rst     => open,
            counter => counter
        );

    reset <=        '1' when counter >= 0 and counter <5 else
                    '0';

    sw_1 <=         '1' when counter > 10 else
                    '0';

    sw_2 <=         '1' when counter > 22000 and counter < 42000 else
                    '1' when counter > 100000 and counter < 120000 else
                    '0';
end Behavioral;
