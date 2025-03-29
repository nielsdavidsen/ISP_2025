----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 02:06:41 PM
-- Design Name: 
-- Module Name: tuner_tb - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library work;

entity tuner_tb is
--  Port ( );
end tuner_tb;

architecture Behavioral of tuner_tb is

    signal clock            : std_logic             := '0';
    signal reset            : std_logic             := '0';
    signal counter          : integer               := 0;
    signal halfperiod       : integer               := 0;
    signal input_signal     : unsigned(11 downto 0) := (others => '0');
    signal end_of_counter   : std_logic             := '0';
    signal target_tone      : unsigned(31 downto 0) := (others => '0');
    
begin


dut0: entity work.tuner
    port map(
        clock               => clock,
        reset               => reset,
        end_of_counter      => end_of_counter,
        digital_input       => input_signal,
        counter             => halfperiod,
        target_tone         => target_tone
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

    reset       <=  '0' when counter = 0 else
                    '1' when counter = 1 else
                    '0';

    input_signal  <=    x"600" when counter > 5 and counter <= 10 else
                        x"FFF" when counter > 10 and counter <= 20 else
                        x"600" when counter > 20 and counter <= 22 else
                        
                        x"600" when counter > 25 and counter <= 30 else
                        x"FFF" when counter > 30 and counter <= 35 else
                        x"600" when counter > 35 and counter <= 40 else
                        
                        x"600" when counter > 45 and counter <= 50 else
                        x"FFF" when counter > 50 and counter <= 60 else
                        x"600" when counter > 60 and counter <= 62 else
                        
                        x"600" when counter > 65 and counter <= 70 else
                        x"FFF" when counter > 70 and counter <= 75 else
                        x"600" when counter > 75 and counter <= 80 else
                        
                        x"600" when counter > 85 and counter <= 90 else
                        x"FFF" when counter > 90 and counter <= 95 else
                        x"600" when counter > 95 and counter <= 100 else
                        x"000";
                        
      target_tone <= to_unsigned(15,32);

end Behavioral;
