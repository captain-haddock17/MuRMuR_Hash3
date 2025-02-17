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
   -- ----------- --
   -- Hash_128_64 --
   -- ----------- --
   function Hash_128_64 (
               Key    : Object;
               Length : Natural := Object'Size / 8;
               Seed   : Unsigned_32 := 0)
               return Unsigned_128 is

      Data        : Data_8b;
      Hash_Length : constant Integer := 16; -- bytes = 128 bits
      Nblocks     : constant Integer := Length / Hash_Length;
      Tail_Length : constant Integer := Length mod Hash_Length;

   -- for COMPUTE
      h : Unsigned_64_128 := (others => Unsigned_64 (Seed));
      k : Unsigned_64_128 := (others => 0);
      c : constant Unsigned_64_128 := (16#87c3_7b91_1142_53d5#, 16#4cf5_ad43_2745_937f#);

   begin

      Data := Map_to_Array (Key);

      if Nblocks > 0 then
         MAP_Head:
         declare
            Head_Data : constant Block_64_128 := Map_to_Block (Data);
         begin
            COMPUTE:
            for i in 1 .. Nblocks loop
               k (1) := Adapt_Indianess_64 (Head_Data (i)(1));
               k (2) := Adapt_Indianess_64 (Head_Data (i)(2));

               k (1) := @ * c (1);
               k (1) := Rotate_Left (k (1), 31);
               k (1) := @ * c (2);
               h (1) := h (1) xor k (1);

               h (1) := Rotate_Left (h (1), 27);
               h (1) := @ + h (2);
               h (1) := h (1) * 5 + 16#52dc_e729#;

               k (2) := @ * c (2);
               k (2) := Rotate_Left (k (2), 33);
               k (2) := @ * c (1);
               h (2) := h (2) xor k (2);

               h (2) := Rotate_Left (h (2), 31);
               h (2) := @ + h (1);
               h (2) := h (2) * 5 + 16#3849_5ab5#;
            end loop COMPUTE;
         end MAP_Head;
      end if;

      if Tail_Length > 0 then
         TAIL:
         declare
            j : integer;
         begin
            k := (others => 0);
            for i in reverse 1 .. Tail_Length loop
               j := (i -1) / 8;
                  k (j+1) := k (j+1) xor Shift_Left (
                        Unsigned_64 (Data (Nblocks * Hash_Length + i)),
                        8*(i-1)-64*(j));
               case i is
                  when 9 =>
                     k (2) := @ * c (2);
                     k (2) := Rotate_Left (k (2), 33);
                     k (2) := @ * c (1);
                     h (2) := h (2) xor k (2);
                  when 1 =>
                     k (1) := @ * c (1);
                     k (1) := Rotate_Left (k (1), 31);
                     k (1) := @ * c (2);
                     h (1) := h (1) xor k (1);
                  when others =>
                     null;
               end case;
            end loop;

         end TAIL;
      end if;

      FINALIZE:
      declare
      begin
         h (1) := h (1) xor Unsigned_64 (Length);
         h (2) := h (2) xor Unsigned_64 (Length);

         h (1) := @ + h (2);
         h (2) := @ + h (1);

         h (1) := fmix64 (h (1));
         h (2) := fmix64 (h (2));

         h (1) := @ + h (2);
         h (2) := @ + h (1);
      end FINALIZE;

      return Shift_Left(Unsigned_128 (h (2)), 64)
                or Unsigned_128 (h (1));

   end Hash_128_64;
