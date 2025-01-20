-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
separate (Test_AdafHashMurm_002)
procedure Verification128_32_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;

   type Hash_Array is array (key_index) of Unsigned_128;
   subtype String_Hex128 is String(1..128/4 +4);
   Hash_computed_HexString : String_Hex128;

   -- /!\ Instantiation will rise warnings about unchecked conversions having different sizes.
   -- This is intentional as we cast 'Object' data to a formated 32- 64-bits array 
   -- use '-gnatwZ' to suppress warnings on those unchecked conversions 
   -- as the types are known at compile time and may have different smaller sizes (thus safe). 
   package MuRMuR is new AdaForge.Hash.MuRMuR3 (Object => Key_Array);
   package Final_MuRMuR is new AdaForge.Hash.MuRMuR3 (Object => Hash_Array);

   Hashes :  hash_array;
   Final : Unsigned_128;
   Hash_expected : constant Unsigned_128 := 16#79C0CA32C3944F38D61A233AB3ECE62A#;

   begin
      -- Hash_128 with 32-bit words
      -- --------------------------
      COMPUTE_HASHES_OF_DATA_ARRAY:
      for i in key'Range loop
         Hashes (i) := MuRMuR.Hash_128 (Key => Key,
                           Length => i,
                           Seed  => Unsigned_32 (key_index'Range_Length-i),
                           Word_Size => 32);
      end loop COMPUTE_HASHES_OF_DATA_ARRAY;

      -- COMPUTE_HASH_OF_HASHES:
      -- hash the resulting array of all 256 hashs
      Final := Final_MuRMuR.Hash_128 (Key => Hashes, Word_Size => 32);

      AdaForge.Crypto.Hex128_IO.Put (To => Hash_computed_HexString,
                                    Item => Final,
                                    Base => 16);

      -- Compare end-result
      Assert (Final = Hash_expected,
           "Hash_128 (32-bit words) = "
           & Hash_computed_HexString
           & " result is not what is expected");

end Verification128_32_Test;
