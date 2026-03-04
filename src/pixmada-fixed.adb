with Ada.Unchecked_Conversion;

package body Pixmada.Fixed is
   function To_F16 is new
     Ada.Unchecked_Conversion (pixman_fixed_t, Fixed_16_16);
   function To_P16 is new
     Ada.Unchecked_Conversion (Fixed_16_16, pixman_fixed_t);

   function To_F32 is new
     Ada.Unchecked_Conversion (pixman_fixed_32_32_t, Fixed_32_32);
   function To_P32 is new
     Ada.Unchecked_Conversion (Fixed_32_32, pixman_fixed_32_32_t);

   function Cast (F : pixman_fixed_t) return Fixed_16_16
   is (To_F16 (F));
   function Cast (F : Fixed_16_16) return pixman_fixed_t
   is (To_P16 (F));

   function Cast (F : pixman_fixed_32_32_t) return Fixed_32_32
   is (To_F32 (F));
   function Cast (F : Fixed_32_32) return pixman_fixed_32_32_t
   is (To_P32 (F));
end Pixmada.Fixed;
