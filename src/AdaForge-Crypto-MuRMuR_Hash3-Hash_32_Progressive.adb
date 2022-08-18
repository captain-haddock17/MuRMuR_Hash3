-------------------------------------------------------------------------------
--  MuRMuR_Hash (v3) was written by Austin Appleby,
--  and is placed in the public domain.
--  The author disclaims copyright in his C source code.
-------------------------------------------------------------------------------
--  William J. Franck has ported the C code to Ada with adaptations.
--
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
separate (AdaForge.Crypto.MuRMuR_Hash3)
   ---------------------- --
   -- Hash_32_Progressive --
   ---------------------- --
   function Hash_32_Progressive (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_32 is

      h1       : Unsigned_32 := Seed;
      carry    : Unsigned_32 := 0;
      c1       : constant Unsigned_32 := 16#cc9e_2d51#;
      c2       : constant Unsigned_32 := 16#1b87_3593#;
--      len      : constant Unsigned_32 := Key'Size / 8;
      Hash_Length : constant Integer := 4;

      -- PHash_32_Process --
      procedure PHash_32_Process (
               h1       : in out Unsigned_32;
               Carry    : in out Unsigned_32;
               Key  : Object;
               Len      : Unsigned_32) is
      -- for COMPUTE
      Data     : Data_8b;
--      block    : Unsigned_32_128; --FIXME Unsigned_32_128 := Key + nblocks * 4;
      nblocks  : constant Integer := Length / Hash_Length;
      k1       : Unsigned_32;
--      Tail_Length        : constant Integer := Integer (Carry mod Hash_Length);
      Tail_Length        : constant Integer := Length - nblocks * Hash_Length;

      begin

         Data := Map_to_Array (Key);

         declare
            Head_Data : constant Block_32 := Map_to_Block (Data);
         begin
         COMPUTE:
            for i in 1 .. nblocks loop
               k1 := Adapt_Indianess_32 (Head_Data (i));

               k1 := @ * c1;
               k1 := Rotate_Left (k1, 15);
               k1 := @ * c2;

               h1 := h1 xor k1;
               h1 := Rotate_Left (h1, 13);
               h1 := h1 * 5 + 16#e654_6b64#;
            end loop COMPUTE;
         end;
         -- Copy out new running hash and carry
         -- h1
         Carry := (Carry and not 16#FF#) or Unsigned_32 (Tail_Length);
      end PHash_32_Process;

      -- PHash_32_Result --
      function PHash_32_Result (
               h        : Unsigned_32;
               Carry    : Unsigned_32;
               Total_Length : Unsigned_32)
               return Unsigned_32 is
      begin
         TAIL:
            declare
               h1 : Unsigned_32 := h;
               k1 : Unsigned_32 := 0;
               Tail_Length        : constant Integer := Integer(Carry mod 4);
--             tail     : constant array (1 .. 4) of Unsigned_8 := ( others => 0); --FIXME Data (nblocks .. nblocks + Tail_Length));

            begin
               if Tail_Length > 0 then
                  k1 := k1 xor Shift_Left (Carry, (Hash_Length - Tail_Length) * 8);
                  k1 := @ * c1;
                  k1 := Rotate_Left (k1, 15);
                  k1 := @ * c2;
                  h1 := h1 xor k1;
               end if;
            end TAIL;

         FINALIZE:
         declare
         begin
            h1 := h1 xor Total_Length;
            h1 := fmix32 (h1);
         end FINALIZE;

         return h1;
      end PHash_32_Result;

   begin -- main
      PHash_32_Process (
               h1       => h1,
               Carry    => carry,
               Key  => Key,
               Len      => Unsigned_32 (Length));
      return PHash_32_Result (
               h        => h1,
               Carry    => carry,
               Total_Length => Unsigned_32 (Length));
   end Hash_32_Progressive;
