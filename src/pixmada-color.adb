package body Pixmada.Color is

   Max_16  : constant Unsigned_32 := 16#FFFF#;
   Half_16 : constant Unsigned_32 := 16#7FFF#;

   function Mul_Div (A, B : Unsigned_32) return Unsigned_32 is
   begin
      return (A * B + Half_16) / Max_16;
   end Mul_Div;

   function Mul_Div (A, B : Color_Channel) return Color_Channel is
   begin
      return Color_Channel (Mul_Div (Unsigned_32 (A), Unsigned_32 (B)));
   end Mul_Div;

   function From_Fixed
     (R, G, B : Channel_Fixed; A : Channel_Fixed := 1.0) return Color
   is
      function To_C (F : Channel_Fixed) return Color_Channel is
         Raw : constant Unsigned_32 := Unsigned_32'Integer_Value (F);
      begin
         return Color_Channel (Shift_Right (Raw * Max_16, 16));
      end To_C;
   begin
      return (To_C (R), To_C (G), To_C (B), To_C (A));
   end From_Fixed;

   function To_Fixed (C : Color) return Color_Fixed is
      function To_F (Ch : Color_Channel) return Channel_Fixed is
         Val : constant Unsigned_32 :=
           Shift_Left (Unsigned_32 (Ch), 16) / Max_16;
      begin
         return Channel_Fixed'Fixed_Value (Val);
      end To_F;
   begin
      return (To_F (C.Red), To_F (C.Green), To_F (C.Blue), To_F (C.Alpha));
   end To_Fixed;

   function Premultiply (C : Color) return Color is
   begin
      if C.Alpha = Color_Channel (Max_16) then
         return C;
      end if;
      
      if C.Alpha = 0 then
         return Transparent;
      end if;

      return
        (Red   => Mul_Div (C.Red, C.Alpha),
         Green => Mul_Div (C.Green, C.Alpha),
         Blue  => Mul_Div (C.Blue, C.Alpha),
         Alpha => C.Alpha);
   end Premultiply;

   function Unpremultiply (C : Color) return Color is
   begin
      if C.Alpha = Color_Channel (Max_16) or else C.Alpha = 0 then
         return C;
      end if;

      declare
         A_32 : constant Unsigned_32 := Unsigned_32 (C.Alpha);
         function UPM (V : Color_Channel) return Color_Channel is
            T : constant Unsigned_32 := (Unsigned_32 (V) * Max_16) / A_32;
         begin
            return Color_Channel (Unsigned_32'Min (T, Max_16));
         end UPM;
      begin
         return (UPM (C.Red), UPM (C.Green), UPM (C.Blue), C.Alpha);
      end;
   end Unpremultiply;

   function Scale (C : Color; S : Channel_Fixed) return Color is
      Factor : constant Color_Channel :=
        Color_Channel
          (Shift_Right (Unsigned_32'Integer_Value (S) * Max_16, 16));
   begin
      return
        (Red   => Mul_Div (C.Red, Factor),
         Green => Mul_Div (C.Green, Factor),
         Blue  => Mul_Div (C.Blue, Factor),
         Alpha => Mul_Div (C.Alpha, Factor));
   end Scale;

   function Lerp (A, B : Color; T : Channel_Fixed) return Color is
      Weight_B : constant Unsigned_32 :=
        Shift_Right (Unsigned_32'Integer_Value (T) * Max_16, 16);
      Weight_A : constant Unsigned_32 := Max_16 - Weight_B;

      function L (V_A, V_B : Color_Channel) return Color_Channel is
         Val : constant Unsigned_32 :=
           (Unsigned_32 (V_A) * Weight_A + Unsigned_32 (V_B) * Weight_B);
      begin
         return Color_Channel ((Val + Half_16) / Max_16);
      end L;
   begin
      return
        (L (A.Red, B.Red),
         L (A.Green, B.Green),
         L (A.Blue, B.Blue),
         L (A.Alpha, B.Alpha));
   end Lerp;

   function Over (Source : Color; Dest : Color) return Color is
   begin
      if Source.Alpha = Color_Channel (Max_16) then
         return Source;
      end if;
      if Source.Alpha = 0 then
         return Dest;
      end if;

      declare
         S_A     : constant Unsigned_32 := Unsigned_32 (Source.Alpha);
         D_A     : constant Unsigned_32 := Unsigned_32 (Dest.Alpha);
         Inv_S_A : constant Unsigned_32 := Max_16 - S_A;
         Dst_W   : constant Unsigned_32 := Mul_Div (D_A, Inv_S_A);
         Out_A   : constant Unsigned_32 := S_A + Dst_W;
      begin
         if Out_A = 0 then
            return Transparent;
         end if;

         declare
            function Blend (S_C, D_C : Color_Channel) return Color_Channel is
               Numer : constant Unsigned_32 :=
                 (Unsigned_32 (S_C) * S_A) + (Unsigned_32 (D_C) * Dst_W);
            begin
               return Color_Channel (Unsigned_32'Min (Numer / Out_A, Max_16));
            end Blend;
         begin
            return
              (Red   => Blend (Source.Red, Dest.Red),
               Green => Blend (Source.Green, Dest.Green),
               Blue  => Blend (Source.Blue, Dest.Blue),
               Alpha => Color_Channel (Out_A));
         end;
      end;
   end Over;
end Pixmada.Color;
