package body Pixmada.Fixed is
   Fixed_16_Scale : constant := 65536.0;
   Fixed_32_Scale : constant := 4294967296.0;

   -------------------------------------------------------------------
   --- 16.16 conversions
   -------------------------------------------------------------------
   function To_Fixed (F : pixman_fixed_t) return Fixed_16_16 is
   begin
      --- Pixman 16.16 fixed-point: divide by 2^16 to get real
      return Fixed_16_16 (F) / Fixed_16_Scale;
   end To_Fixed;

   function To_Pixman (F : Fixed_16_16) return pixman_fixed_t is
   begin
      return pixman_fixed_t (F * Fixed_16_Scale);
   end To_Pixman;

   -------------------------------------------------------------------
   --- 32.32 conversions
   -------------------------------------------------------------------
   function To_Fixed (F : pixman_fixed_32_32_t) return Fixed_32_32 is
   begin
      return Fixed_32_32 (F) / Fixed_32_Scale;
   end To_Fixed;

   function To_Pixman (F : Fixed_32_32) return pixman_fixed_32_32_t is
   begin
      return pixman_fixed_32_32_t (F * Fixed_32_Scale);
   end To_Pixman;
end Pixmada.Fixed;
