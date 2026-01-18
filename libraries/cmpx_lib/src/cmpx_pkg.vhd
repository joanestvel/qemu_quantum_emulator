library ieee;
library int_ext_lib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use int_ext_lib.int_ext_pkg.all;

package cmpx_pkg is

    -- Constant definitions
    constant LOG2_SIZE_ARRAY    :   positive := 2;
    constant SIZE_ARRAY         :   positive := 2 ** LOG2_SIZE_ARRAY;   -- Size of an array of complex numbers

    -- Type Definitions
    -- Integer type definitions
    subtype int_t is int_ext_t;        -- Standard integer type
    subtype int2_t is int_ext2_t;      -- Double width integer type
    -- Complex number type definition
    type cmpx_t is record
        re : int_t;  -- Real part
        im : int_t;  -- Imaginary part
    end record;
    -- Complex number type definition with double width
    type cmpx2_t is record
        re : int2_t;  -- Real part
        im : int2_t;  -- Imaginary part
    end record;
    -- Complex arrays
    type cmpx_array_t is array (0 to SIZE_ARRAY - 1) of cmpx_t;
    type cmpx2_array_t is array (0 to SIZE_ARRAY - 1) of cmpx2_t;
    type cmpx_matrix_t is array (0 to SIZE_ARRAY - 1) of cmpx_array_t;
    type cmpx2_matrix_t is array (0 to SIZE_ARRAY - 1) of cmpx2_array_t;

    -- cmpx_t and cmpx2_t useful constants
    constant CMPX_ZERO  :   cmpx_t  :=  (
        re  =>  INT_EXT_ZERO,
        im  =>  INT_EXT_ZERO
    );
    constant CMPX2_ZERO  :   cmpx2_t  := (
        re  =>  INT_EXT2_ZERO,
        im  =>  INT_EXT2_ZERO
    );

    -- Function definitions
    function "+" (a, b : cmpx_t) return cmpx_t;     -- Addition
    function "-" (a, b : cmpx_t) return cmpx_t;     -- Substraction
    function "+" (a, b : cmpx2_t) return cmpx2_t;   -- Addition double width
    function "-" (a, b : cmpx2_t) return cmpx2_t;   -- Substraction double width
    function "*" (a, b : cmpx_t) return cmpx2_t;    -- Multiplication
end package cmpx_pkg;

package body cmpx_pkg is
    -- Adding function
    function "+" (a, b : cmpx_t) return cmpx_t is
        variable v_result   :   cmpx_t;
    begin
        v_result    :=  (
            re  =>  a.re + b.re,
            im  =>  a.im + b.im
        );
        return v_result;
    end function;
    -- Sub function
    function "-" (a, b : cmpx_t) return cmpx_t is
        variable v_result   :   cmpx_t;
    begin
        v_result    :=  (
            re  =>  a.re - b.re,
            im  =>  a.im - b.im
        );
        return v_result;
    end function;
    -- Addition double width
    function "+" (a, b : cmpx2_t) return cmpx2_t is
        variable v_result   :   cmpx2_t;
    begin
        v_result    :=  (
            re  =>  a.re + b.re,
            im  =>  a.im + b.im
        );
        return v_result;
    end function;
    -- Substraction double width
    function "-" (a, b : cmpx2_t) return cmpx2_t is
        variable v_result   :   cmpx2_t;
    begin
        v_result    :=  (
            re  =>  a.re - b.re,
            im  =>  a.im - b.im
        );
        return v_result;
    end function;
    -- Multiplication
    function "*" (a, b : cmpx_t) return cmpx2_t is
        variable v_result   :   cmpx2_t;
    begin
        v_result    :=  (
            re  =>  a.re * b.re - a.im * b.im,
            im  =>  a.re * b.im + a.im * b.re
        );
        return v_result;
    end function;
end package body;