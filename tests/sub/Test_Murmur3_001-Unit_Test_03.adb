

separate (Test_Murmur3_001)
procedure Unit_Test_03 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);
   use Interfaces;

   subtype String8 is String(1..8);
   package MuRMuR is new AdaForge.Crypto.MuRMuRHash3 (Object => String8);
   Hash_computed : unsigned_128;

   package Hex_String is new Ada.Text_IO.Modular_IO (unsigned_128);
   subtype String_128Hex is String(1..128/4 +4);
   Hash_computed_HexString : String_128Hex := [others => 'x'];

   Key : constant String8 := "Murmur3C";
   Hash_A_expected : constant unsigned_128 := 16#51622DAA78F835834610ABE56EFF5CB5#;
   Hash_B_expected : constant unsigned_128 := 16#803BBF8EB6F0853FA4D8ECE9D7C0DFE3#;

begin

   -- ------------------- --
   -- MuRMuR.Hash_x64_128 --
   -- ------------------- --
   MuRMuR.Hash_x64_128 (Key => Key,
                result => Hash_computed);
   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_A_expected, 
           "Hash_x64_128(""" 
           & Key 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");

   -- ------------------- --
   -- MuRMuR.Hash_x64_128 --
   -- ------------------- --
   MuRMuR.Hash_x64_128 (Key => Key, 
                seed  => 13,
                result => Hash_computed);
   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_B_expected, 
           "Hash_x64_128(""" 
           & Key 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");

end Unit_Test_03;
