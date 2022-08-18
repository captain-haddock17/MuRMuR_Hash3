with Ada.Integer_Text_IO;

separate (Test_Murmur3_002)
procedure Verification32_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;

   subtype key_index is Natural range 0..255;
   type key_array is array (key_index) of Unsigned_8;
   type hash_array is array (key_index) of Unsigned_32;

   key : key_array := [others => 0];
   Hashes :  hash_array;
   Final :  Unsigned_32;
   Verification32 : Unsigned_32;

   Hash_expected : constant Unsigned_32 := 16#B0F57EE3#;
   Hash_computed : Unsigned_32;

   package MuRMuR is new AdaForge.Crypto.MuRMuR_Hash3  (Object => key_array);

   package Final_MuRMuR is new AdaForge.Crypto.MuRMuR_Hash3  (Object => hash_array);

   package Hex_String_8  is new Ada.Text_IO.Modular_IO (Unsigned_8);
   package Hex_String_32 is new Ada.Text_IO.Modular_IO (Unsigned_32);
   subtype String_Hex32 is String(1..32/4 +4);
   Hash_computed_HexString : String_Hex32 := [others => 'x'];
   Byte_Hex : String(1..2+4);

begin


   -- Hash keys of the form [0], [0,1], [0,1,2] ... up to [0,...,255]
   -- using 256-N as the seed
   for i in key'Range loop
      key (i) := Unsigned_8 (i);
   end loop;

   -- ------------------ --
   -- MuRMuR.Hash_32    --
   -- ------------------ --
   for i in key'Range loop
      Hashes (i) := MuRMuR.Hash_32    (Key => Key,
                          Length => i,
                          Seed  => Unsigned_32 (key_index'Range_Length-i));
   end loop;

   --  Then hash the resulting array of all 256 hashs
   Final := Final_MuRMuR.Hash_32    (Key => Hashes);

   Hex_String_32.Put (To   => Hash_computed_HexString,
                     Item => Final,
                     Base  => 16);

   Assert (Final = Hash_expected,
           "Hash_32   ("""
--           & Key
           & """) ="
           & Hash_computed_HexString
           & " result is not what is expected");

end Verification32_Test;
