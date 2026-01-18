-- Latency: 3 + log2(size_array) cycles
-- Max frequency: 187.48 MHz (depends on the size of the array)

library ieee;
library cmpx_lib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use cmpx_lib.cmpx_pkg.all;

entity mult_mtx_vect is
    port    (
        clock_i     : in    std_logic;
        vect_i      : in    cmpx_array_t;
        mtrx_i      : in    cmpx_matrix_t;
        vect_o      : out   cmpx2_array_t
    );
end entity mult_mtx_vect;

architecture rtl of mult_mtx_vect is
begin
    mult_gen:   for i in 0 to (vect_o'length - 1) generate
        mult_inst:  entity cmpx_lib.cmpx_dot_mult
            port map (
                clock_i     => clock_i,
                a_i         => vect_i,
                b_i         => mtrx_i(i),
                result_o    => vect_o(i)
            );
    end generate mult_gen;
end rtl;