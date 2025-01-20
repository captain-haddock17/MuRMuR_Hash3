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
separate (AdaForge.Hash.MuRMuR3)
   ---------- --
   -- Hash_32 --
   ---------- --
   function Hash_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_32
   is
      Data        : Data_8b;
      Hash_Length : constant Integer := 4; -- = 32 bits
      nblocks     : constant Integer := Length / Hash_Length;
      Tail_Length : constant Integer := Length - nblocks*Hash_Length;

      -- for COMPUTE
      h1 : Unsigned_32 := Seed;
      k1 : Unsigned_32;
      c1 : constant Unsigned_32 := 16#cc9e_2d51#;
      c2 : constant Unsigned_32 := 16#1b87_3593#;

   begin

      Data := Map_to_Array (Key);

      if nblocks > 0 then
         MAP_Head:
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
         end MAP_Head;
      end if;

      if Tail_Length > 0 then
         TAIL:
         declare
            k1 : Unsigned_32 := 0;
         begin
            if Tail_Length >= 3 then
               k1 := k1 xor Shift_Left (
                     Unsigned_32 (Data (nblocks*Hash_Length + 3)),
                     16);
            end if;
            if Tail_Length >= 2 then
               k1 := k1 xor Shift_Left (
                     Unsigned_32 (Data (nblocks*Hash_Length + 2)),
                     8);
            end if;
            if Tail_Length >= 1 then
               k1 := k1 xor Unsigned_32 (Data (nblocks*Hash_Length + 1));
               k1 := @ * c1;
               k1 := Rotate_Left (k1, 15);
               k1 := @ * c2;
               h1 := h1 xor k1;
            end if;
         end TAIL;
      end if;

   FINALIZE:
      declare
      begin
         h1 := h1 xor Unsigned_32 (Length);
         h1 := fmix32 (h1);
      end FINALIZE;

      return h1;

   end Hash_32;
