-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuR_Hash3  was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

with Ada.Text_IO;

with System;
with Interfaces;
use  Interfaces;

generic
   type Object is private;
package AdaForge.Crypto.MuRMuR_Hash3  is

   package Hex32_IO is new Ada.Text_IO.Modular_IO (Unsigned_32);
   package Hex128_IO is new Ada.Text_IO.Modular_IO (Unsigned_128);
   -- ------------ --
   -- 32 bits hash --
   -- ------------ --
   -- return Unsigned_32
   function Hash_32 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Unsigned_32 := 0)
               return Unsigned_32
               with Pre => Length <= Object'Size / 8;

   -- return String
   function Hash_32 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Unsigned_32 := 0)
               return String
               with Pre => Length <= Object'Size / 8;

   -- ------------- --
   -- 128 bits hash --
   -- ------------- --
   -- return Unsigned_128
   function Hash_128 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Unsigned_32 := 0;
               Word_Size : Integer := System.Word_Size)
               return Unsigned_128
               with Pre => Length <= Object'Size / 8;

   -- return String
   function Hash_128 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Unsigned_32 := 0;
               Word_Size : Integer := System.Word_Size)
               return String
               with Pre => Length <= Object'Size / 8;

end AdaForge.Crypto.MuRMuR_Hash3 ;