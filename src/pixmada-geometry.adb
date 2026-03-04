with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Pixmada.Geometry is

   function "+" (L, R : Point) return Point
   is (X => L.X + R.X, Y => L.Y + R.Y);

   function "-" (L, R : Point) return Point
   is (X => L.X - R.X, Y => L.Y - R.Y);

   function "-" (P : Point) return Point
   is (X => -P.X, Y => -P.Y);

   function "*" (P : Point; Scalar : Fixed) return Point
   is (X => P.X * Scalar, Y => P.Y * Scalar);

   function "*" (Scalar : Fixed; P : Point) return Point
   is (X => Scalar * P.X, Y => Scalar * P.Y);

   function "/" (P : Point; Scalar : Fixed) return Point
   is (X => P.X / Scalar, Y => P.Y / Scalar);

   function Is_Zero (P : Point) return Boolean
   is (P = Origin);

   function Dot (A, B : Point) return Fixed
   is (A.X * B.X + A.Y * B.Y);

   function Cross (A, B : Point) return Fixed
   is (A.X * B.Y - A.Y * B.X);

   function Perp (P : Point) return Point
   is (X => -P.Y, Y => P.X);

   function Perp_Clockwise (P : Point) return Point
   is (X => P.Y, Y => -P.X);

   function Length_Squared (P : Point) return Fixed
   is (Dot (P, P));

   function Length (P : Point) return Fixed
   is (Cast (Sqrt (Cast (Length_Squared (P)))));

   function Normalized (P : Non_Zero_Point) return Non_Zero_Point is
      L : constant Fixed := Length (P);
   begin
      return P / L;
   end Normalized;

   function Distance_Squared (A, B : Point) return Fixed
   is (Length_Squared (B - A));

   function Distance (A, B : Point) return Fixed
   is (Length (B - A));

   function Midpoint (A, B : Point) return Point
   is ((A + B) / 2.0);

   function Lerp (A, B : Point; T : Fixed) return Point
   is (A + T * (B - A));

   function Reflect (V, Normal : Point) return Point
   is (V - (2.0 * Dot (V, Normal)) * Normal);

   function Project (A, Onto : Point) return Point is
      Epsilon : constant Fixed := Fixed'Small;
      Den     : constant Fixed := Length_Squared (Onto);
   begin
      if Den <= Epsilon then
         return Origin;
      else
         return (Dot (A, Onto) / Den) * Onto;
      end if;
   end Project;

   function Direction (S : Segment) return Point
   is (S.B - S.A);

   function Length_Squared (S : Segment) return Fixed
   is (Length_Squared (Direction (S)));

   function Length (S : Segment) return Fixed
   is (Cast (Sqrt (Cast (Length_Squared (S)))));

   function "+" (S : Segment; Offset : Point) return Segment
   is (A => S.A + Offset, B => S.B + Offset);

   function "-" (S : Segment; Offset : Point) return Segment
   is (A => S.A - Offset, B => S.B - Offset);

end Pixmada.Geometry;
