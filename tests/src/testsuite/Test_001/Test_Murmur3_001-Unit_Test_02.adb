-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
separate (Test_AdafHashMurm_001)
procedure Unit_Test_02 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);
   use Interfaces;

   subtype String8 is String(1..8);

   -- /!\ Instantiation will rise warnings about unchecked conversions having different sizes.
   -- This is intentional as we cast 'Object' data to a formated 32- 64-bits array 
   -- use '-gnatwZ' to suppress warnings on those unchecked conversions 
   -- as the types are known at compile time and may have different smaller sizes (thus safe). 
   package MuRMuR is new AdaForge.Hash.MuRMuR3 (Object => String8);
   Hash_computed : Unsigned_128;

   package Hex_String is new Ada.Text_IO.Modular_IO (Unsigned_128);
   subtype String_Hex128 is String(1..128/4 +4);
   Hash_computed_HexString : String_Hex128 := (others => '0');

   Key : constant String8 := "AdafHashMurmB";
   Hash_A_expected : constant Unsigned_128 := 16#575C741B575C741B814ECA625F62721F#;
   Hash_B_expected : constant Unsigned_128 := 16#37AD62E237AD62E239A70E3F039C2036#;

begin

   -- ------------------- --
   -- MuRMuR.Hash_128    --
   -- ------------------- --
   Hash_computed := MuRMuR.Hash_128 (Key => Key, Word_Size => 32);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_A_expected,
           "Hash_128 ("""
           & Key
           & """) = "
           & Hash_computed_HexString
           & " result is not what is expected");

   -- ------------------- --
   -- MuRMuR.Hash_128    --
   -- ------------------- --
   Hash_computed := MuRMuR.Hash_128 (Key => Key, Seed  => 13, Word_Size => 32);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_B_expected,
           "Hash_128 ("""
           & Key
           & """) + Seed = "
           & Hash_computed_HexString
           & " result is not what is expected");

end Unit_Test_02;
