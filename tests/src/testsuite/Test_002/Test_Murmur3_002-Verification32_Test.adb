-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
separate (Test_AdafHashMurm_002)
procedure Verification32_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;

   type Hash_Array is array (key_index) of Unsigned_32;
   subtype String_Hex32 is String(1..32/4 +4);

   Hash_computed_HexString : String_Hex32 := (others => 'x');

   -- /!\ Instantiation will rise warnings about unchecked conversions having different sizes.
   -- This is intentional as we cast 'Object' data to a formated 32- 64-bits array 
   -- use '-gnatwZ' to suppress warnings on those unchecked conversions 
   -- as the types are known at compile time and may have different smaller sizes (thus safe). 
   package MuRMuR is new AdaForge.Hash.MuRMuR3 (Object => key_array);
   package Final_MuRMuR is new AdaForge.Hash.MuRMuR3 (Object => hash_array);

   Hashes :  Hash_Array;
   Final :  Unsigned_32;

   Hash_expected : constant Unsigned_32 := 16#B0F57EE3#;
   
-- ---- --
-- MAIN --
-- ---- --
begin
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   COMPUTE_HASHES_OF_DATA_ARRAY:
   for i in key'Range loop
      Hashes (i) := MuRMuR.Hash_32 (Key => Key,
                          Length => i,
                          Seed  => Unsigned_32 (key_index'Range_Length-i));
   end loop COMPUTE_HASHES_OF_DATA_ARRAY;

   -- COMPUTE_HASH_OF_HASHES:
   -- hash the resulting array of all 256 hashs
   Final := Final_MuRMuR.Hash_32 (Key => Hashes);

   AdaForge.Crypto.Hex32_IO.Put (To   => Hash_computed_HexString,
                     Item => Final,
                     Base  => 16);

   Assert (Final = Hash_expected,
           "Hash_32 ("""
--           & Key
           & """) ="
           & Hash_computed_HexString
           & " result is not what is expected");

end Verification32_Test;
