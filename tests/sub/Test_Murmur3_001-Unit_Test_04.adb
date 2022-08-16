with Ada.Integer_Text_IO;

separate (Test_Murmur3_001)
procedure Unit_Test_04 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);

   use Interfaces;


   subtype key_index is Natural range 0..255;
   type key_array is array (key_index) of unsigned_8;
   type hash_array is array (key_index) of unsigned_32;

   key : key_array := [others => 0];
   Hashes :  hash_array;
   Final :  unsigned_32;
   verification : unsigned_32;

   Hash_expected : constant unsigned_32 := 16#B0F57EE3#;
   Hash_computed : unsigned_32;

   package MuRMuR is new AdaForge.Crypto.MuRMuRHash3 (Object => key_array);

   package Final_MuRMuR is new AdaForge.Crypto.MuRMuRHash3 (Object => hash_array);

   package Hex_String_8  is new Ada.Text_IO.Modular_IO (unsigned_8);
   package Hex_String_32 is new Ada.Text_IO.Modular_IO (unsigned_32);
   subtype String_32Hex is String(1..32/4 +4);
   Hash_computed_HexString : String_32Hex := [others => 'x'];
   Byte_Hex : String(1..2+4);

--   function Convert is new Ada.Unchecked_Conversion (Source => key_array, Target => key_Hex );

begin


   for i in key'Range loop
      key (i) := unsigned_8 (i);

      -- Hex_String_8.Put (To   => Byte_Hex,
      --              Item => key (i),
      --             Base  => 16);
      -- Ada.Text_IO.put (Byte_Hex);
   end loop;
   Ada.Text_IO.New_Line;

   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   -- Ada.Text_IO.Put_Line ("key'Size =" & key'Size'Image);
   -- Ada.Text_IO.Put_Line ("key_index'First =" & key_index'First'Image);
   -- Ada.Text_IO.Put_Line ("key_index'Last =" & key_index'Last'Image);

   for i in key'Range loop
      -- Ada.Text_IO.Put("[");
      -- for j in 0..i loop
         -- Ada.Integer_Text_IO.Put(
         --       Item => j,
         --       To => Byte_Hex,
         --       Base =>16);
         -- Ada.Text_IO.Put( Byte_Hex(4..5));
      -- end loop;
      -- Ada.Text_IO.Put ("] =");
      MuRMuR.Hash_x86_32 (Key => Key,
                          Length => i,
                          Seed  => unsigned_32 (key_index'Range_Length-i),
                          Result => Hashes (i));
      Hex_String_32.Put (To   => Hash_computed_HexString,
                        Item => Hashes (i),
                        Base  => 16);
      Ada.Text_IO.put (Hash_computed_HexString);
      Ada.Text_IO.Put(" ");
   end loop;
   Ada.Text_IO.New_Line;

   -- ------------------ --
   -- MuRMuR.Hash_x86_32 --
   -- ------------------ --
   MuRMuR.Hash_x86_32 (Key => Key, 
                result => Final);
   Ada.Text_IO.Put_Line("======================");
   Hex_String_32.Put (To   => Hash_computed_HexString,
                     Item => Final,
                     Base  => 16);
   Ada.Text_IO.put_Line (Hash_computed_HexString);
   Assert (Hash_computed = Final and Final = Hash_expected, 
           "Hash_x86_32(""" 
--           & Key 
           & """) =" 
           & Hash_computed_HexString 
           & " result is not what is expected");

end Unit_Test_04;

-- bool VerificationTest ( pfHash hash, const int hashbits, uint32_t expected, bool verbose )
-- {
--   const int hashbytes = hashbits / 8;

--   uint8_t * key    = new uint8_t[256];
--   uint8_t * hashes = new uint8_t[hashbytes * 256];
--   uint8_t * final  = new uint8_t[hashbytes];

--   memset(key,0,256);
--   memset(hashes,0,hashbytes*256);
--   memset(final,0,hashbytes);

--   // Hash keys of the form {0}, {0,1}, {0,1,2}... up to N=255,using 256-N as
--   // the seed

--   for(int i = 0; i < 256; i++)
--   {
--     key[i] = (uint8_t)i;

--     hash(key,i,256-i,&hashes[i*hashbytes]);
--   }

--   // Then hash the result array

--   hash(hashes,hashbytes*256,0,final);

--   // The first four bytes of that hash, interpreted as a little-endian integer, is our
--   // verification value

--   uint32_t verification = (final[0] << 0) | (final[1] << 8) | (final[2] << 16) | (final[3] << 24);

--   delete [] key;
--   delete [] hashes;
--   delete [] final;

--   //----------

--   if(expected != verification)
--   {
--     if(verbose) printf("Verification value 0x%08X : Failed! (Expected 0x%08x)\n",verification,expected);
--     return false;
--   }
--   else
--   {
--     if(verbose) printf("Verification value 0x%08X : Passed!\n",verification);
--     return true;
--   }
-- }