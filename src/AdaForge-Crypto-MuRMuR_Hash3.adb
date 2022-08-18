-------------------------------------------------------------------------------
--  MuRMuR_Hash (v3) was written by Austin Appleby,
--  and is placed in the public domain.
--  The author disclaims copyright in his C source code.
-------------------------------------------------------------------------------
--  William J. Franck has ported the C code to Ada with adaptations.
--  https://github.com/aappleby/smhasher/blob/master/src/MurmurHash3.cpp
--
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;

with Ada.Strings.Fixed;
use  Ada.Strings.Fixed;
package body AdaForge.Crypto.MuRMuR_Hash3  is

   use Interfaces;

   -- --------------------------------------------------- --
   -- Elementary binary Data definitions and compositions --
   -- --------------------------------------------------- --
   type Unsigned_8_32 is array (1 .. 4) of Unsigned_8;
   type Unsigned_8_64 is array (1 .. 8) of Unsigned_8;
   type Unsigned_32_128 is array (1 .. 4) of Unsigned_32;
   type Unsigned_64_128 is array (1 .. 2) of Unsigned_64;

   subtype String_Hex32 is String(1 .. 32/ 4 + 4);
   Null_String_Hex32 : constant String (1 .. 32/4) := (others => '0');

   subtype String_Hex128 is String(1 .. 128 / 4 + 4);
   Null_String_Hex128 : constant String (1 .. 128 / 4) := (others => '0');

   -- ----------------------------------------------- --
   -- Data and 32- 128-bits Block definitions of data --
   -- ----------------------------------------------- --
   type Data_8b is array (Natural range 1 .. Object'Size / Unsigned_8'Size)
      of Unsigned_8;
   type Block_32 is array (Natural range 1 .. Object'Size / Unsigned_32'Size)
      of Unsigned_32;

   type Block_32_128 is array (Natural range 1 .. Object'Size / Unsigned_32_128'Size)
      of Unsigned_32_128;
   type Block_64_128 is array (Natural range 1 .. Object'Size / Unsigned_64_128'Size)
      of Unsigned_64_128;

   -- ---------------------- --
   -- Binary mapping of data --
   -- ---------------------- --
   function Map_to_Array is new Ada.Unchecked_Conversion (
               Source => Object,
               Target => Data_8b);

   function Map_to_Block is new Ada.Unchecked_Conversion (
               Source => Data_8b,
               Target => Block_32);

   function Map_to_Block is new Ada.Unchecked_Conversion (
               Source => Data_8b,
               Target => Block_32_128);

   function Map_to_Block is new Ada.Unchecked_Conversion (
               Source => Data_8b,
               Target => Block_64_128);

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

   -- --------------- --
   -- Adapt_Indianess --
   -- --------------- --
   function Adapt_Indianess_32 (Block : Unsigned_32) return Unsigned_32
   with inline is
      Block_4 : Unsigned_8_32 := Map_to_4bytes (Block);
      Block_4_reversed : Unsigned_8_32;
   begin
      case System.Default_Bit_Order is
         when System.Low_Order_First =>
            return Block;
         when System.High_Order_First =>
            Block_4 := Map_to_4bytes (Block);
            for j in reverse 1 .. 4 loop
               Block_4_reversed (4 -j +1) := Block_4 (j);
            end loop;
            return Map_to_32 (Block_4_reversed);
      end case;
   end Adapt_Indianess_32;

   function Adapt_Indianess_64 (Block : Unsigned_64) return Unsigned_64
   with inline is
      Data_8b : Unsigned_8_64 := Map_to_8bytes (Block);
      Data_8b_reversed : Unsigned_8_64;
   begin
      case System.Default_Bit_Order is
         when System.Low_Order_First =>
            return Block;
         when System.High_Order_First =>
            Data_8b := Map_to_8bytes (Block);
            for j in reverse 1 .. 8 loop
               Data_8b_reversed (8 -j +1) := Data_8b (j);
            end loop;
            return Map_to_64 (Data_8b_reversed);
      end case;
   end Adapt_Indianess_64;

   ----------------------
   -- Finalization mix -
   ----------------------
   function fmix32 ( hash_block : Unsigned_32) return Unsigned_32
   with inline is
      -- force all bits of a hash block to avalanche
      h : Unsigned_32 := hash_block;
   begin
      h := h xor Shift_Right (h, 16);
      h := h * 16#85eb_ca6b#;
      h := h xor Shift_Right (h, 13);
      h := h * 16#c2b2_ae35#;
      h := h xor Shift_Right (h, 16);
      return h;
   end fmix32;

   function fmix64 ( hash_block : Unsigned_64) return Unsigned_64
   with inline is
      k : Unsigned_64 := hash_block;
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
   -- Hash_32() return Unsigned_32 --
   -- ---------------------------- --
   function Hash_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_32 is separate;

   -- --------------------------- --
   -- Hash_32() return Hex String --
   -- --------------------------- --
   function Hash_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return String is
      Hash_computed : Unsigned_32 :=0;
      Hash_computed_HexString : String_Hex32 := (others => '0');
   begin
      Hash_computed := Hash_32 (Key, Length, Seed);
      Hex32_IO.Put (To   => Hash_computed_HexString,
                    Item => Hash_computed,
                    Base  => 16);
      return Overwrite (Source  => Null_String_Hex32,
                       Position => 1 + Null_String_Hex32'Length - (Hash_computed_HexString'Length-4),
                       New_Item => Hash_computed_HexString (4..String_Hex32'Last-1));
   end Hash_32;

   -- Progressive Hash_32
   -- ------------------- --
   function Hash_32_Progressive (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_32 is separate;

   -------------------------------------------------------------------------------
   -- 128 bits hash --
   -------------------------------------------------------------------------------
   -- Hash_128 with 32-bits words returns Unsigned_128 --
   -- ------------------------------------------------ --
   function Hash_128_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_128 is separate;

   -- ------------------------------- --
   -- Hash_128_32() return Hex String --
   -- ------------------------------- --
   function Hash_128_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return String is
      Hash_computed : Unsigned_128 :=0;
      Hash_computed_HexString : String_Hex128 := (others => '0');
   begin
      Hash_computed := Hash_128_32 (Key, Length, Seed);
      Hex128_IO.Put (To   => Hash_computed_HexString,
                     Item => Hash_computed,
                     Base  => 16);
      return Overwrite (Source  => Null_String_Hex128,
                       Position => 1 + Null_String_Hex128'Length - (Hash_computed_HexString'Length-4),
                       New_Item => Hash_computed_HexString (4..String_Hex128'Last-1));
   end Hash_128_32;

   -- ------------------------------------------------ --
   -- Hash_128 with 64-bits words returns Unsigned_128 --
   -- ------------------------------------------------ --
   function Hash_128_64 (
               Key    : Object;
               Length : Natural := Object'Size / 8;
               Seed   : Unsigned_32 := 0)
               return Unsigned_128 is separate;

   function Hash_128_64 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return String is
      Hash_computed : Unsigned_128 :=0;
      Hash_computed_HexString : String_Hex128 := (others => '0');
   begin
      Hash_computed := Hash_128_64 (Key, Length, Seed);
      Hex128_IO.Put (To   => Hash_computed_HexString,
                     Item => Hash_computed,
                     Base  => 16);
      return Overwrite (Source  => Null_String_Hex128,
                       Position => 1 + Null_String_Hex128'Length - (Hash_computed_HexString'Length-4),
                       New_Item => Hash_computed_HexString (4..String_Hex128'Last-1));
   end Hash_128_64;

   -- ----------------------------------------- --
   -- Hash_128 32/64 words returns Unsigned_128 --
   -- ----------------------------------------- --
   function Hash_128 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0;
               Word_Size : Integer := System.Word_Size)
               return Unsigned_128 is
   begin
      case Word_Size is
         when 64 =>
            return Hash_128_64 (Key, Length, Seed);
         when others =>
            return Hash_128_32 (Key, Length, Seed);
      end case;
   end Hash_128;

   function Hash_128 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0;
               Word_Size : Integer := System.Word_Size)
               return String is
   begin
      case Word_Size is
         when 64 =>
            return Hash_128_64 (Key, Length, Seed);
         when others =>
            return Hash_128_32 (Key, Length, Seed);
      end case;
   end Hash_128;

end AdaForge.Crypto.MuRMuR_Hash3;
