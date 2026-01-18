-- Latency: 3 Cycles
-- Max Frequency: 250 MHz

library ieee;
library int_ext_lib;
library cmpx_lib;
use ieee.std_logic_1164.all;
use int_ext_lib.int_ext_pkg.all;
use cmpx_lib.cmpx_pkg.all;

-- (re1 + im1*i) * (re2 + im2*i) = (re1 * re2 - im1 * im2) + (re1 * im2 + re2 * im1)*i

entity cmpx_mult is
    port (
        clock_i     : in    std_logic;
        a_i         : in    cmpx_t;
        b_i         : in    cmpx_t;
        result_o    : out   cmpx2_t
    );
end entity cmpx_mult;

architecture rtl of cmpx_mult is
    -- Multiplication Phase signals
    signal s_reg_re_re  : int_ext2_t;
    signal s_reg_im_im  : int_ext2_t;
    signal s_reg_re_im  : int_ext2_t;
    signal s_reg_im_re  : int_ext2_t;
    -- Add and sub Phase signals
    signal s_reg_re     : int_ext2_t;
    signal s_reg_im     : int_ext2_t;
begin
    -- Multiplication Phase (2 Cycles)
    ----------------------------------------------------------------------------------------
    -- re1 * re2
    re_re_mult_inst: entity int_ext_lib.int_ext_mult
        port map (
            clock_i     => clock_i,
            a_i         => a_i.re,
            b_i         => b_i.re,
            result_o    => s_reg_re_re
        );
    -- im1 * im2
    im_im_mult_inst: entity int_ext_lib.int_ext_mult
        port map (
            clock_i     => clock_i,
            a_i         => a_i.im,
            b_i         => b_i.im,
            result_o    => s_reg_im_im
        );
    -- re1 * im2
    re_im_mult_inst: entity int_ext_lib.int_ext_mult
        port map (
            clock_i     => clock_i,
            a_i         => a_i.re,
            b_i         => b_i.im,
            result_o    => s_reg_re_im
        );
    -- im1 * re2
    im_re_mult_inst: entity int_ext_lib.int_ext_mult
        port map (
            clock_i     => clock_i,
            a_i         => a_i.im,
            b_i         => b_i.re,
            result_o    => s_reg_im_re
        );
    ----------------------------------------------------------------------------------------

    -- Add and Sub Phase (1 Cycle)
    ----------------------------------------------------------------------------------------
        add_sub_proc: process(clock_i)
        begin
            if (rising_edge(clock_i)) then
                s_reg_re    <= s_reg_re_re - s_reg_im_im;
                s_reg_im    <= s_reg_re_im + s_reg_im_re;
            end if;
        end process add_sub_proc;
    ----------------------------------------------------------------------------------------

    -- Asociating registered signals with the outputs
    result_o    <= (
        re  => s_reg_re,
        im  => s_reg_im
    );
end rtl;