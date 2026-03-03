with Interfaces;   use Interfaces;
with Interfaces.C; use Interfaces.C;
with System;

package Pixmada.Thin is
   --- Integer type aliases
   subtype int8_t is Integer_8;
   subtype uint8_t is Unsigned_8;
   subtype int16_t is Integer_16;
   subtype uint16_t is Unsigned_16;
   subtype int32_t is Integer_32;
   subtype uint32_t is Unsigned_32;
   subtype int64_t is Integer_64;
   subtype uint64_t is Unsigned_64;

   --- Boolean
   subtype pixman_bool_t is int;

   --- Fixed point types
   subtype pixman_fixed_t is int32_t;
   subtype pixman_fixed_16_16_t is pixman_fixed_t;
   subtype pixman_fixed_32_32_t is int64_t;
   subtype pixman_fixed_48_16_t is pixman_fixed_32_32_t;
   subtype pixman_fixed_1_31_t is uint32_t;
   subtype pixman_fixed_1_16_t is uint32_t;

   --- Conversion functions
   function pixman_fixed_to_int (F : pixman_fixed_t) return int
   with Inline;
   function pixman_int_to_fixed (I : int) return pixman_fixed_t
   with Inline;

   function pixman_fixed_to_double (F : pixman_fixed_t) return double;
   function pixman_double_to_fixed (D : double) return pixman_fixed_t;

   --- 16.16 fixed constants
   pixman_fixed_e         : constant pixman_fixed_t := 1;
   pixman_fixed_1         : constant pixman_fixed_t := 16#0001_0000#;
   pixman_fixed_1_minus_e : constant pixman_fixed_t :=
     pixman_fixed_1 - pixman_fixed_e;
   pixman_fixed_minus_1   : constant pixman_fixed_t := -pixman_fixed_1;
   pixman_max_fixed_48_16 : constant pixman_fixed_48_16_t :=
     pixman_fixed_48_16_t'Last;
   pixman_min_fixed_48_16 : constant pixman_fixed_48_16_t :=
     pixman_fixed_48_16_t'First;

   --- Functions for fixed types
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

   --- Color
   type pixman_color_t is record
      red   : aliased uint16_t;
      green : aliased uint16_t;
      blue  : aliased uint16_t;
      alpha : aliased uint16_t;
   end record
   with Convention => C_Pass_By_Copy;

   --- Fixed point.
   type pixman_point_fixed_t is record
      x : aliased pixman_fixed_t;
      y : aliased pixman_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   --- Fixed line (composed of two fixed points).
   type pixman_line_fixed_t is record
      p1 : aliased pixman_point_fixed_t;
      p2 : aliased pixman_point_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   --- Vectors and matrices.
   type pixman_vector_3 is array (0 .. 2) of pixman_fixed_t;
   type pixman_vector_t is record
      vector : aliased pixman_vector_3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_matrix_3x3 is array (0 .. 2, 0 .. 2) of pixman_fixed_t;
   type pixman_matrix_t is record
      matrix : aliased pixman_matrix_3x3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_f_vector_3 is array (0 .. 2) of double;
   type pixman_f_vector_t is record
      v : aliased pixman_f_vector_3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_f_matrix_3x3 is array (0 .. 2, 0 .. 2) of double;
   type pixman_f_matrix_t is record
      m : aliased pixman_f_matrix_3x3;
   end record
   with Convention => C_Pass_By_Copy;

   --- Forward declaration
   type pixman_image_t is null record;

   --- Regions, rectangles and boxes.
   type pixman_region16_data_t is record
      size     : aliased long;
      numRects : aliased long;
      --- rects[size] is not explicitly represented; handled dynamically in C
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_rectangle16_t is record
      x      : aliased int16_t;
      y      : aliased int16_t;
      width  : aliased uint16_t;
      height : aliased uint16_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_box16_t is record
      x1 : aliased int16_t;
      y1 : aliased int16_t;
      x2 : aliased int16_t;
      y2 : aliased int16_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_region16_t is record
      extents : aliased pixman_box16_t;
      data    : access pixman_region16_data;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_region32_data_t is record
      size     : aliased long;
      numRects : aliased long;
      --- rects[size] is not explicitly represented; handled dynamically in C
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_rectangle32_t is record
      x      : aliased int32_t;
      y      : aliased int32_t;
      width  : aliased uint32_t;
      height : aliased uint32_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_box32_t is record
      x1 : aliased int32_t;
      y1 : aliased int32_t;
      x2 : aliased int32_t;
      y2 : aliased int32_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_region32_t is record
      extents : aliased pixman_box32_t;
      data    : access pixman_region32_data;
   end record
   with Convention => C_Pass_By_Copy;

   --- Gradient stop
   type pixman_gradient_stop_t is record
      x     : aliased pixman_fixed_t;
      color : aliased pixman_color_t;
   end record
   with Convention => C_Pass_By_Copy;

   subtype pixman_index_type_t is uint8_t;

   type pixman_rgba_array is array (0 .. 255) of aliased uint32_t;
   type pixman_ent_array is array (0 .. 32767) of aliased pixman_index_type_t;
   type pixman_indexed_t is record
      color : aliased pixman_bool_t;
      rgba  : aliased pixman_rgba_array;
      ent   : aliased pixman_ent_array;
   end record
   with Convention => C_Pass_By_Copy;

   subtype pixman_type_t is uint32_t;
   PIXMAN_TYPE_OTHER      : constant pixman_type_t := 0;
   PIXMAN_TYPE_A          : constant pixman_type_t := 1;
   PIXMAN_TYPE_ARGB       : constant pixman_type_t := 2;
   PIXMAN_TYPE_ABGR       : constant pixman_type_t := 3;
   PIXMAN_TYPE_COLOR      : constant pixman_type_t := 4;
   PIXMAN_TYPE_GRAY       : constant pixman_type_t := 5;
   PIXMAN_TYPE_YUY2       : constant pixman_type_t := 6;
   PIXMAN_TYPE_YV12       : constant pixman_type_t := 7;
   PIXMAN_TYPE_BGRA       : constant pixman_type_t := 8;
   PIXMAN_TYPE_RGBA       : constant pixman_type_t := 9;
   PIXMAN_TYPE_ARGB_SRGB  : constant pixman_type_t := 10;
   PIXMAN_TYPE_RGBA_FLOAT : constant pixman_type_t := 11;

   function pixman_format
     (bpp : uint32_t; typ : pixman_type_t; a, r, g, b : uint32_t)
      return uint32_t
   is (Shift_Left (bpp, 24)
       or Shift_Left (typ, 16)
       or Shift_Left (a, 12)
       or Shift_Left (r, 8)
       or Shift_Left (g, 4)
       or b)
   with Inline;

   function pixman_format_byte
     (bpp : uint32_t; typ : pixman_type_t; a, r, g, b : uint32_t)
      return uint32_t
   is (Shift_Left (Shift_Right (bpp, 3), 24)
       or Shift_Left (uint32_t (3), 22)
       or Shift_Left (typ, 16)
       or Shift_Left (Shift_Right (a, 3), 12)
       or Shift_Left (Shift_Right (r, 3), 8)
       or Shift_Left (Shift_Right (g, 3), 4)
       or Shift_Right (b, 3))
   with Inline;

   function pixman_format_reshift
     (val : uint32_t; ofs, num : uint32_t) return uint32_t
   is (Shift_Left
         (Shift_Right (val, Integer (ofs))
          and (Shift_Left (1, Integer (num)) - 1),
          Integer (Shift_Right (val, 22) and 3)));

   function pixman_format_bpp (f : uint32_t) return uint32_t
   is (pixman_format_reshift (f, 24, 8));

   function pixman_format_a (f : uint32_t) return uint32_t
   is (pixman_format_reshift (f, 12, 4));
   function pixman_format_r (f : uint32_t) return uint32_t
   is (pixman_format_reshift (f, 8, 4));
   function pixman_format_g (f : uint32_t) return uint32_t
   is (pixman_format_reshift (f, 4, 4));
   function pixman_format_b (f : uint32_t) return uint32_t
   is (pixman_format_reshift (f, 0, 4));

   function pixman_format_shift (f : uint32_t) return uint32_t
   is (Shift_Right (f, 22) and 3);

   function pixman_format_type (f : uint32_t) return uint32_t
   is (Shift_Right (f, 16) and 16#3F#);

   function pixman_format_rgb (f : uint32_t) return uint32_t
   is (f and 16#FFF#);

   function pixman_format_vis (f : uint32_t) return uint32_t
   is (f and 16#FFFF#);

   function pixman_format_depth (f : uint32_t) return uint32_t
   is (pixman_format_a (f)
       + pixman_format_r (f)
       + pixman_format_g (f)
       + pixman_format_b (f));

   function pixman_format_color (f : uint32_t) return Boolean
   is (pixman_format_type (f) = PIXMAN_TYPE_ARGB
       or else pixman_format_type (f) = PIXMAN_TYPE_ABGR
       or else pixman_format_type (f) = PIXMAN_TYPE_BGRA
       or else pixman_format_type (f) = PIXMAN_TYPE_RGBA
       or else pixman_format_type (f) = PIXMAN_TYPE_RGBA_FLOAT);

   subtype pixman_format_code_t is uint32_t;

   --- 128bpp formats
   --- PIXMAN_FORMAT_BYTE(128,PIXMAN_TYPE_RGBA_FLOAT,32,32,32,32),
   pixman_rgba_float : constant pixman_format_code_t := 16#10CB4444#;

   --- 96bpp formats
   --- PIXMAN_FORMAT_BYTE(96,PIXMAN_TYPE_RGBA_FLOAT,0,32,32,32),
   pixman_rgb_float : constant pixman_format_code_t := 16#CCB0444#;

   --- 32bpp formats
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ARGB,8,8,8,8),
   pixman_a8r8g8b8    : constant pixman_format_code_t := 16#20028888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ARGB,0,8,8,8),
   pixman_x8r8g8b8    : constant pixman_format_code_t := 16#20020888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ABGR,8,8,8,8),
   pixman_a8b8g8r8    : constant pixman_format_code_t := 16#20038888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ABGR,0,8,8,8),
   pixman_x8b8g8r8    : constant pixman_format_code_t := 16#20030888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_BGRA,8,8,8,8),
   pixman_b8g8r8a8    : constant pixman_format_code_t := 16#20088888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_BGRA,0,8,8,8),
   pixman_b8g8r8x8    : constant pixman_format_code_t := 16#20080888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_RGBA,8,8,8,8),
   pixman_r8g8b8a8    : constant pixman_format_code_t := 16#20098888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_RGBA,0,8,8,8),
   pixman_r8g8b8x8    : constant pixman_format_code_t := 16#20090888#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ARGB,0,6,6,6),
   pixman_x14r6g6b6   : constant pixman_format_code_t := 16#20020666#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ARGB,0,10,10,10),
   pixman_x2r10g10b10 : constant pixman_format_code_t := 16#20020AAA#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ARGB,2,10,10,10),
   pixman_a2r10g10b10 : constant pixman_format_code_t := 16#20022AAA#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ABGR,0,10,10,10),
   pixman_x2b10g10r10 : constant pixman_format_code_t := 16#20030AAA#;
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ABGR,2,10,10,10),
   pixman_a2b10g10r10 : constant pixman_format_code_t := 16#20032AAA#;

   --- sRGB formats
   --- PIXMAN_FORMAT(32,PIXMAN_TYPE_ARGB_SRGB,8,8,8,8),
   pixman_a8r8g8b8_srgb : constant pixman_format_code_t := 16#200A8888#;
   --- PIXMAN_FORMAT(24,PIXMAN_TYPE_ARGB_SRGB,0,8,8,8),
   pixman_r8g8b8_srgb   : constant pixman_format_code_t := 16#180A0888#;

   --- 24bpp formats
   --- PIXMAN_FORMAT(24,PIXMAN_TYPE_ABGR,0,8,8,8),
   pixman_r8g8b8 : constant pixman_format_code_t := 16#18020888#;
   --- PIXMAN_FORMAT(24,PIXMAN_TYPE_ABGR,0,8,8,8),
   pixman_b8g8r8 : constant pixman_format_code_t := 16#18030888#;

   --- 16bpp formats
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ARGB,0,5,6,5),
   pixman_r5g6b5   : constant pixman_format_code_t := 16#10020565#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ABGR,0,5,6,5),
   pixman_b5g6r5   : constant pixman_format_code_t := 16#10030565#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ARGB,1,5,5,5),
   pixman_a1r5g5b5 : constant pixman_format_code_t := 16#10021555#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ARGB,0,5,5,5),
   pixman_x1r5g5b5 : constant pixman_format_code_t := 16#10020555#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ABGR,1,5,5,5),
   pixman_a1b5g5r5 : constant pixman_format_code_t := 16#10031555#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ABGR,0,5,5,5),
   pixman_x1b5g5r5 : constant pixman_format_code_t := 16#10030555#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ARGB,4,4,4,4),
   pixman_a4r4g4b4 : constant pixman_format_code_t := 16#10024444#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ARGB,0,4,4,4),
   pixman_x4r4g4b4 : constant pixman_format_code_t := 16#10020444#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ABGR,4,4,4,4),
   pixman_a4b4g4r4 : constant pixman_format_code_t := 16#10034444#;
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_ABGR,0,4,4,4),
   pixman_x4b4g4r4 : constant pixman_format_code_t := 16#10030444#;

   --- 8bpp formats
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_A,8,0,0,0),
   pixman_a8       : constant pixman_format_code_t := 16#08018000#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_ARGB,0,3,3,2),
   pixman_r3g3b2   : constant pixman_format_code_t := 16#08020332#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_ABGR,0,3,3,2),
   pixman_b2g3r3   : constant pixman_format_code_t := 16#08030332#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_ARGB,2,2,2,2),
   pixman_a2r2g2b2 : constant pixman_format_code_t := 16#08022222#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_ABGR,2,2,2,2),
   pixman_a2b2g2r2 : constant pixman_format_code_t := 16#08032222#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_COLOR,0,0,0,0),
   pixman_c8       : constant pixman_format_code_t := 16#08040000#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_GRAY,0,0,0,0),
   pixman_g8       : constant pixman_format_code_t := 16#08050000#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_A,4,0,0,0),
   pixman_x4a4     : constant pixman_format_code_t := 16#08014000#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_COLOR,0,0,0,0),
   pixman_x4c4     : constant pixman_format_code_t := 16#08040000#;
   --- PIXMAN_FORMAT(8,PIXMAN_TYPE_GRAY,0,0,0,0),
   pixman_x4g4     : constant pixman_format_code_t := 16#08050000#;

   --- 4bpp formats
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_A,4,0,0,0),
   pixman_a4       : constant pixman_format_code_t := 16#04014000#;
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_ARGB,0,1,2,1),
   pixman_r1g2b1   : constant pixman_format_code_t := 16#04020121#;
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_ABGR,0,1,2,1),
   pixman_b1g2r1   : constant pixman_format_code_t := 16#04030121#;
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_ARGB,1,1,1,1),
   pixman_a1r1g1b1 : constant pixman_format_code_t := 16#04021111#;
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_ABGR,1,1,1,1),
   pixman_a1b1g1r1 : constant pixman_format_code_t := 16#04031111#;
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_COLOR,0,0,0,0),
   pixman_c4       : constant pixman_format_code_t := 16#04040000#;
   --- PIXMAN_FORMAT(4,PIXMAN_TYPE_GRAY,0,0,0,0),
   pixman_g4       : constant pixman_format_code_t := 16#04050000#;

   --- 1bpp formats
   --- PIXMAN_FORMAT(1,PIXMAN_TYPE_A,1,0,0,0),
   pixman_a1 : constant pixman_format_code_t := 16#01011000#;
   --- PIXMAN_FORMAT(1,PIXMAN_TYPE_GRAY,0,0,0,0),
   pixman_g1 : constant pixman_format_code_t := 16#01050000#;

   --- YUV formats
   --- PIXMAN_FORMAT(16,PIXMAN_TYPE_YUY2,0,0,0,0),
   pixman_yuy2 : constant pixman_format_code_t := 16#10060000#;
   --- PIXMAN_FORMAT(12,PIXMAN_TYPE_YV12,0,0,0,0)
   pixman_yv12 : constant pixman_format_code_t := 16#0C070000#;

   subtype pixman_kernel_t is uint32_t;

   PIXMAN_KERNEL_IMPULSE            : constant pixman_kernel_t := 0;
   PIXMAN_KERNEL_BOX                : constant pixman_kernel_t := 1;
   PIXMAN_KERNEL_LINEAR             : constant pixman_kernel_t := 2;
   PIXMAN_KERNEL_CUBIC              : constant pixman_kernel_t := 3;
   PIXMAN_KERNEL_GAUSSIAN           : constant pixman_kernel_t := 4;
   PIXMAN_KERNEL_LANCZOS2           : constant pixman_kernel_t := 5;
   PIXMAN_KERNEL_LANCZOS3           : constant pixman_kernel_t := 6;
   PIXMAN_KERNEL_LANCZOS3_STRETCHED : constant pixman_kernel_t := 7;

   type pixman_glyph_cache_t is record
      x     : int;
      y     : int;
      glyph : System.Address;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_edge_t is record
      x           : pixman_fixed_t;
      y           : pixman_fixed_t;
      stepx       : pixman_fixed_t;
      signdx      : pixman_fixed_t;
      dy          : pixman_fixed_t;
      dx          : pixman_fixed_t;
      stepx_small : pixman_fixed_t;
      stepx_big   : pixman_fixed_t;
      dx_small    : pixman_fixed_t;
      dx_big      : pixman_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_trapezoid_t is record
      top    : pixman_fixed_t;
      bottom : pixman_fixed_t;
      left   : pixman_line_fixed_t;
      right  : pixman_line_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_triangle_t is record
      p1 : pixman_point_fixed_t;
      p2 : pixman_point_fixed_t;
      p3 : pixman_point_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   function pixman_trapezoid_valid (t : pixman_trapezoid_t) return Boolean
   is ((t.left.p1.y /= t.left.p2.y)
       and then (t.right.p1.y /= t.right.p2.y)
       and then (t.bottom > t.top));

   type pixman_span_fix_t is record
      l : pixman_fixed_t;
      r : pixman_fixed_t;
      y : pixman_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_trap_t is record
      top    : pixman_span_fix_t;
      bottom : pixman_span_fix_t;
   end record
   with Convention => C_Pass_By_Copy;

private
   --- Helpers
   function To_Unsigned_32 (S : pixman_fixed_t) return uint32_t
   with Inline;
   function To_Signed_32 (U : uint32_t) return pixman_fixed_t
   with Inline;
   function Arithmetic_Shift_Right_32
     (X : pixman_fixed_t; N : Natural) return pixman_fixed_t
   with Inline;

end Pixmada.Thin;
