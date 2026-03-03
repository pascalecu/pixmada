with Interfaces;           use Interfaces;
with Interfaces.C;         use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
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
   type pixman_vector_3 is array (0 .. 2) of aliased pixman_fixed_t;
   type pixman_vector_t is record
      vector : aliased pixman_vector_3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_matrix_3x3 is array (0 .. 2, 0 .. 2) of aliased pixman_fixed_t;
   type pixman_transform_t is record
      matrix : aliased pixman_matrix_3x3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_f_vector_3 is array (0 .. 2) of aliased double;
   type pixman_f_vector_t is record
      v : aliased pixman_f_vector_3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_f_matrix_3x3 is array (0 .. 2, 0 .. 2) of aliased double;
   type pixman_f_transform_t is record
      m : aliased pixman_f_matrix_3x3;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_image_t is null record;

   type pixman_repeat_t is
     (PIXMAN_REPEAT_NONE,
      PIXMAN_REPEAT_NORMAL,
      PIXMAN_REPEAT_PAD,
      PIXMAN_REPEAT_REFLECT)
   with Convention => C;

   type pixman_dither_t is
     (PIXMAN_DITHER_NONE,
      PIXMAN_DITHER_FAST,
      PIXMAN_DITHER_GOOD,
      PIXMAN_DITHER_BEST,
      PIXMAN_DITHER_ORDERED_BAYER_8,
      PIXMAN_DITHER_ORDERED_BLUE_NOISE_64)
   with Convention => C;

   type pixman_filter_t is
     (PIXMAN_FILTER_FAST,
      PIXMAN_FILTER_GOOD,
      PIXMAN_FILTER_BEST,
      PIXMAN_FILTER_NEAREST,
      PIXMAN_FILTER_BILINEAR,
      PIXMAN_FILTER_CONVOLUTION,
      PIXMAN_FILTER_SEPARABLE_CONVOLUTION)
   with Convention => C;

   subtype pixman_op_t is unsigned;
   PIXMAN_OP_CLEAR                 : constant pixman_op_t := 0;
   PIXMAN_OP_SRC                   : constant pixman_op_t := 1;
   PIXMAN_OP_DST                   : constant pixman_op_t := 2;
   PIXMAN_OP_OVER                  : constant pixman_op_t := 3;
   PIXMAN_OP_OVER_REVERSE          : constant pixman_op_t := 4;
   PIXMAN_OP_IN                    : constant pixman_op_t := 5;
   PIXMAN_OP_IN_REVERSE            : constant pixman_op_t := 6;
   PIXMAN_OP_OUT                   : constant pixman_op_t := 7;
   PIXMAN_OP_OUT_REVERSE           : constant pixman_op_t := 8;
   PIXMAN_OP_ATOP                  : constant pixman_op_t := 9;
   PIXMAN_OP_ATOP_REVERSE          : constant pixman_op_t := 10;
   PIXMAN_OP_XOR                   : constant pixman_op_t := 11;
   PIXMAN_OP_ADD                   : constant pixman_op_t := 12;
   PIXMAN_OP_SATURATE              : constant pixman_op_t := 13;
   PIXMAN_OP_DISJOINT_CLEAR        : constant pixman_op_t := 16;
   PIXMAN_OP_DISJOINT_SRC          : constant pixman_op_t := 17;
   PIXMAN_OP_DISJOINT_DST          : constant pixman_op_t := 18;
   PIXMAN_OP_DISJOINT_OVER         : constant pixman_op_t := 19;
   PIXMAN_OP_DISJOINT_OVER_REVERSE : constant pixman_op_t := 20;
   PIXMAN_OP_DISJOINT_IN           : constant pixman_op_t := 21;
   PIXMAN_OP_DISJOINT_IN_REVERSE   : constant pixman_op_t := 22;
   PIXMAN_OP_DISJOINT_OUT          : constant pixman_op_t := 23;
   PIXMAN_OP_DISJOINT_OUT_REVERSE  : constant pixman_op_t := 24;
   PIXMAN_OP_DISJOINT_ATOP         : constant pixman_op_t := 25;
   PIXMAN_OP_DISJOINT_ATOP_REVERSE : constant pixman_op_t := 26;
   PIXMAN_OP_DISJOINT_XOR          : constant pixman_op_t := 27;
   PIXMAN_OP_CONJOINT_CLEAR        : constant pixman_op_t := 32;
   PIXMAN_OP_CONJOINT_SRC          : constant pixman_op_t := 33;
   PIXMAN_OP_CONJOINT_DST          : constant pixman_op_t := 34;
   PIXMAN_OP_CONJOINT_OVER         : constant pixman_op_t := 35;
   PIXMAN_OP_CONJOINT_OVER_REVERSE : constant pixman_op_t := 36;
   PIXMAN_OP_CONJOINT_IN           : constant pixman_op_t := 37;
   PIXMAN_OP_CONJOINT_IN_REVERSE   : constant pixman_op_t := 38;
   PIXMAN_OP_CONJOINT_OUT          : constant pixman_op_t := 39;
   PIXMAN_OP_CONJOINT_OUT_REVERSE  : constant pixman_op_t := 40;
   PIXMAN_OP_CONJOINT_ATOP         : constant pixman_op_t := 41;
   PIXMAN_OP_CONJOINT_ATOP_REVERSE : constant pixman_op_t := 42;
   PIXMAN_OP_CONJOINT_XOR          : constant pixman_op_t := 43;
   PIXMAN_OP_MULTIPLY              : constant pixman_op_t := 48;
   PIXMAN_OP_SCREEN                : constant pixman_op_t := 49;
   PIXMAN_OP_OVERLAY               : constant pixman_op_t := 50;
   PIXMAN_OP_DARKEN                : constant pixman_op_t := 51;
   PIXMAN_OP_LIGHTEN               : constant pixman_op_t := 52;
   PIXMAN_OP_COLOR_DODGE           : constant pixman_op_t := 53;
   PIXMAN_OP_COLOR_BURN            : constant pixman_op_t := 54;
   PIXMAN_OP_HARD_LIGHT            : constant pixman_op_t := 55;
   PIXMAN_OP_SOFT_LIGHT            : constant pixman_op_t := 56;
   PIXMAN_OP_DIFFERENCE            : constant pixman_op_t := 57;
   PIXMAN_OP_EXCLUSION             : constant pixman_op_t := 58;
   PIXMAN_OP_HSL_HUE               : constant pixman_op_t := 59;
   PIXMAN_OP_HSL_SATURATION        : constant pixman_op_t := 60;
   PIXMAN_OP_HSL_COLOR             : constant pixman_op_t := 61;
   PIXMAN_OP_HSL_LUMINOSITY        : constant pixman_op_t := 62;

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
      data    : access pixman_region16_data_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_region_overlap_t is
     (PIXMAN_REGION_OUT, PIXMAN_REGION_IN, PIXMAN_REGION_PART)
   with Convention => C;

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
      data    : access pixman_region32_data_t;
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

   type pixman_kernel_t is
     (PIXMAN_KERNEL_IMPULSE,
      PIXMAN_KERNEL_BOX,
      PIXMAN_KERNEL_LINEAR,
      PIXMAN_KERNEL_CUBIC,
      PIXMAN_KERNEL_GAUSSIAN,
      PIXMAN_KERNEL_LANCZOS2,
      PIXMAN_KERNEL_LANCZOS3,
      PIXMAN_KERNEL_LANCZOS3_STRETCHED)
   with Convention => C;

   type pixman_glyph_cache_t is null record;
   type pixman_glyph_t is record
      x     : aliased int;
      y     : aliased int;
      glyph : aliased System.Address;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_edge_t is record
      x           : aliased pixman_fixed_t;
      y           : aliased pixman_fixed_t;
      stepx       : aliased pixman_fixed_t;
      signdx      : aliased pixman_fixed_t;
      dy          : aliased pixman_fixed_t;
      dx          : aliased pixman_fixed_t;
      stepx_small : aliased pixman_fixed_t;
      stepx_big   : aliased pixman_fixed_t;
      dx_small    : aliased pixman_fixed_t;
      dx_big      : aliased pixman_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_trapezoid_t is record
      top    : aliased pixman_fixed_t;
      bottom : aliased pixman_fixed_t;
      left   : aliased pixman_line_fixed_t;
      right  : aliased pixman_line_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_triangle_t is record
      p1 : aliased pixman_point_fixed_t;
      p2 : aliased pixman_point_fixed_t;
      p3 : aliased pixman_point_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   function pixman_trapezoid_valid (t : pixman_trapezoid_t) return Boolean
   is ((t.left.p1.y /= t.left.p2.y)
       and then (t.right.p1.y /= t.right.p2.y)
       and then (t.bottom > t.top));

   type pixman_span_fix_t is record
      l : aliased pixman_fixed_t;
      r : aliased pixman_fixed_t;
      y : aliased pixman_fixed_t;
   end record
   with Convention => C_Pass_By_Copy;

   type pixman_trap_t is record
      top    : aliased pixman_span_fix_t;
      bottom : aliased pixman_span_fix_t;
   end record
   with Convention => C_Pass_By_Copy;

   --- Functions and procedures

   procedure pixman_transform_init_identity
     (matrix : access pixman_transform_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_init_identity";

   function pixman_transform_point_3d
     (transform : access constant pixman_transform_t;
      vector    : access pixman_vector_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_point_3d";

   function pixman_transform_point
     (transform : access constant pixman_transform_t;
      vector    : access pixman_vector_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_point";

   function pixman_transform_multiply
     (dst : access pixman_transform_t;
      l   : access constant pixman_transform_t;
      r   : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_multiply";

   procedure pixman_transform_init_scale
     (t : access pixman_transform_t; sx : pixman_fixed_t; sy : pixman_fixed_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_init_scale";

   function pixman_transform_scale
     (forward   : access pixman_transform_t;
      c_reverse : access pixman_transform_t;
      sx        : pixman_fixed_t;
      sy        : pixman_fixed_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_scale";

   procedure pixman_transform_init_rotate
     (t   : access pixman_transform_t;
      cos : pixman_fixed_t;
      sin : pixman_fixed_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_init_rotate";

   function pixman_transform_rotate
     (forward   : access pixman_transform_t;
      c_reverse : access pixman_transform_t;
      c         : pixman_fixed_t;
      s         : pixman_fixed_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_rotate";

   procedure pixman_transform_init_translate
     (t : access pixman_transform_t; tx : pixman_fixed_t; ty : pixman_fixed_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_init_translate";

   function pixman_transform_translate
     (forward   : access pixman_transform_t;
      c_reverse : access pixman_transform_t;
      tx        : pixman_fixed_t;
      ty        : pixman_fixed_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_translate";

   function pixman_transform_bounds
     (matrix : access constant pixman_transform_t; b : access pixman_box16_t)
      return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_bounds";

   function pixman_transform_invert
     (dst : access pixman_transform_t;
      src : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_invert";

   function pixman_transform_is_identity
     (t : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_is_identity";

   function pixman_transform_is_scale
     (t : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_is_scale";

   function pixman_transform_is_int_translate
     (t : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_is_int_translate";

   function pixman_transform_is_inverse
     (a : access constant pixman_transform_t;
      b : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_is_inverse";

   function pixman_transform_from_pixman_f_transform
     (t : access pixman_transform_t; ft : access constant pixman_f_transform_t)
      return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_transform_from_pixman_f_transform";

   procedure pixman_f_transform_from_pixman_transform
     (ft : access pixman_f_transform_t; t : access constant pixman_transform_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_from_pixman_transform";

   function pixman_f_transform_invert
     (dst : access pixman_f_transform_t;
      src : access constant pixman_f_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_invert";

   function pixman_f_transform_point
     (t : access constant pixman_f_transform_t; v : access pixman_f_vector_t)
      return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_point";

   procedure pixman_f_transform_point_3d
     (t : access constant pixman_f_transform_t; v : access pixman_f_vector_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_point_3d";

   procedure pixman_f_transform_multiply
     (dst : access pixman_f_transform_t;
      l   : access constant pixman_f_transform_t;
      r   : access constant pixman_f_transform_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_multiply";

   procedure pixman_f_transform_init_scale
     (t : access pixman_f_transform_t; sx : double; sy : double)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_init_scale";

   function pixman_f_transform_scale
     (forward   : access pixman_f_transform_t;
      c_reverse : access pixman_f_transform_t;
      sx        : double;
      sy        : double) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_scale";

   procedure pixman_f_transform_init_rotate
     (t : access pixman_f_transform_t; cos : double; sin : double)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_init_rotate";

   function pixman_f_transform_rotate
     (forward   : access pixman_f_transform_t;
      c_reverse : access pixman_f_transform_t;
      c         : double;
      s         : double) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_rotate";

   procedure pixman_f_transform_init_translate
     (t : access pixman_f_transform_t; tx : double; ty : double)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_init_translate";

   function pixman_f_transform_translate
     (forward   : access pixman_f_transform_t;
      c_reverse : access pixman_f_transform_t;
      tx        : double;
      ty        : double) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_translate";

   function pixman_f_transform_bounds
     (t : access constant pixman_f_transform_t; b : access pixman_box16_t)
      return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_bounds";

   procedure pixman_f_transform_init_identity (t : access pixman_f_transform_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_f_transform_init_identity";

   procedure pixman_region_set_static_pointers
     (empty_box   : access pixman_box16_t;
      empty_data  : access pixman_region16_data_t;
      broken_data : access pixman_region16_data_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_set_static_pointers";

   procedure pixman_region_init (region : access pixman_region16_t)
   with Import => True, Convention => C, External_Name => "pixman_region_init";

   procedure pixman_region_init_rect
     (region : access pixman_region16_t;
      x      : int;
      y      : int;
      width  : unsigned;
      height : unsigned)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_init_rect";

   function pixman_region_init_rects
     (region : access pixman_region16_t;
      boxes  : access constant pixman_box16_t;
      count  : int) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_init_rects";

   procedure pixman_region_init_with_extents
     (region  : access pixman_region16_t;
      extents : access constant pixman_box16_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_init_with_extents";

   procedure pixman_region_init_from_image
     (region : access pixman_region16_t; image : access pixman_image_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_init_from_image";

   procedure pixman_region_fini (region : access pixman_region16_t)
   with Import => True, Convention => C, External_Name => "pixman_region_fini";

   procedure pixman_region_translate
     (region : access pixman_region16_t; x : int; y : int)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_translate";

   function pixman_region_copy
     (dest   : access pixman_region16_t;
      source : access constant pixman_region16_t) return pixman_bool_t
   with Import => True, Convention => C, External_Name => "pixman_region_copy";

   function pixman_region_intersect
     (new_reg : access pixman_region16_t;
      reg1    : access constant pixman_region16_t;
      reg2    : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_intersect";

   function pixman_region_union
     (new_reg : access pixman_region16_t;
      reg1    : access constant pixman_region16_t;
      reg2    : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_union";

   function pixman_region_union_rect
     (dest   : access pixman_region16_t;
      source : access constant pixman_region16_t;
      x      : int;
      y      : int;
      width  : unsigned;
      height : unsigned) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_union_rect";

   function pixman_region_intersect_rect
     (dest   : access pixman_region16_t;
      source : access constant pixman_region16_t;
      x      : int;
      y      : int;
      width  : unsigned;
      height : unsigned) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_intersect_rect";

   function pixman_region_subtract
     (reg_d : access pixman_region16_t;
      reg_m : access constant pixman_region16_t;
      reg_s : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_subtract";

   function pixman_region_inverse
     (new_reg  : access pixman_region16_t;
      reg1     : access constant pixman_region16_t;
      inv_rect : access constant pixman_box16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_inverse";

   function pixman_region_contains_point
     (region : access constant pixman_region16_t;
      x      : int;
      y      : int;
      box    : access pixman_box16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_contains_point";

   function pixman_region_contains_rectangle
     (region : access constant pixman_region16_t;
      prect  : access constant pixman_box16_t) return pixman_region_overlap_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_contains_rectangle";

   function pixman_region_empty
     (region : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_empty";

   function pixman_region_not_empty
     (region : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_not_empty";

   function pixman_region_extents
     (region : access constant pixman_region16_t) return access pixman_box16_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_extents";

   function pixman_region_n_rects
     (region : access constant pixman_region16_t) return int
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_n_rects";

   function pixman_region_rectangles
     (region : access constant pixman_region16_t; n_rects : access int)
      return access pixman_box16_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_rectangles";

   function pixman_region_equal
     (region1 : access constant pixman_region16_t;
      region2 : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_equal";

   function pixman_region_selfcheck
     (region : access pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_selfcheck";

   procedure pixman_region_reset
     (region : access pixman_region16_t; box : access constant pixman_box16_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_reset";

   procedure pixman_region_clear (region : access pixman_region16_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region_clear";

   procedure pixman_region32_init (region : access pixman_region32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_init";

   procedure pixman_region32_init_rect
     (region : access pixman_region32_t;
      x      : int;
      y      : int;
      width  : unsigned;
      height : unsigned)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_init_rect";

   function pixman_region32_init_rects
     (region : access pixman_region32_t;
      boxes  : access constant pixman_box32_t;
      count  : int) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_init_rects";

   procedure pixman_region32_init_with_extents
     (region  : access pixman_region32_t;
      extents : access constant pixman_box32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_init_with_extents";

   procedure pixman_region32_init_from_image
     (region : access pixman_region32_t; image : access pixman_image_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_init_from_image";

   procedure pixman_region32_fini (region : access pixman_region32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_fini";

   procedure pixman_region32_translate
     (region : access pixman_region32_t; x : int; y : int)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_translate";

   function pixman_region32_copy
     (dest   : access pixman_region32_t;
      source : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_copy";

   function pixman_region32_intersect
     (new_reg : access pixman_region32_t;
      reg1    : access constant pixman_region32_t;
      reg2    : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_intersect";

   function pixman_region32_union
     (new_reg : access pixman_region32_t;
      reg1    : access constant pixman_region32_t;
      reg2    : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_union";

   function pixman_region32_intersect_rect
     (dest   : access pixman_region32_t;
      source : access constant pixman_region32_t;
      x      : int;
      y      : int;
      width  : unsigned;
      height : unsigned) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_intersect_rect";

   function pixman_region32_union_rect
     (dest   : access pixman_region32_t;
      source : access constant pixman_region32_t;
      x      : int;
      y      : int;
      width  : unsigned;
      height : unsigned) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_union_rect";

   function pixman_region32_subtract
     (reg_d : access pixman_region32_t;
      reg_m : access constant pixman_region32_t;
      reg_s : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_subtract";

   function pixman_region32_inverse
     (new_reg  : access pixman_region32_t;
      reg1     : access constant pixman_region32_t;
      inv_rect : access constant pixman_box32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_inverse";

   function pixman_region32_contains_point
     (region : access constant pixman_region32_t;
      x      : int;
      y      : int;
      box    : access pixman_box32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_contains_point";

   function pixman_region32_contains_rectangle
     (region : access constant pixman_region32_t;
      prect  : access constant pixman_box32_t) return pixman_region_overlap_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_contains_rectangle";

   function pixman_region32_empty
     (region : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_empty";

   function pixman_region32_not_empty
     (region : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_not_empty";

   function pixman_region32_extents
     (region : access constant pixman_region32_t) return access pixman_box32_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_extents";

   function pixman_region32_n_rects
     (region : access constant pixman_region32_t) return int
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_n_rects";

   function pixman_region32_rectangles
     (region : access constant pixman_region32_t; n_rects : access int)
      return access pixman_box32_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_rectangles";

   function pixman_region32_equal
     (region1 : access constant pixman_region32_t;
      region2 : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_equal";

   function pixman_region32_selfcheck
     (region : access pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_selfcheck";

   procedure pixman_region32_reset
     (region : access pixman_region32_t; box : access constant pixman_box32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_reset";

   procedure pixman_region32_clear (region : access pixman_region32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_region32_clear";

   function pixman_blt
     (src_bits   : access uint32_t;
      dst_bits   : access uint32_t;
      src_stride : int;
      dst_stride : int;
      src_bpp    : int;
      dst_bpp    : int;
      src_x      : int;
      src_y      : int;
      dest_x     : int;
      dest_y     : int;
      width      : int;
      height     : int) return pixman_bool_t
   with Import => True, Convention => C, External_Name => "pixman_blt";

   function pixman_fill
     (bits   : access uint32_t;
      stride : int;
      bpp    : int;
      x      : int;
      y      : int;
      width  : int;
      height : int;
      u_xor  : uint32_t) return pixman_bool_t
   with Import => True, Convention => C, External_Name => "pixman_fill";

   function pixman_version return int
   with Import => True, Convention => C, External_Name => "pixman_version";

   function pixman_version_string return chars_ptr
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_version_string";

   type pixman_read_memory_func_t is
     access function (arg1 : System.Address; arg2 : int) return uint32_t
   with Convention => C;

   type pixman_write_memory_func_t is
     access procedure (arg1 : System.Address; arg2 : uint32_t; arg3 : int)
   with Convention => C;

   type pixman_image_destroy_func_t is
     access procedure (arg1 : access pixman_image_t; arg2 : System.Address)
   with Convention => C;

   function pixman_format_supported_destination
     (format : pixman_format_code_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_format_supported_destination";

   function pixman_format_supported_source
     (format : pixman_format_code_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_format_supported_source";

   function pixman_image_create_solid_fill
     (color : access constant pixman_color_t) return access pixman_image_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_create_solid_fill";

   function pixman_image_create_linear_gradient
     (p1      : access constant pixman_point_fixed_t;
      p2      : access constant pixman_point_fixed_t;
      stops   : access constant pixman_gradient_stop_t;
      n_stops : int) return access pixman_image_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_create_linear_gradient";

   function pixman_image_create_radial_gradient
     (inner        : access constant pixman_point_fixed_t;
      outer        : access constant pixman_point_fixed_t;
      inner_radius : pixman_fixed_t;
      outer_radius : pixman_fixed_t;
      stops        : access constant pixman_gradient_stop_t;
      n_stops      : int) return access pixman_image_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_create_radial_gradient";

   function pixman_image_create_conical_gradient
     (center  : access constant pixman_point_fixed_t;
      angle   : pixman_fixed_t;
      stops   : access constant pixman_gradient_stop_t;
      n_stops : int) return access pixman_image_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_create_conical_gradient";

   function pixman_image_create_bits
     (format          : pixman_format_code_t;
      width           : int;
      height          : int;
      bits            : access uint32_t;
      rowstride_bytes : int) return access pixman_image_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_create_bits";

   function pixman_image_create_bits_no_clear
     (format          : pixman_format_code_t;
      width           : int;
      height          : int;
      bits            : access uint32_t;
      rowstride_bytes : int) return access pixman_image_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_create_bits_no_clear";

   function pixman_image_ref
     (image : access pixman_image_t) return access pixman_image_t
   with Import => True, Convention => C, External_Name => "pixman_image_ref";

   function pixman_image_unref
     (image : access pixman_image_t) return pixman_bool_t
   with Import => True, Convention => C, External_Name => "pixman_image_unref";

   procedure pixman_image_set_destroy_function
     (image      : access pixman_image_t;
      c_function : pixman_image_destroy_func_t;
      data       : System.Address)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_destroy_function";

   function pixman_image_get_destroy_data
     (image : access pixman_image_t) return System.Address
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_destroy_data";

   function pixman_image_set_clip_region
     (image  : access pixman_image_t;
      region : access constant pixman_region16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_clip_region";

   function pixman_image_set_clip_region32
     (image  : access pixman_image_t;
      region : access constant pixman_region32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_clip_region32";

   procedure pixman_image_set_has_client_clip
     (image : access pixman_image_t; clien_clip : pixman_bool_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_has_client_clip";

   function pixman_image_set_transform
     (image     : access pixman_image_t;
      transform : access constant pixman_transform_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_transform";

   procedure pixman_image_set_repeat
     (image : access pixman_image_t; repeat : pixman_repeat_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_repeat";

   procedure pixman_image_set_dither
     (image : access pixman_image_t; dither : pixman_dither_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_dither";

   procedure pixman_image_set_dither_offset
     (image : access pixman_image_t; offset_x : int; offset_y : int)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_dither_offset";

   function pixman_image_set_filter
     (image           : access pixman_image_t;
      filter          : pixman_filter_t;
      filter_params   : access pixman_fixed_t;
      n_filter_params : int) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_filter";

   procedure pixman_image_set_source_clipping
     (image : access pixman_image_t; source_clipping : pixman_bool_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_source_clipping";

   procedure pixman_image_set_alpha_map
     (image     : access pixman_image_t;
      alpha_map : access pixman_image_t;
      x         : int16_t;
      y         : int16_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_alpha_map";

   procedure pixman_image_set_component_alpha
     (image : access pixman_image_t; component_alpha : pixman_bool_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_component_alpha";

   function pixman_image_get_component_alpha
     (image : access pixman_image_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_component_alpha";

   procedure pixman_image_set_accessors
     (image      : access pixman_image_t;
      read_func  : pixman_read_memory_func_t;
      write_func : pixman_write_memory_func_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_accessors";

   procedure pixman_image_set_indexed
     (image   : access pixman_image_t;
      indexed : access constant pixman_indexed_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_set_indexed";

   function pixman_image_get_data
     (image : access pixman_image_t) return access uint32_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_data";

   function pixman_image_get_width (image : access pixman_image_t) return int
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_width";

   function pixman_image_get_height (image : access pixman_image_t) return int
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_height";

   function pixman_image_get_stride (image : access pixman_image_t) return int
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_stride";

   function pixman_image_get_depth (image : access pixman_image_t) return int
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_depth";

   function pixman_image_get_format
     (image : access pixman_image_t) return pixman_format_code_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_get_format";

   function pixman_filter_create_separable_convolution
     (n_values         : access int;
      scale_x          : pixman_fixed_t;
      scale_y          : pixman_fixed_t;
      reconstruct_x    : pixman_kernel_t;
      reconstruct_y    : pixman_kernel_t;
      sample_x         : pixman_kernel_t;
      sample_y         : pixman_kernel_t;
      subsample_bits_x : int;
      subsample_bits_y : int) return access pixman_fixed_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_filter_create_separable_convolution";

   function pixman_image_fill_rectangles
     (op      : pixman_op_t;
      image   : access pixman_image_t;
      color   : access constant pixman_color_t;
      n_rects : int;
      rects   : access constant pixman_rectangle16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_fill_rectangles";

   function pixman_image_fill_boxes
     (op      : pixman_op_t;
      dest    : access pixman_image_t;
      color   : access constant pixman_color_t;
      n_boxes : int;
      boxes   : access constant pixman_box32_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_fill_boxes";

   function pixman_compute_composite_region
     (region     : access pixman_region16_t;
      src_image  : access pixman_image_t;
      mask_image : access pixman_image_t;
      dest_image : access pixman_image_t;
      src_x      : int16_t;
      src_y      : int16_t;
      mask_x     : int16_t;
      mask_y     : int16_t;
      dest_x     : int16_t;
      dest_y     : int16_t;
      width      : uint16_t;
      height     : uint16_t) return pixman_bool_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_compute_composite_region";

   procedure pixman_image_composite
     (op     : pixman_op_t;
      src    : access pixman_image_t;
      mask   : access pixman_image_t;
      dest   : access pixman_image_t;
      src_x  : int16_t;
      src_y  : int16_t;
      mask_x : int16_t;
      mask_y : int16_t;
      dest_x : int16_t;
      dest_y : int16_t;
      width  : uint16_t;
      height : uint16_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_composite";

   procedure pixman_image_composite32
     (op     : pixman_op_t;
      src    : access pixman_image_t;
      mask   : access pixman_image_t;
      dest   : access pixman_image_t;
      src_x  : int32_t;
      src_y  : int32_t;
      mask_x : int32_t;
      mask_y : int32_t;
      dest_x : int32_t;
      dest_y : int32_t;
      width  : int32_t;
      height : int32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_image_composite32";

   function pixman_glyph_cache_create return access pixman_glyph_cache_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_create";

   procedure pixman_glyph_cache_destroy (cache : access pixman_glyph_cache_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_destroy";

   procedure pixman_glyph_cache_freeze (cache : access pixman_glyph_cache_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_freeze";

   procedure pixman_glyph_cache_thaw (cache : access pixman_glyph_cache_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_thaw";

   function pixman_glyph_cache_lookup
     (cache     : access pixman_glyph_cache_t;
      font_key  : System.Address;
      glyph_key : System.Address) return System.Address
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_lookup";

   function pixman_glyph_cache_insert
     (cache       : access pixman_glyph_cache_t;
      font_key    : System.Address;
      glyph_key   : System.Address;
      origin_x    : int;
      origin_y    : int;
      glyph_image : access pixman_image_t) return System.Address
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_insert";

   procedure pixman_glyph_cache_remove
     (cache     : access pixman_glyph_cache_t;
      font_key  : System.Address;
      glyph_key : System.Address)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_cache_remove";

   procedure pixman_glyph_get_extents
     (cache    : access pixman_glyph_cache_t;
      n_glyphs : int;
      glyphs   : access pixman_glyph_t;
      extents  : access pixman_box32_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_get_extents";

   function pixman_glyph_get_mask_format
     (cache    : access pixman_glyph_cache_t;
      n_glyphs : int;
      glyphs   : access constant pixman_glyph_t) return pixman_format_code_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_glyph_get_mask_format";

   procedure pixman_composite_glyphs
     (op          : pixman_op_t;
      src         : access pixman_image_t;
      dest        : access pixman_image_t;
      mask_format : pixman_format_code_t;
      src_x       : int32_t;
      src_y       : int32_t;
      mask_x      : int32_t;
      mask_y      : int32_t;
      dest_x      : int32_t;
      dest_y      : int32_t;
      width       : int32_t;
      height      : int32_t;
      cache       : access pixman_glyph_cache_t;
      n_glyphs    : int;
      glyphs      : access constant pixman_glyph_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_composite_glyphs";

   procedure pixman_composite_glyphs_no_mask
     (op       : pixman_op_t;
      src      : access pixman_image_t;
      dest     : access pixman_image_t;
      src_x    : int32_t;
      src_y    : int32_t;
      dest_x   : int32_t;
      dest_y   : int32_t;
      cache    : access pixman_glyph_cache_t;
      n_glyphs : int;
      glyphs   : access constant pixman_glyph_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_composite_glyphs_no_mask";

   function pixman_sample_ceil_y
     (y : pixman_fixed_t; bpp : int) return pixman_fixed_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_sample_ceil_y";

   function pixman_sample_floor_y
     (y : pixman_fixed_t; bpp : int) return pixman_fixed_t
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_sample_floor_y";

   procedure pixman_edge_step (e : access pixman_edge_t; n : int)
   with Import => True, Convention => C, External_Name => "pixman_edge_step";

   procedure pixman_edge_init
     (e       : access pixman_edge_t;
      bpp     : int;
      y_start : pixman_fixed_t;
      x_top   : pixman_fixed_t;
      y_top   : pixman_fixed_t;
      x_bot   : pixman_fixed_t;
      y_bot   : pixman_fixed_t)
   with Import => True, Convention => C, External_Name => "pixman_edge_init";

   procedure pixman_line_fixed_edge_init
     (e     : access pixman_edge_t;
      bpp   : int;
      y     : pixman_fixed_t;
      line  : access constant pixman_line_fixed_t;
      x_off : int;
      y_off : int)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_line_fixed_edge_init";

   procedure pixman_rasterize_edges
     (image : access pixman_image_t;
      l     : access pixman_edge_t;
      r     : access pixman_edge_t;
      t     : pixman_fixed_t;
      b     : pixman_fixed_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_rasterize_edges";

   procedure pixman_add_traps
     (image : access pixman_image_t;
      x_off : int16_t;
      y_off : int16_t;
      ntrap : int;
      traps : access constant pixman_trap_t)
   with Import => True, Convention => C, External_Name => "pixman_add_traps";

   procedure pixman_add_trapezoids
     (image  : access pixman_image_t;
      x_off  : int16_t;
      y_off  : int;
      ntraps : int;
      traps  : access constant pixman_trapezoid_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_add_trapezoids";

   procedure pixman_rasterize_trapezoid
     (image : access pixman_image_t;
      trap  : access constant pixman_trapezoid_t;
      x_off : int;
      y_off : int)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_rasterize_trapezoid";

   procedure pixman_composite_trapezoids
     (op          : pixman_op_t;
      src         : access pixman_image_t;
      dst         : access pixman_image_t;
      mask_format : pixman_format_code_t;
      x_src       : int;
      y_src       : int;
      x_dst       : int;
      y_dst       : int;
      n_traps     : int;
      traps       : access constant pixman_trapezoid_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_composite_trapezoids";

   procedure pixman_composite_triangles
     (op          : pixman_op_t;
      src         : access pixman_image_t;
      dst         : access pixman_image_t;
      mask_format : pixman_format_code_t;
      x_src       : int;
      y_src       : int;
      x_dst       : int;
      y_dst       : int;
      n_tris      : int;
      tris        : access constant pixman_triangle_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_composite_triangles";

   procedure pixman_add_triangles
     (image  : access pixman_image_t;
      x_off  : int32_t;
      y_off  : int32_t;
      n_tris : int;
      tris   : access constant pixman_triangle_t)
   with
     Import        => True,
     Convention    => C,
     External_Name => "pixman_add_triangles";
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