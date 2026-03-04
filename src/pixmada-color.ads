with Interfaces;    use Interfaces;
with Pixmada.Fixed; use Pixmada.Fixed;

package Pixmada.Color is
   subtype Color_Channel is Unsigned_16;
   type Color is record
      Red   : Color_Channel;
      Green : Color_Channel;
      Blue  : Color_Channel;
      Alpha : Color_Channel;
   end record
   with Size => 64;

   Full_Channel : constant Color_Channel := Color_Channel'Last;

   Transparent : constant Color :=
     (Red => 0, Green => 0, Blue => 0, Alpha => 0);

   Opaque_Black : constant Color :=
     (Red => 0, Green => 0, Blue => 0, Alpha => Full_Channel);

   Opaque_White : constant Color :=
     (Red   => Full_Channel,
      Green => Full_Channel,
      Blue  => Full_Channel,
      Alpha => Full_Channel);

   function Make
     (R, G, B : Color_Channel; A : Color_Channel := Full_Channel) return Color
   is (Red => R, Green => G, Blue => B, Alpha => A);

   function Gray
     (Value : Color_Channel; Alpha : Color_Channel := Full_Channel)
      return Color
   is (Red => Value, Green => Value, Blue => Value, Alpha => Alpha);

   subtype Channel_Fixed is Fixed_16_16 range 0.0 .. 1.0;

   type Color_Fixed is record
      Red   : Channel_Fixed;
      Green : Channel_Fixed;
      Blue  : Channel_Fixed;
      Alpha : Channel_Fixed;
   end record;

   function From_Fixed
     (R, G, B : Channel_Fixed; A : Channel_Fixed := 1.0) return Color;
   function To_Fixed (C : Color) return Color_Fixed;

   function Premultiply (C : Color) return Color;
   function Unpremultiply (C : Color) return Color;

   function Scale (C : Color; S : Channel_Fixed) return Color;
   function Lerp (A, B : Color; T : Channel_Fixed) return Color;
   function Over (Source : Color; Dest : Color) return Color;
   function Clamp (Value : Integer) return Color_Channel
   is (Color_Channel (Integer'Min (65_535, Integer'Max (0, Value))));

   function Max (A, B : Color_Channel) return Color_Channel
   is (Color_Channel'Max (A, B));

   function Min (A, B : Color_Channel) return Color_Channel
   is (Color_Channel'Min (A, B));

   function Is_Transparent (C : Color) return Boolean
   is (C.Alpha = 0);

   function Is_Opaque (C : Color) return Boolean
   is (C.Alpha = Full_Channel);

   function Has_Color (C : Color) return Boolean
   is (C.Alpha > 0
       and then (C.Red > 0 or else C.Green > 0 or else C.Blue > 0));
end Pixmada.Color;
