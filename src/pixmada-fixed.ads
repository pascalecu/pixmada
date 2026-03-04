with Pixmada.Thin; use Pixmada.Thin;

package Pixmada.Fixed is
   type Fixed_16_16 is
     delta 2.0 ** (-16) range -2.0 ** 15 .. 2.0 ** 15 - 2.0 ** (-16);
   for Fixed_16_16'Size use 32;

   type Fixed_32_32 is
     delta 2.0 ** (-32) range -2.0 ** 31 .. 2.0 ** 31 - 2.0 ** (-32);
   for Fixed_32_32'Size use 64;

   subtype Fixed is Fixed_16_16;

   Epsilon     : constant Fixed_16_16 := Fixed_16_16'Small;
   One         : constant Fixed_16_16 := 1.0;
   One_Minus_E : constant Fixed_16_16 := One - Epsilon;
   Minus_One   : constant Fixed_16_16 := -1.0;

   function Cast (F : pixman_fixed_t) return Fixed_16_16
   with Inline;
   function Cast (F : Fixed_16_16) return pixman_fixed_t
   with Inline;

   function Cast (F : pixman_fixed_32_32_t) return Fixed_32_32
   with Inline;
   function Cast (F : Fixed_32_32) return pixman_fixed_32_32_t
   with Inline;
end Pixmada.Fixed;
