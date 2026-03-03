with Ada.Unchecked_Conversion;

package body Pixmada.Thin is

   function As_Unsigned is new
     Ada.Unchecked_Conversion (pixman_fixed_t, uint32_t);
   function As_Signed is new
     Ada.Unchecked_Conversion (uint32_t, pixman_fixed_t);

   function To_Unsigned_32 (S : pixman_fixed_t) return uint32_t
   is (As_Unsigned (S));

   function To_Signed_32 (U : uint32_t) return pixman_fixed_t
   is (As_Signed (U));

   function Arithmetic_Shift_Right_32
     (X : pixman_fixed_t; N : Natural) return pixman_fixed_t
   is
      U : constant uint32_t := As_Unsigned (X);
      R : uint32_t;
   begin
      if N = 0 then
         return X;
      elsif N >= 32 then
         return (if X < 0 then pixman_fixed_t (-1) else pixman_fixed_t (0));
      else
         R := Shift_Right (U, N);
         if X < 0 then
            R := R or Shift_Left (uint32_t'Last, 32 - N);
         end if;
         return To_Signed_32 (R);
      end if;
   end Arithmetic_Shift_Right_32;

   function pixman_fixed_to_int (F : pixman_fixed_t) return Interfaces.C.int is
      Shifted : constant pixman_fixed_t := Arithmetic_Shift_Right_32 (F, 16);
   begin
      return Interfaces.C.int (Shifted);
   end pixman_fixed_to_int;

   function pixman_int_to_fixed (I : int) return pixman_fixed_t is
      U : constant uint32_t := To_Unsigned_32 (pixman_fixed_t (I));
      S : constant uint32_t := Shift_Left (U, 16);
   begin
      return To_Signed_32 (S);
   end pixman_int_to_fixed;

   function pixman_fixed_to_double (F : pixman_fixed_t) return Long_Float is
   begin
      return Long_Float (F) / Long_Float (pixman_fixed_1);
   end pixman_fixed_to_double;

   function pixman_double_to_fixed (D : Long_Float) return pixman_fixed_t is
      Tmp : Long_Float := D * 65536.0;
   begin
      return pixman_fixed_t (Integer (Tmp));
   end pixman_double_to_fixed;

   function pixman_fixed_frac (F : pixman_fixed_t) return pixman_fixed_t is
      U    : constant uint32_t := To_Unsigned_32 (F);
      Mask : constant uint32_t := To_Unsigned_32 (pixman_fixed_1_minus_e);
   begin
      return To_Signed_32 (U and Mask);
   end pixman_fixed_frac;

   function pixman_fixed_floor (F : pixman_fixed_t) return pixman_fixed_t is
      U    : constant uint32_t := To_Unsigned_32 (F);
      Mask : constant uint32_t := not To_Unsigned_32 (pixman_fixed_1_minus_e);
   begin
      return To_Signed_32 (U and Mask);
   end pixman_fixed_floor;

   function pixman_fixed_ceil (F : pixman_fixed_t) return pixman_fixed_t is
   begin
      return pixman_fixed_floor (F + pixman_fixed_1_minus_e);
   end pixman_fixed_ceil;

   function pixman_fixed_fraction (F : pixman_fixed_t) return pixman_fixed_t is
   begin
      return pixman_fixed_frac (F);
   end pixman_fixed_fraction;

   function pixman_fixed_mod_2 (F : pixman_fixed_t) return pixman_fixed_t is
      U    : constant uint32_t := To_Unsigned_32 (F);
      Mask : constant uint32_t :=
        To_Unsigned_32 (pixman_fixed_1)
        or To_Unsigned_32 (pixman_fixed_1_minus_e);
   begin
      return To_Signed_32 (U and Mask);
   end pixman_fixed_mod_2;

end Pixmada.Thin;
