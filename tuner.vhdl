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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tuner is
port (    
    clock                : in  std_logic;
    reset                : in  std_logic;
    target_switch        : in std_logic_vector(1 downto 0);
    adc_in               : in  std_logic_vector(1 downto 0);
    in_tune              : out std_logic;
    too_high             : out std_logic;
    too_low              : out std_logic
    --frequency_out        : out std_logic_vector(31 downto 0)
    
    --digital_input        : in  unsigned(11 downto 0);
    --end_of_counter       : out std_logic;
    --counter              : out integer := 0;
    --mean_period          : out unsigned(31 downto 0);
    --period_difference    : out signed(31 downto 0);
    
);

end tuner;

architecture Behavioral of tuner is
    signal counter_i        : integer       := 0;
    signal write_en         : std_logic     := '0';
    
    type t_array is array (0 to 100) of unsigned(31 downto 0);
    type temp_array is array (0 to 101) of unsigned(31 downto 0);
    signal temp                     : temp_array;         
    signal array_of_values          : t_array;
    signal counter_fill             : integer := 0;
    signal fill_done                : std_logic := '0';
    signal adc_out                  : std_logic_vector(11 downto 0);
    signal end_of_counter           : std_logic;
    signal counter                  : integer := 0;
    signal mean_period              : unsigned(31 downto 0);
    signal period_difference        : signed(31 downto 0);
    signal target_tone              :unsigned(31 downto 0);
    --signal summing_done             : std_logic := '0';

begin

WRITE_HILO: entity work.hilo_detect
generic map (
    lohi    => true
)
port map (
    clk     => clock,
    rst     => reset,
    sig_in  => write_en,
    sig_out => end_of_counter
);
    
    
CALL_XADC: entity work.xadc_inst
port map ( 
    clk     => clock,
    reset   => reset,
    adc_in  => adc_in,
    adc_out => adc_out
);
  

process(clock)
begin 
       if rising_edge(clock) then
        if reset = '1' then
            write_en <= '0';
            counter_i <= 0;
            
        else 
            write_en <= '0';
            
            if adc_out > x"800" then
               counter_i <= counter_i + 1;
               
            elsif adc_out < x"800" and adc_out >= x"400" then
                counter_i <= counter_i;
                if counter_i > 0 then
                    write_en <= '1';
                end if;
                
            elsif adc_out < x"400" then
                counter_i <= 0;
            end if;
        end if;
      end if;
      
end process;
                   
 counter <= counter_i;
                 

            
   
FILLING:    process (clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                array_of_values <= (others => (others => '0'));
                counter_fill  <= 0;
                fill_done <= '0'; 
            
        elsif end_of_counter = '1' then
                   if counter_fill > 101 then
                        counter_fill <= 0;
                        array_of_values <= array_of_values;
                        fill_done <= '1';
                   else 
                        counter_fill <= counter_fill + 1 ;
                        array_of_values(counter_fill)<= to_unsigned(counter, 32);
                        fill_done <= '0';
                   end if;
                   
        
            end if;
        end if;
    end process;
    
 
 
 summing: process (clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                temp <= (others => (others => '0'));
                --summing_done <= '0';
            elsif fill_done = '1' then
                for j in 0 to 100 loop
                    temp(j+1) <= temp(j) + array_of_values(j);
                end loop;
                --summing_done <= '1';
            end if;
        end if;
    end process;

    mean_period <= (temp(101)/101);
     

TT_PICK: process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                target_tone <= (others => '0');
            elsif target_switch(0) = '1' and target_switch(1) = '0' then
                target_tone <= x"00001380";  -- should be 10khz
            elsif target_switch(1) = '1' and target_switch(0) = '0' then 
                target_tone <= x"000009c0"; -- should be 20 khz
            else
                target_tone <= x"00000000";
            end if;
        end if;
     end process; 
             

comparing: process (clock)
    begin
       if rising_edge(clock) then
            if reset = '1' or target_tone = x"00000000" then
                    --summing_done <= '0';
                    in_tune <= '0';
                    too_high <= '0';
                    too_low <= '0';
                    
               
            elsif fill_done = '1' and target_tone /= x"00000000" then
                --period_difference <= unsigned(abs(signed(mean_period)-signed(target_tone)));
                period_difference <= (signed(mean_period)-signed(target_tone));
                
                if period_difference < -1000 then
                    too_high <= '1';
                    in_tune <= '0';
                    too_low <= '0';
                        
                        
                elsif period_difference > 1000 then
                       too_low <= '1';
                       in_tune <= '0';
                       too_high <= '0';
                    
                else  
                    in_tune <= '1';
                    too_high <= '0';
                    too_low <= '0';                    
                end if;
            end if;
        end if;
    end process;
            
             

end Behavioral;
