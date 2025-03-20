library ieee;
use ieee.std_logic_1164.all;

package common_lib is

--! layer information
--    constant num_pix_layer          : integer := 1;
--    constant num_str_layer          : integer := 7;
--    
--    constant tot_num_layer          : integer := num_pix_layer + num_str_layer;


    function log2ceil(arg : positive) return natural;
    function div_ceil(a : natural; b : positive) return natural;
    function roundUp2Power(arg : positive) return positive;
    function maxof2numbers(a : positive; b: positive) return positive;
    function pow2(arg : positive) return natural;
end common_lib;

package body common_lib is
  
--! Logarithms: log*ceil*
--! ==========================================================================
--! return log2; always rounded up
--! From https://github.com/VLSI-EDA/PoC/blob/master/src/common/utils.vhdl
    function log2ceil(arg : positive) return natural is
        variable tmp : positive;
        variable log : natural;
    begin
        if arg = 1 then return 0; end if;
        tmp := 1;
        log := 0;
        while arg > tmp loop
            tmp := tmp * 2;
            log := log + 1;
        end loop;
        return log;
    end function;

--! Divisions: div_*
--! ===========================================================================
--! integer division; always round-up
--! calculates: ceil(a / b)
    function div_ceil(a : natural; b : positive) return natural is
    begin
        return (a + (b - 1)) / b;
    end function;

--! Returns next larger value in power of 2
--! ==========================================================================
--! 
    function roundUp2Power(arg : positive) return positive is
        variable tmp : positive;
    begin
        tmp := 1;
        while arg > tmp loop
            tmp := tmp * 2;
        end loop;
        return tmp;
    end function;

--! Returns maximum of two numbers
--! ==========================================================================
--! 
    function maxof2numbers(a : positive; b: positive) return positive is
    begin
        if (a > b)  then 
            return a; 
        elsif (a < b) then
            return b;
        else    -- a = b
            return a;
        end if;
    end function;       

--! Returns power of 2
--! ==========================================================================
--! 
    function pow2(arg : positive) return natural is
        variable tmp : positive;
        variable log : natural;
    begin
        if arg = 0 then return 1; end if;
        tmp := 1;
        log := 0;
        while arg > log loop
            tmp := tmp * 2;
            log := log + 1;
        end loop;
        return tmp;
    end function;

end package body common_lib;
