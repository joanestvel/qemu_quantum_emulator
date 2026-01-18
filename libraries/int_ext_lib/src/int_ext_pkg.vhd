library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package int_ext_pkg is

    -- Constants definition

    -- Define the width for the signed types
    constant INT_EXT_WIDTH : integer := 8;


    -- Types definition
    -- Define a new type for integer extension (q+i*sqrt(2))
    type int_ext_t is record
        q : signed(INT_EXT_WIDTH - 1 downto 0); -- Rational part
        i : signed(INT_EXT_WIDTH - 1 downto 0); -- Irrational part
    end record;
    -- Define a new type for integer extension with double width
    type int_ext2_t is record
        q : signed((2 * INT_EXT_WIDTH) - 1 downto 0);   -- Rational part
        i : signed((2 * INT_EXT_WIDTH) - 1 downto 0);   -- Irrational part
    end record;

    -- int_ext_t and int_ext2_t useful constants
    constant INT_EXT_ZERO   :   int_ext_t   :=  (
        q   =>  (others =>  '0'),
        i   =>  (others =>  '0')
    );
    constant INT_EXT2_ZERO  :   int_ext2_t  :=  (
        q   =>  (others =>  '0'),
        i   =>  (others =>  '0')
    );

    -- Function definitions
    function "+" (a, b : int_ext_t) return int_ext_t;   -- Addition
    function "-" (a, b : int_ext_t) return int_ext_t;   -- Substraction
    function "+" (a, b : int_ext2_t) return int_ext2_t; -- Addition double width
    function "-" (a, b : int_ext2_t) return int_ext2_t; -- Substraction double width
    function "*" (a, b : int_ext_t) return int_ext2_t;  -- Multiplication


end package int_ext_pkg;

package body int_ext_pkg is
    -- Addition function
    function "+" (a, b : int_ext_t) return int_ext_t is
        variable v_result   :   int_ext_t;
    begin
        v_result    :=  (
            q   =>  a.q + b.q,
            i   =>  a.i + b.i
        );
        return v_result;
    end function;
    -- Sub function
    function "-" (a, b : int_ext_t) return int_ext_t is
        variable v_result   :   int_ext_t;
    begin
        v_result    :=  (
            q   =>  a.q - b.q,
            i   =>  a.i - b.i
        );
        return v_result;
    end function;
    -- Addition double width
    function "+" (a, b : int_ext2_t) return int_ext2_t is
        variable v_result   :   int_ext2_t;
    begin
        v_result    :=  (
            q   =>  a.q + b.q,
            i   =>  a.i + b.i
        );
        return v_result;
    end function;
    -- Substraction double width
    function "-" (a, b : int_ext2_t) return int_ext2_t is
        variable v_result   :   int_ext2_t;
    begin
        v_result    :=  (
            q   =>  a.q - b.q,
            i   =>  a.i - b.i
        );
        return v_result;
    end function;
    -- Multiplication
    function "*" (a, b : int_ext_t) return int_ext2_t is
        variable v_result   :   int_ext2_t;
    begin
        v_result    :=  (
            q   =>  a.q * b.q + ((a.i * b.i) sll 1),
            i   =>  a.q * b.i + a.i * b.q
        );
        return v_result;
    end function;
end package body;