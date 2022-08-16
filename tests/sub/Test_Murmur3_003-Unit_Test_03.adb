

separate (Test_Murmur3_003)
procedure Unit_Test_03 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);
begin


   -- procedure Hash_x86_32 ( 
   --             Key: in Object; 
   --             seed   : unsigned_32 := 0; 
   --             result : out unsigned_32);

   -- -- renames
   -- procedure Hash32  (
   --             Key: in Object; 
   --             seed   : unsigned_32 := 0; 
   --             result : out unsigned_32)
   --    renames Hash_x86_32;

   -- -- almost same as Hash_x86_32 
   -- function PHash_32 ( 
   --             Key : Object;
   --             seed : unsigned_32 := 0)
   --             return unsigned_32;


   --  Test for expected conditions. Multiple assertions
   --  and actions are ok:
   Assert (False, "Hash result is not what is expected");
end Unit_Test_03;

-- void AppendedZeroesTest ( pfHash hash, const int hashbits )
-- {
--   printf("Running sanity check 2");
  
--   Rand r(173994);

--   const int hashbytes = hashbits/8;

--   for(int rep = 0; rep < 100; rep++)
--   {
--     if(rep % 10 == 0) printf(".");

--     unsigned char key[256];

--     memset(key,0,sizeof(key));

--     r.rand_p(key,32);

--     uint32_t h1[16];
--     uint32_t h2[16];

--     memset(h1,0,hashbytes);
--     memset(h2,0,hashbytes);

--     for(int i = 0; i < 32; i++)
--     {
--       hash(key,32+i,0,h1);

--       if(memcmp(h1,h2,hashbytes) == 0)
--       {
--         printf("\n*********FAIL*********\n");
--         return;
--       }

--       memcpy(h2,h1,hashbytes);
--     }
--   }

--   printf("PASS\n");
-- }
