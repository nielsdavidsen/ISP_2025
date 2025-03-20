
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO_top is
port(
    clock           : in  std_logic;
    reset           : in  std_logic;
    sw_1            : in  std_logic;
    sw_2            : in  std_logic;
    fifo_empty      : out std_logic;
    fifo_full       : out std_logic;
    rd_en           : out std_logic;
    fifo_data_out   : out std_logic_vector(3 downto 0)
);
end FIFO_top;

architecture Behavioral of FIFO_top is

    signal stable_reset         : std_logic;
    signal sw_1_wr              : std_logic;
    signal sw_2_rd              : std_logic;
    signal wr_en_hilo           : std_logic;
    signal wr_en                : std_logic;
    signal fifo_data_in         : std_logic_vector(3 downto 0);
    signal counter              : unsigned(3 downto 0);
    signal rd_en_hilo           : std_logic;
    signal rd_en_internal : std_logic;

    component fifo_generator_0 is
        port (
            clk        : in  std_logic;
            srst       : in  std_logic;
            din        : in  std_logic_vector(3 downto 0);
            wr_en      : in  std_logic;
            rd_en      : in  std_logic;
            dout       : out std_logic_vector(3 downto 0);
            full       : out std_logic;
            empty      : out std_logic
        );
    end component;

begin 

--------------------------------------------------------------
-- Stabilize reset
--------------------------------------------------------------
    rst_debouncer: entity work.debouncer
    port map(
        clk   => clock,
        din   => reset,
        dout  => stable_reset
    );

--------------------------------------------------------------
-- Write to FIFO
--------------------------------------------------------------
    sw_1_debouncer: entity work.debouncer
    port map(
        clk   => clock,
        din   => sw_1,
        dout  => sw_1_wr
    );

    write_hilo: entity work.hilo_detect
    generic map (
        lohi    => true
    )
    port map (
        clk     => clock,
        rst     => reset,
        sig_in  => sw_1_wr,
        sig_out => wr_en_hilo
    );

    write_extension: entity work.pulse_extender
    generic map (
        PULSE_LENGTH    => 12
    )
    port map (
        CLK     => clock,
        RST     => stable_reset,
        SIG_IN  => wr_en_hilo,
        SIG_OUT => wr_en
    );

    process(clock)
    begin
        if rising_edge(clock) then
            if stable_reset = '1' then
                counter <= (others => '0');
            elsif wr_en = '1' then
                if counter < 15 then
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    


    fifo_data_in <= std_logic_vector(counter);
    
--------------------------------------------------------------
-- FIFO Instance
--------------------------------------------------------------
    fifo_inst: fifo_generator_0
    port map(
        clk    => clock,
        srst   => stable_reset,
        din    => fifo_data_in,
        wr_en  => wr_en,
        rd_en  => rd_en_internal, -- Use internal signal
        dout   => fifo_data_out,
        full   => fifo_full,
        empty  => fifo_empty
    );

--------------------------------------------------------------
-- Read from FIFO
--------------------------------------------------------------
    sw_2_debouncer: entity work.debouncer
    port map(
        clk   => clock,
        din   => sw_2,
        dout  => sw_2_rd
    );

    read_hilo: entity work.hilo_detect
    generic map (
        lohi    => true
    )
    port map (
        clk     => clock,
        rst     => reset,
        sig_in  => sw_2_rd,
        sig_out => rd_en_hilo
    );

    read_extension: entity work.pulse_extender
    generic map (
        PULSE_LENGTH    => 12
    )
    port map (
        CLK     => clock,
        RST     => stable_reset,
        SIG_IN  => rd_en_hilo,
        SIG_OUT => rd_en
    );
    
    process(clock)
begin
    if rising_edge(clock) then
        rd_en <= rd_en_internal;
    end if;
end process;

end Behavioral;
