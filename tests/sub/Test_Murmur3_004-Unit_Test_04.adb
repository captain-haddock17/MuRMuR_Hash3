-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
separate (Test_Murmur3_004)
procedure Unit_Test_04 (T : in out AUnit.Test_Cases.Test_Case'Class) is
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
end Unit_Test_04;

-- void TwoBytesKeygen ( int maxlen, KeyCallback & c )
-- {
--   //----------
--   // Compute # of keys

--   int keycount = 0;

--   for(int i = 2; i <= maxlen; i++) keycount += (int)chooseK(i,2);

--   keycount *= 255*255;

--   for(int i = 2; i <= maxlen; i++) keycount += i*255;

--   printf("Keyset 'TwoBytes' - up-to-%d-byte keys, %d total keys\n",maxlen, keycount);

--   c.reserve(keycount);

--   //----------
--   // Add all keys with one non-zero byte

--   uint8_t key(256);

--   memset(key,0,256);

--   for(int keylen = 2; keylen <= maxlen; keylen++)
--   for(int byteA = 0; byteA < keylen; byteA++)
--   {
--     for(int valA = 1; valA <= 255; valA++)
--     {
--       key(byteA) = (uint8_t)valA;

--       c(key,keylen);
--     }

--     key(byteA) = 0;
--   }

--   //----------
--   // Add all keys with two non-zero bytes

--   for(int keylen = 2; keylen <= maxlen; keylen++)
--   for(int byteA = 0; byteA < keylen-1; byteA++)
--   for(int byteB = byteA+1; byteB < keylen; byteB++)
--   {
--     for(int valA = 1; valA <= 255; valA++)
--     {
--       key(byteA) = (uint8_t)valA;

--       for(int valB = 1; valB <= 255; valB++)
--       {
--         key(byteB) = (uint8_t)valB;
--         c(key,keylen);
--       }

--       key(byteB) = 0;
--     }

--     key(byteA) = 0;
--   }
-- }

-- //-----------------------------------------------------------------------------

-- template< typename hashtype >
-- void DumpCollisionMap ( CollisionMap<hashtype,ByteVec> & cmap )
-- {
--   typedef CollisionMap<hashtype,ByteVec> cmap_t;

--   for(typename cmap_t::iterator it = cmap.begin(); it != cmap.end(); ++it)
--   {
--     const hashtype & hash = (*it).first;

--     printf("Hash - ");
--     printbytes(&hash,sizeof(hashtype));
--     printf("\n");

--     std::vector<ByteVec> & keys = (*it).second;

--     for(int i = 0; i < (int)keys.size(); i++)
--     {
--       ByteVec & key = keys(i);

--       printf("Key  - ");
--       printbytes(&key(0),(int)key.size());
--       printf("\n");
--     }
--     printf("\n");
--   }

-- }

-- // test code

-- void ReportCollisions ( pfHash hash )
-- {
--   printf("Hashing keyset\n");

--   std::vector<uint128_t> hashes;

--   HashCallback<uint128_t> c(hash,hashes);

--   TwoBytesKeygen(20,c);

--   printf("%d hashes\n",(int)hashes.size());

--   printf("Finding collisions\n");

--   HashSet<uint128_t> collisions;

--   FindCollisions(hashes,collisions,1000);

--   printf("%d collisions\n",(int)collisions.size());

--   printf("Mapping collisions\n");

--   CollisionMap<uint128_t,ByteVec> cmap;

--   CollisionCallback<uint128_t> c2(hash,collisions,cmap);

--   TwoBytesKeygen(20,c2);

--   printf("Dumping collisions\n");

--   DumpCollisionMap(cmap);
-- }
