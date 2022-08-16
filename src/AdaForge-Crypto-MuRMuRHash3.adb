-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuRHash3 was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.

-- Note - The x86 and x64 versions do _not_ produce the same results, as the
-- algorithms are optimized for their respective platforms. You can still
-- compile and run any of them on any platform, but your performance with the
-- non-native version will be less than optimal.
--
-- https://github.com/aappleby/smhasher/blob/master/src/AdaForge.Crypto.MuRMuRHash3.cpp
-------------------------------------------------------------------------------
-- https://github.com/daisuke-t-jp/MurmurHash-Swift
-- https://github.com/daisuke-t-jp/MurmurHash-Swift/blob/master/Sources/MurmurHash/AdaForge.Crypto.MuRMuRHash3_x86_32.swift
-- https://github.com/daisuke-t-jp/MurmurHash-Swift/blob/master/Sources/MurmurHash/AdaForge.Crypto.MuRMuRHash3Tail.swift
-------------------------------------------------------------------------------
with Ada.Unchecked_Conversion;
with System;

with Ada.Text_IO;


package body AdaForge.Crypto.MuRMuRHash3 is

   type Unsigned_x86_128 is array (1 ..4) of unsigned_32;
   type Unsigned_x64_128 is array (1 ..2) of unsigned_64;
   
   subtype Key_index_8 is Positive range 1.. Object'Size / Unsigned_8'Size;
   type Key_String_8 is array (Key_index_8) of Unsigned_8;

   subtype Key_index_32 is Positive range 1.. Object'Size / Unsigned_32'Size;
   type Key_String_32 is array (Key_index_32) of Unsigned_32;
   
   subtype Key_index_64 is Positive range 1.. Object'Size / Unsigned_64'Size;
   type Key_String_64 is array (Key_index_64) of Unsigned_64;
      
   function Map_to_array_8 is new Ada.Unchecked_Conversion (
               Source => Object, 
               Target => Key_String_8);

   function Map_to_array_32 is new Ada.Unchecked_Conversion (
               Source => Object, 
               Target => Key_String_32);

   function Map_to_array_64 is new Ada.Unchecked_Conversion (
               Source => Object, 
               Target => Key_String_64);

   type Unsigned_8_32 is array (1 ..4) of unsigned_8;
   type Unsigned_8_64 is array (1 ..8) of unsigned_8;

   function Map_to_4bytes is new Ada.Unchecked_Conversion (
               Source => Unsigned_32, 
               Target => Unsigned_8_32);

   function Map_to_8bytes is new Ada.Unchecked_Conversion (
               Source => Unsigned_64, 
               Target => Unsigned_8_64);

   function Map_to_32 is new Ada.Unchecked_Conversion (
               Source => Unsigned_8_32,
               Target => Unsigned_32);

   function Map_to_64 is new Ada.Unchecked_Conversion (
               Source => Unsigned_8_64,
               Target => Unsigned_64);
      -------------------------------------------------------------------------------
      -- Block read - if your platform needs to do endian-swapping or can only
      -- handle aligned reads, do the conversion here

      -- type Bit_Order is (High_Order_First, Low_Order_First);
      -- System.Default_Bit_Order : Bit_Order
      -- Sytem.Word_Size    : constant := implementation-defined * Storage_Unit;
   
      function getblock_32 ( Block : Key_String_32; i : Integer ) return unsigned_32
      with inline is
         Block_4 : Unsigned_8_32 := Map_to_4bytes (Block (i));
         Block_4_reversed : Unsigned_8_32;
      begin
         -- case System.Default_Bit_Order is
         --    when System.High_Order_First =>
               return Block (i);
         --    when System.Low_Order_First =>
         --       Block_4 := Map_to_4bytes (Block (i));
         --       for j in reverse 1 .. 4 loop
         --          Block_4_reversed (4 -j +1) := Block_4 (j);
         --       end loop;
         --    return Map_to_32 (Block_4_reversed);
         -- end case;
      end getblock_32;
      
      function getblock_64 ( Block : Key_String_64; i : Integer ) return unsigned_64
      with inline is
         Block_8 : Unsigned_8_64;
         Block_8_reversed : Unsigned_8_64;
      begin
         case System.Default_Bit_Order is
            when System.High_Order_First =>
               Block_8 := Map_to_8bytes (Block (i));
               for j in reverse 1 .. 8 loop
                  Block_8_reversed (8 -j +1) := Block_8 (j);
               end loop;
               return Map_to_64 (Block_8_reversed);
            when System.Low_Order_First =>
               return Block (i);
         end case;
      end getblock_64;
   
   -------------------------------------------------------------------------------
   -- Finalization mix - force all bits of a hash block to avalanche
   
   function fmix32 ( hash_block : unsigned_32 ) return unsigned_32
   with inline is
      h : unsigned_32 := hash_block;
   begin
     h := h xor Shift_Right (h, 16);
     h := h * 16#85eb_ca6b#;
     h := h xor Shift_Right (h, 13);
     h := h * 16#c2b2_ae35#;
     h := h xor Shift_Right (h, 16);
   
     return h;
   end fmix32;
   
   ------------
   
   function fmix64 ( hash_block : unsigned_64 ) return unsigned_64
   with inline is
      k : unsigned_64 := hash_block;
   begin
     k := k xor Shift_Right (k, 33);
     k := k * 16#ff51_afd7_ed55_8ccd#;
     k := k xor Shift_Right (k, 33);
     k := k * 16#c4ce_b9fe_1a85_ec53#;
     k := k xor Shift_Right (k, 33);
   
     return k;
   end fmix64;
   
   -------------------------------------------------------------------------------
   -- 32 bits hash --
   -------------------------------------------------------------------------------
   
   procedure Hash_x86_32 ( 
               Key : Object;
               Length : Integer := Object'Size/8;
               Seed : unsigned_32 := 0;
               Result : out unsigned_32) is separate;
   
   function PHash_32 ( 
               Key : Object;
               Length : Integer := Object'Size/8;
               Seed : unsigned_32 := 0)
               return unsigned_32 is separate;

   -------------------------------------------------------------------------------
   -- 128 bits hash --
   -------------------------------------------------------------------------------
   
   -- ------------------- --
   -- Hash_x86_128 --
   -- ------------------- --
   procedure Hash_x86_128 ( 
               Key : in Object;
               seed : unsigned_32 := 0;
               result : out unsigned_128 ) is separate;

   -- ------------------- --
   -- Hash_x64_128 --
   -- ------------------- --
   procedure Hash_x64_128 ( 
               Key    : in Object; 
               seed   : unsigned_32 := 0;
               result : out unsigned_128) is separate;


end AdaForge.Crypto.MuRMuRHash3;