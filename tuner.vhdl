----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 02:06:41 PM
-- Design Name: 
-- Module Name: tuner - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tuner is
port (    
    clock           : in  std_logic;
    reset           : in  std_logic;
    digital_input   : in  unsigned(11 downto 0);
    write_en        : out std_logic;
    counter         : out integer := 0
 
    
);

end tuner;

architecture Behavioral of tuner is
    signal counter_i    : integer                  := 0;



begin


    process(clock)
    begin 
           if rising_edge(clock) then
            if reset = '1' then
                write_en <= '0';
                counter_i <= 0;
                
            else 
                write_en <= '0';
                
                if digital_input > x"800" then
                   counter_i <= counter_i + 1;
                   
                elsif digital_input < x"800" and digital_input >= x"400" then
                    counter_i <= counter_i;
                    if counter_i > 0 then
                        write_en <= '1';
                    end if;
                    
                elsif digital_input < x"400" then
                    counter_i <= 0;
                  

                end if;
            end if;
          end if;
          
        end process;
                   
 counter <= counter_i;
                 
            
   

end Behavioral;
