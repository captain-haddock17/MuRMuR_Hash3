-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
separate (Test_AdafHashMurm_002)
procedure Unit_Test_02 (T : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (T);
begin


   -- procedure Hash_x86_32 (
   --             Key: Object;
   --             seed   : Unsigned_32 := 0;
   --             result : out Unsigned_32);

   -- -- renames
   -- procedure Hash32 (
   --             Key: Object;
   --             seed   : Unsigned_32 := 0;
   --             result : out Unsigned_32)
   --    renames Hash_x86_32;

   -- -- almost same as Hash_x86_32
   -- function PHash_32 (
   --             Key : Object;
   --             seed : Unsigned_32 := 0)
   --             return Unsigned_32;


   --  Test for expected conditions. Multiple assertions
   --  and actions are ok:
   Assert (False, "Hash result is not what is expected");
end Unit_Test_02;

-- bool SanityTest ( pfHash hash, const int hashbits )
-- {
--   printf("Running sanity check 1");

--   Rand r(883741);

--   bool result = true;

--   const int hashbytes = hashbits/8;
--   const int reps = 10;
--   const int keymax = 256;
--   const int pad = 16;
--   const int buflen = keymax + pad*3;

--   uint8_t * buffer1 = new uint8_t(buflen);
--   uint8_t * buffer2 = new uint8_t(buflen);

--   uint8_t * hash1 = new uint8_t(hashbytes);
--   uint8_t * hash2 = new uint8_t(hashbytes);

--   //----------

--   for(int irep = 0; irep < reps; irep++)
--   {
--     if(irep % (reps/10) == 0) printf(".");

--     for(int len = 4; len <= keymax; len++)
--     {
--       for(int offset = pad; offset < pad*2; offset++)
--       {
--         uint8_t * key1 = &buffer1(pad);
--         uint8_t * key2 = &buffer2(pad+offset);

--         r.rand_p(buffer1,buflen);
--         r.rand_p(buffer2,buflen);

--         memcpy(key2,key1,len);

--         hash(key1,len,0,hash1);

--         for(int bit = 0; bit < (len * 8); bit++)
--         {
--           // Flip a bit, hash the key -> we should get a different result.

--           flipbit(key2,len,bit);
--           hash(key2,len,0,hash2);

--           if(memcmp(hash1,hash2,hashbytes) == 0)
--           {
--             result = false;
--           }

--           // Flip it back, hash again -> we should get the original result.

--           flipbit(key2,len,bit);
--           hash(key2,len,0,hash2);

--           if(memcmp(hash1,hash2,hashbytes) != 0)
--           {
--             result = false;
--           }
--         }
--       }
--     }
--   }

--   if(result == false)
--   {
--     printf("*********FAIL*********\n");
--   }
--   else
--   {
--     printf("PASS\n");
--   }

--   delete () buffer1;
--   delete () buffer2;

--   delete () hash1;
--   delete () hash2;

--   return result;
-- }
