
separate (Test_Murmur3_001)
procedure Unit_Test_01 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;

   type Array_4 is array (0..3) of unsigned_8;
   subtype String_1 is String(1..1);
   subtype String_8 is String(1..8);
   subtype String_9 is String(1..9);
   subtype String_10 is String(1..10);
   subtype String_11 is String(1..11);

   package MuRMuR_03 is new AdaForge.Crypto.MuRMuRHash3 (Object => Array_4);
   package MuRMuR_1 is new AdaForge.Crypto.MuRMuRHash3 (Object => String_1);
   package MuRMuR_8 is new AdaForge.Crypto.MuRMuRHash3 (Object => String_8);
   package MuRMuR_9 is new AdaForge.Crypto.MuRMuRHash3 (Object => String_9);
   package MuRMuR_10 is new AdaForge.Crypto.MuRMuRHash3 (Object => String_10);
   package MuRMuR_11 is new AdaForge.Crypto.MuRMuRHash3 (Object => String_11);
   Hash_computed : unsigned_32;

   package Hex_String is new Ada.Text_IO.Modular_IO (unsigned_32);
   subtype String_32Hex is String(1..32/4 +4);
   Hash_computed_HexString : String_32Hex := [others => 'x'];

   key_03 : constant Array_4 := [0,1,2,3];
   key_1 : constant String_1 := "0";
   key_8 : constant String_8 := "12345678";
   key_9 : constant String_9 := "123456789";
   key_10 : constant String_10 := "123456789A";
   key_11 : constant String_11 := "123456789AB";

   Hash_1_expected : constant unsigned_32 := 16#A26ABCBE#;
   Hash_8_expected : constant unsigned_32 := 16#304125F3#;
   Hash_9_expected : constant unsigned_32 := 16#79519B4D#;
   Hash_10_expected : constant unsigned_32 := 16#B3E524F3#;
   Hash_11_expected : constant unsigned_32 := 16#A99E9FF6#;
   Hash_8Seed13_expected : constant unsigned_32 := 16#B3BA63C0#;

begin

   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_03.Hash_x86_32 (Key => Key_03,
                Length => 0,
                Seed => 4-0,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   -- Assert (Hash_computed = Hash_1_expected, 
   --         "Hash_x86_32(""" 
   --         & Key_1 
   --         & """)=" 
   --         & Hash_computed_HexString 
   --         & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_03.Hash_x86_32 (Key => Key_03,
               Length => 1,
                Seed => 4-1,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   -- Assert (Hash_computed = Hash_1_expected, 
   --         "Hash_x86_32(""" 
   --         & Key_1 
   --         & """)=" 
   --         & Hash_computed_HexString 
   --         & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_03.Hash_x86_32 (Key => Key_03,
                Length => 2,
                Seed => 4-2,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   -- Assert (Hash_computed = Hash_1_expected, 
   --         "Hash_x86_32(""" 
   --         & Key_1 
   --         & """)=" 
   --         & Hash_computed_HexString 
   --         & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_03.Hash_x86_32 (Key => Key_03,
                Length => 3,
                Seed => 4-3,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   -- Assert (Hash_computed = Hash_1_expected, 
   --         "Hash_x86_32(""" 
   --         & Key_1 
   --         & """)=" 
   --         & Hash_computed_HexString 
   --         & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_1.Hash_x86_32 (Key => Key_1,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_1_expected, 
           "Hash_x86_32(""" 
           & Key_1 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");

   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_8.Hash_x86_32 (Key => Key_8,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_8_expected, 
           "Hash_x86_32(""" 
           & Key_8 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_9.Hash_x86_32 (Key => Key_9,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_9_expected, 
           "Hash_x86_32(""" 
           & Key_9 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_10.Hash_x86_32 (Key => Key_10,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_10_expected, 
           "Hash_x86_32(""" 
           & Key_10 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_11.Hash_x86_32 (Key => Key_11,
                result => Hash_computed);

   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_11_expected, 
           "Hash_x86_32(""" 
           & Key_11 
           & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");
   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR_8.Hash_x86_32 (Key => Key_8, 
                seed  => 13,
                result => Hash_computed);
   Hex_String.Put (To   => Hash_computed_HexString,
                   Item => Hash_computed,
                  Base  => 16);
   Assert (Hash_computed = Hash_8Seed13_expected, 
           "Hash_x86_32(""" 
           & Key_8 & """)=" 
           & Hash_computed_HexString 
           & " result is not what is expected");

end Unit_Test_01;
