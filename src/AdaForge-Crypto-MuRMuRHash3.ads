-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuRHash3 was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

with Interfaces;
use  Interfaces;

generic
   type Object is private;
package AdaForge.Crypto.MuRMuRHash3 is


   -- ------------ --
   -- 32 bits hash --
   -- ------------ --
   procedure Hash_x86_32 ( 
               Key: in Object; 
               Length : Integer := Object'Size/8;
               Seed   : unsigned_32 := 0; 
               Result : out unsigned_32);
--               with Pre => Length <= Object'Size/8;

   -- renames
   procedure Hash32  (
               Key: in Object; 
               Length : Integer := Object'Size/8;
               seed   : unsigned_32 := 0; 
               result : out unsigned_32)
      renames Hash_x86_32;

   -- almost same as Hash_x86_32 
   function PHash_32 ( 
               Key : Object;
               Length : Integer := Object'Size/8;
               seed : unsigned_32 := 0)
               return unsigned_32
               with Pre => Length <= Object'Size/8;

   -- ------------- --
   -- 128 bits hash --
   -- ------------- --

   procedure Hash_x86_128 ( 
               Key: in Object; 
               seed   : unsigned_32 := 0; 
               result : out unsigned_128);

   procedure Hash_x64_128 ( 
               Key: in Object; 
               seed   : unsigned_32 := 0;
               result : out unsigned_128);
   -- renames
   procedure Hash128 (
               Key: in Object; 
               seed   : unsigned_32 := 0;
               result : out unsigned_128)
      renames Hash_x64_128;

end AdaForge.Crypto.MuRMuRHash3;