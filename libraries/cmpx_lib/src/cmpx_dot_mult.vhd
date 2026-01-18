-- Latency: 3 + log2(size_array) cycles
-- Max Frequency: 207.51 MHz

library ieee;
library int_ext_lib;
library cmpx_lib;
use ieee.std_logic_1164.all;
use int_ext_lib.int_ext_pkg.all;
use cmpx_lib.cmpx_pkg.all;

entity cmpx_dot_mult is
    port (
        clock_i     :   in  std_logic;
        a_i         :   in  cmpx_array_t;
        b_i         :   in  cmpx_array_t;
        result_o    :   out cmpx2_t
    );
end entity cmpx_dot_mult;

architecture rtl of cmpx_dot_mult is
    -- Element Wise multiplication Phase signals
    signal s_reg_elemwise   : cmpx2_array_t;

    -- Addition Phase signals and types
    type tree_t is array (0 to LOG2_SIZE_ARRAY) of cmpx2_array_t;

    signal s_reg_tree   : tree_t;   -- Almost half of the array is not used, but it simplifies circuit description
begin
    -- Element Wise multiplication Phase (3 Cycles)
    --------------------------------------------------------------
    mult_gen:   for i in 0 to (s_reg_elemwise'length - 1) generate
        mult_inst:  entity cmpx_lib.cmpx_mult
            port map (
                clock_i     => clock_i,
                a_i         => a_i(i),
                b_i         => b_i(i),
                result_o    => s_reg_elemwise(i)
            );
    end generate mult_gen;
    --------------------------------------------------------------

    -- Addition Phase (log2(s_reg_elemwise'length) cycles)
    --------------------------------------------------------------
    s_reg_tree(0)   <= s_reg_elemwise;    -- The first level of the tree (lvl 0) is the register multiplication of the last phase
    tree_gen:   for i in 1 to (s_reg_tree'length - 1) generate
        add_gen:    for j in 0 to (s_reg_tree(i)'length/(2 ** i) - 1) generate
            add_proc:   process(clock_i)
            begin
                if (rising_edge(clock_i)) then
                    s_reg_tree(i)(j)    <= s_reg_tree(i - 1)(2 * j) + s_reg_tree(i - 1)(2 * j + 1);
                end if;
            end process add_proc;
        end generate add_gen;
    end generate tree_gen;
    --------------------------------------------------------------

    -- Asociating registered signals with the outputs
    result_o    <= s_reg_tree(LOG2_SIZE_ARRAY)(0);
end rtl;