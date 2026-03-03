with Interfaces;   use Interfaces;
with Interfaces.C; use Interfaces.C;

package Pixmada.Thin is
   --  Integer type aliases
   subtype int8_t is Integer_8;
   subtype uint8_t is Unsigned_8;
   subtype int16_t is Integer_16;
   subtype uint16_t is Unsigned_16;
   subtype int32_t is Integer_32;
   subtype uint32_t is Unsigned_32;
   subtype int64_t is Integer_64;
   subtype uint64_t is Unsigned_64;

   --  Boolean
   subtype pixman_bool_t is int;

   --  Fixed point types (16.16 represented in signed 32-bit)
   subtype pixman_fixed_t is int32_t;
   subtype pixman_fixed_16_16_t is pixman_fixed_t;
   subtype pixman_fixed_32_32_t is int64_t;
   subtype pixman_fixed_48_16_t is pixman_fixed_32_32_t;
   subtype pixman_fixed_1_31_t is uint32_t;
   subtype pixman_fixed_1_16_t is uint32_t;

   --  Helpers
   function To_Unsigned_32 (S : pixman_fixed_t) return uint32_t
   with Inline;
   function To_Signed_32 (U : uint32_t) return pixman_fixed_t
   with Inline;
   function Arithmetic_Shift_Right_32
     (X : pixman_fixed_t; N : Natural) return pixman_fixed_t
   with Inline;

   --  Conversion functions
   function pixman_fixed_to_int (F : pixman_fixed_t) return int
   with Inline;
   function pixman_int_to_fixed (I : int) return pixman_fixed_t
   with Inline;

   function pixman_fixed_to_double (F : pixman_fixed_t) return Long_Float;
   function pixman_double_to_fixed (D : Long_Float) return pixman_fixed_t;

   --  16.16 fixed constants
   pixman_fixed_e         : constant pixman_fixed_t := 1;
   pixman_fixed_1         : constant pixman_fixed_t := 16#0001_0000#;
   pixman_fixed_1_minus_e : constant pixman_fixed_t :=
     pixman_fixed_1 - pixman_fixed_e;
   pixman_fixed_minus_1   : constant pixman_fixed_t := -pixman_fixed_1;
   pixman_max_fixed_48_16 : constant pixman_fixed_48_16_t :=
     pixman_fixed_48_16_t'Last;
   pixman_min_fixed_48_16 : constant pixman_fixed_48_16_t :=
     pixman_fixed_48_16_t'First;

   --  Functions for fixed types
   function pixman_fixed_frac (F : pixman_fixed_t) return pixman_fixed_t
   with Inline;
   function pixman_fixed_floor (F : pixman_fixed_t) return pixman_fixed_t
   with Inline;
   function pixman_fixed_ceil (F : pixman_fixed_t) return pixman_fixed_t
   with Inline;
   function pixman_fixed_fraction (F : pixman_fixed_t) return pixman_fixed_t
   with Inline;
   function pixman_fixed_mod_2 (F : pixman_fixed_t) return pixman_fixed_t
   with Inline;
end Pixmada.Thin;
