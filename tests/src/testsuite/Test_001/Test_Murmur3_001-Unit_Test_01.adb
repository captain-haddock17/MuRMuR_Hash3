-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------

separate (Test_AdafHashMurm_001)
procedure Unit_Test_01 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;

   subtype Array_0_4_Index is Natural range 0..4;
   type Array_0_4 is array (Array_0_4_Index) of Unsigned_8;

   subtype String_1 is String(1..1);
   subtype String_8 is String(1..8);
   subtype String_9 is String(1..9);
   subtype String_10 is String(1..10);
   subtype String_11 is String(1..11);

   -- /!\ Instantiation will rise warnings about unchecked conversions having different sizes.
   -- This is intentional as we cast 'Object' data to a formated 32- 64-bits array 
   -- use '-gnatwZ' to suppress warnings on those unchecked conversions 
   -- as the types are known at compile time and may have different smaller sizes (thus safe). 

   package MuRMuR_0_4 is new AdaForge.Hash.MuRMuR3 (Object => Array_0_4);
   package MuRMuR_1 is new AdaForge.Hash.MuRMuR3 (Object => String_1);
   package MuRMuR_8 is new AdaForge.Hash.MuRMuR3 (Object => String_8);
   package MuRMuR_9 is new AdaForge.Hash.MuRMuR3 (Object => String_9);
   package MuRMuR_10 is new AdaForge.Hash.MuRMuR3 (Object => String_10);
   package MuRMuR_11 is new AdaForge.Hash.MuRMuR3 (Object => String_11);
   Hash_computed : Unsigned_32;

   package Hex_String is new Ada.Text_IO.Modular_IO (Unsigned_32);
   subtype String_32Hex is String(1..32/4 +4);
   Hash_computed_HexString : String_32Hex := (others => 'x');

   key_0_4 : constant Array_0_4 := (0,1,2,3,4);
   key_1 : constant String_1 := "1";
   Data_8b : constant String_8 := "12345678";
   key_9 : constant String_9 := "123456789";
   key_10 : constant String_10 := "123456789A";
   key_11 : constant String_11 := "123456789AB";

   Hash_0_4_expected : constant array (Array_0_4_Index) of Unsigned_32
         := (16#4570315f#, 16#cea2a54e#, 16#15cc3b39#,16#ca6f1663#, 16#e5483c42#);

   Hash_1_expected : constant Unsigned_32 := 16#9416AC93#;
   Hash_8_expected : constant Unsigned_32 := 16#91B313CE#;
   Hash_9_expected : constant Unsigned_32 := 16#B4FEF382#;
   Hash_10_expected : constant Unsigned_32 := 16#2757142E#;
   Hash_11_expected : constant Unsigned_32 := 16#C59D82D7#;
   Hash_8Seed13_expected : constant Unsigned_32 := 16#84A4D4A7#;

begin

   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   for i in Array_0_4_Index loop
      Hash_computed := MuRMuR_0_4.Hash_32 (Key => Key_0_4,
                Length => i,
                Seed => Unsigned_32 (256 - i));

      Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
      Assert (Hash_computed = Hash_0_4_expected (i),
           "Hash_32 ("""
           & I'Image
           & """)="
           & Hash_computed_HexString
           & " result is not what is expected");
   end loop;

   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   Hash_computed := MuRMuR_1.Hash_32 (Key => Key_1);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_1_expected,
           "Hash_32 ("""
           & Key_1
           & """)="
           & Hash_computed_HexString
           & " result is not what is expected");

   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   Hash_computed := MuRMuR_8.Hash_32 (Key => Data_8b);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_8_expected,
           "Hash_32 ("""
           & Data_8b
           & """)="
           & Hash_computed_HexString
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   Hash_computed :=MuRMuR_9.Hash_32 (Key => Key_9);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_9_expected,
           "Hash_32 ("""
           & Key_9
           & """)="
           & Hash_computed_HexString
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   Hash_computed := MuRMuR_10.Hash_32 (Key => Key_10);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_10_expected,
           "Hash_32 ("""
           & Key_10
           & """)="
           & Hash_computed_HexString
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   Hash_computed := MuRMuR_11.Hash_32 (Key => Key_11);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_11_expected,
           "Hash_32 ("""
           & Key_11
           & """)="
           & Hash_computed_HexString
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   Hash_computed := MuRMuR_8.Hash_32 (Key => Data_8b, seed  => 13);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_8Seed13_expected,
           "Hash_32 ("""
           & Data_8b & """)="
           & Hash_computed_HexString
           & " result is not what is expected");

end Unit_Test_01;
