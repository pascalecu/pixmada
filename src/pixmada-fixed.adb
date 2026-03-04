with Ada.Unchecked_Conversion;
with Interfaces; use Interfaces;

package body Pixmada.Fixed is
   function To_F16 is new
     Ada.Unchecked_Conversion (pixman_fixed_t, Fixed_16_16);
   function To_P16 is new
     Ada.Unchecked_Conversion (Fixed_16_16, pixman_fixed_t);

   function To_F32 is new
     Ada.Unchecked_Conversion (pixman_fixed_32_32_t, Fixed_32_32);
   function To_P32 is new
     Ada.Unchecked_Conversion (Fixed_32_32, pixman_fixed_32_32_t);

   function To_U64 is new Ada.Unchecked_Conversion (Fixed_32_32, Unsigned_64);
   function To_F32_U is new
     Ada.Unchecked_Conversion (Unsigned_64, Fixed_32_32);

   function Cast (F : pixman_fixed_t) return Fixed_16_16
   is (To_F16 (F));
   function Cast (F : Fixed_16_16) return pixman_fixed_t
   is (To_P16 (F));

   function Cast (F : pixman_fixed_32_32_t) return Fixed_32_32
   is (To_F32 (F));
   function Cast (F : Fixed_32_32) return pixman_fixed_32_32_t
   is (To_P32 (F));

   function Floor (F : Fixed_16_16) return Fixed_16_16
   is (Cast (pixman_fixed_floor (Cast (F))));

   function Ceil (F : Fixed_16_16) return Fixed_16_16
   is (Cast (pixman_fixed_ceil (Cast (F))));

   function Frac (F : Fixed_16_16) return Fixed_16_16
   is (Cast (pixman_fixed_frac (Cast (F))));

   function Mod_2 (F : Fixed_16_16) return Fixed_16_16
   is (Cast (pixman_fixed_mod_2 (Cast (F))));

   function Floor (F : Fixed_32_32) return Fixed_32_32 is
      Masked : constant Unsigned_64 := To_U64 (F) and 16#FFFF_FFFF_0000_0000#;
   begin
      return To_F32_U (Masked);
   end Floor;

   function Frac (F : Fixed_32_32) return Fixed_32_32
   is (F - Floor (F));

   function Ceil (F : Fixed_32_32) return Fixed_32_32 is
      Floor_Val : constant Fixed_32_32 := Floor (F);
   begin
      if F = Floor_Val then
         return F;
      else
         return To_F32_U (To_U64 (Floor_Val) + 16#0000_0001_0000_0000#);
      end if;
   end Ceil;
end Pixmada.Fixed;
