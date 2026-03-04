with Pixmada.Fixed; use Pixmada.Fixed;

package Pixmada.Geometry is
   subtype Fixed is Fixed_16_16;

   type Point is record
      X : Fixed;
      Y : Fixed;
   end record;

   Origin : constant Point := (X => 0.0, Y => 0.0);

   subtype Non_Zero_Point is Point
   with Predicate => (Non_Zero_Point /= Origin);

   function "+" (L, R : Point) return Point;
   function "-" (L, R : Point) return Point;
   function "-" (P : Point) return Point;

   function "*" (P : Point; Scalar : Fixed) return Point;
   function "*" (Scalar : Fixed; P : Point) return Point;
   function "/" (P : Point; Scalar : Fixed) return Point;

   function Is_Zero (P : Point) return Boolean;
   function Dot (A, B : Point) return Fixed;
   function Cross (A, B : Point) return Fixed;
   function Perp (P : Point) return Point;
   function Perp_Clockwise (P : Point) return Point;

   function Length_Squared (P : Point) return Fixed;
   function Length (P : Point) return Fixed;
   function Normalized (P : Non_Zero_Point) return Non_Zero_Point
   with Post => Length (Normalized'Result) = 1.0;

   function Distance_Squared (A, B : Point) return Fixed;
   function Distance (A, B : Point) return Fixed;
   function Midpoint (A, B : Point) return Point;
   function Lerp (A, B : Point; T : Fixed) return Point;
   function Reflect (V, Normal : Point) return Point;

   function Project (A, Onto : Point) return Point;

   type Segment is record
      A : Point;
      B : Point;
   end record;

   function Direction (S : Segment) return Point;
   function Length_Squared (S : Segment) return Fixed;
   function Length (S : Segment) return Fixed;

   function "+" (S : Segment; Offset : Point) return Segment;
   function "-" (S : Segment; Offset : Point) return Segment;
private

end Pixmada.Geometry;
