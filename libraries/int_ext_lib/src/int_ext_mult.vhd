-- Latency: 2 Cycles
-- Maximum Frequency: 250 MHz

library ieee;
library int_ext_lib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use int_ext_lib.int_ext_pkg.all;

-- (q1 + i1*sqrt(2)) * (q2 + i2*sqrt(2)) = (q1 * q2 + 2 * i1 * i2) + (q1 * i2 + q2 * i1)*sqrt(2)

entity int_ext_mult is
    port    (
        clock_i     : in    std_logic;
        a_i         : in    int_ext_t;
        b_i         : in    int_ext_t;
        result_o    : out   int_ext2_t
    );
end entity;

architecture rtl of int_ext_mult is
    -- Multiplication Phase signals
    signal s_reg_q1_q2          : signed(2 * INT_EXT_WIDTH - 1 downto 0);   -- q1 * q2 register
    signal s_reg_i1_i2          : signed(2 * INT_EXT_WIDTH - 1 downto 0);   -- i1 * i2 register
    signal s_reg_q1_i2          : signed(2 * INT_EXT_WIDTH - 1 downto 0);   -- q1 * i2 register
    signal s_reg_q2_i1          : signed(2 * INT_EXT_WIDTH - 1 downto 0);   -- q2 * i1 register

    -- Adding Phase regist
    signal s_reg_rat        : signed(2 * INT_EXT_WIDTH - 1 downto 0);   -- (q1 * q2 + 2 * i1 * i2)
    signal s_reg_irr        : signed(2 * INT_EXT_WIDTH - 1 downto 0);   -- (q1 * i2 + q2 * i1)

begin
    -- Multiplication Phase (1 Cycle)
    -----------------------------------------------------------------------------------------------
    mult_proc: process(clock_i)
    begin
        if (rising_edge(clock_i)) then
            s_reg_q1_q2 <= a_i.q * b_i.q;
            s_reg_i1_i2 <= a_i.i * b_i.i;
            s_reg_q1_i2 <= a_i.q * b_i.i;
            s_reg_q2_i1 <= a_i.i * b_i.q;
        end if;
    end process mult_proc;
    -----------------------------------------------------------------------------------------------

    -- Adding Phase (1 Cycle)
    -----------------------------------------------------------------------------------------------
    add_proc: process(clock_i)
    begin
        if (rising_edge(clock_i)) then
            s_reg_rat   <= s_reg_q1_q2 + shift_left(s_reg_i1_i2, 1);
            s_reg_irr   <= s_reg_q1_i2 + s_reg_q2_i1;
        end if;
    end process add_proc;
    -----------------------------------------------------------------------------------------------

    -- Asociating registered signals with the outputs
    result_o    <= (
        q   => s_reg_rat,
        i   => s_reg_irr
    );
end rtl;