with Ada.Integer_Text_IO;

separate (Test_Murmur3_002)
procedure Verification128_64_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;

   subtype key_index is Natural range 0..255;

   type key_array is array (key_index) of Unsigned_8;
   package MuRMuR is new AdaForge.Crypto.MuRMuR_Hash3  (Object => Key_Array);

   type Hash_Array is array (key_index) of Unsigned_128;
   package Final_MuRMuR is new AdaForge.Crypto.MuRMuR_Hash3 (Object => Hash_Array);

   key : key_array := [others => 0];
   Final : Unsigned_128;
   Hash_expected : constant Unsigned_128 := 16#7192878CE684ED2D63F3DE036384BA69#;

   package Hex_String_8  is new Ada.Text_IO.Modular_IO (Unsigned_8);
   package Hex_String_32 is new Ada.Text_IO.Modular_IO (Unsigned_32);
   package Hex_String_128 is new Ada.Text_IO.Modular_IO (Unsigned_128);
   subtype String_Hex32 is String(1..32/4 +4);
   subtype String_Hex128 is String(1..128/4 +4);
   Hash_computed_HexString : String_Hex128 := [others => '0'];


   -- -------------------- --
   -- Verification128_Test --
   -- -------------------- --
   function Verification128_Test (Word_Size : Integer) return Unsigned_128 is

      Hashes :  hash_array;
      Hash_computed_HexString : String_Hex128 := [others => '0'];

   begin
      COMPUTE_HASHES_OF_DATA_ARRAY:
      for i in key'Range loop
         Hashes (i) := MuRMuR.Hash_128    (Key => Key,
                           Length => i,
                           Seed  => Unsigned_32 (key_index'Range_Length-i),
                           Word_Size => Word_Size);
         -- Hex_String_128.Put (To   => Hash_computed_HexString,
         --                Item => Hashes (i),
         --                Base  => 16);
         -- Ada.Text_IO.put_Line ("i =" & i'Image & " = " & Hash_computed_HexString);
      end loop COMPUTE_HASHES_OF_DATA_ARRAY;

      COMPUTE_HASH_OF_HASHES:
      --  Then hash the resulting array of all 256 hashs
      declare
      begin
         return Final_MuRMuR.Hash_128 (Key => Hashes, Word_Size => Word_Size);
      end COMPUTE_HASH_OF_HASHES;

   end Verification128_Test;

-- ---- --
-- MAIN --
-- ---- --
begin
   CREATE_DATA:
      -- Hash keys of the form [0], [0,1], [0,1,2] ... up to [0,...,255]
      -- using 256-N as the seed
      for i in key'Range loop
         key (i) := Unsigned_8 (i);
      end loop CREATE_DATA;

      -- Hash_128 with 64-bit words
      -- --------------------------
      Final := Verification128_Test (Word_Size => 64);

      Hex_String_128.Put (To => Hash_computed_HexString,
                     Item => Final,
                     Base => 16);
      Ada.Text_IO.put_Line ("Final = " & Hash_computed_HexString);

      -- Compare end-result
      Assert (Final = Hash_expected,
           "Hash_128 (64-bit words) = "
           & Hash_computed_HexString
           & " result is not what is expected");

end Verification128_64_Test;
