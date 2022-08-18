

separate (Test_Murmur3_001)
procedure Unit_Test_03 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);
   use Interfaces;

   subtype String8 is String(1..8);
   package MuRMuR is new AdaForge.Crypto.MuRMuR_Hash3  (Object => String8);
   Hash_computed : Unsigned_128;

   package Hex_String is new Ada.Text_IO.Modular_IO (Unsigned_128);
   subtype String_Hex128 is String(1..128/4 +4);
   Hash_computed_HexString : String_Hex128 := [others => '0'];

   Key : constant String8 := "Murmur3C";
   Hash_A_expected : constant Unsigned_128 := 16#6FE4ED426FE4ED420C00223F8CAC2789#;
   Hash_B_expected : constant Unsigned_128 := 16#723BEAEC723BEAEC0A9A5F87469CE4F7#;

begin

   -- ------------------- --
   -- MuRMuR.Hash_128    --
   -- ------------------- --
   Hash_computed := MuRMuR.Hash_128    (Key => Key, Word_Size => 128);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_A_expected,
           "Hash_128   ("""
           & Key
           & """) = "
           & Hash_computed_HexString
           & " result is not what is expected");

   -- ------------------- --
   -- MuRMuR.Hash_128    --
   -- ------------------- --
   Hash_computed := MuRMuR.Hash_128    (Key => Key, Seed  => 13, Word_Size => 128);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_B_expected,
           "Hash_128   ("""
           & Key
           & """) + Seed = "
           & Hash_computed_HexString
           & " result is not what is expected");

end Unit_Test_03;
