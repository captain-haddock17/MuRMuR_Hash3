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
   -- ----------- --
   -- Hash_128_32 --
   -- ----------- --
   function Hash_128_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_128 is

      Data        : Data_8b;
      Hash_Length : constant Integer := 16; -- bytes = 128 bits
      Nblocks     : constant Integer := Length / Hash_Length;
      Tail_Length : constant Integer := Length - Nblocks * Hash_Length;

      -- for COMPUTE
      h : Unsigned_32_128 := (others => Seed);
      k : Unsigned_32_128 := (others => 0);
      c : constant Unsigned_32_128 := (16#239b_961b#, 16#ab0e_9789#, 16#38b3_4ae5#, 16#a1e3_8b93#);

   begin

      Data := Map_to_Array (Key);

      if Nblocks > 0 then
         MAP_Head:
         declare
            Head_Data : constant Block_32_128 := Map_to_Block (Data);
         begin
            COMPUTE:
            for i in 1 .. Nblocks loop
               k (1) := Adapt_Indianess_32 (Head_Data (i)(1));
               k (2) := Adapt_Indianess_32 (Head_Data (i)(2));
               k (3) := Adapt_Indianess_32 (Head_Data (i)(3));
               k (4) := Adapt_Indianess_32 (Head_Data (i)(4));

               k (1) := @ * c (1);
               k (1) := Rotate_Left (k (1), 15);
               k (1) := @ * c (2);
               h (1) := h (1) xor k (1);

               h (1) := Rotate_Left (h (1), 19);
               h (1) := @ + h (2);
               h (1) := h (1) * 5 + 16#561c_cd1b#;

               k (2) := @ * c (2);
               k (2) := Rotate_Left (k (2), 16);
               k (2) := @ * c (3);
               h (2) := h (2) xor k (2);

               h (2) := Rotate_Left (h (2), 17);
               h (2) := @ + h (3);
               h (2) := h (2) * 5 + 16#0bca_a747#;

               k (3) := @ * c (3);
               k (3) := Rotate_Left (k (3), 17);
               k (3) := @ * c (4);
               h (3) := h (3) xor k (3);

               h (3) := Rotate_Left (h (3), 15);
               h (3) := @ + h (4);
               h (3) := h (3) * 5 + 16#96cd_1c35#;

               k (4) := @ * c (4);
               k (4) := Rotate_Left (k (4), 18);
               k (4) := @ * c (1);
               h (4) := h (4) xor k (4);

               h (4) := Rotate_Left (h (4), 13);
               h (4) := @ + h (1);
               h (4) := h (4) * 5 + 16#32ac_3b17#;
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
               j := (i -1) / 4;
                  k (j+1) := k (j+1) xor Shift_Left (
                        Unsigned_32 (Data (Nblocks * Hash_Length + i)),
                        8*(i-1)-32*(j));
               case i is
                  when 13 =>
                     k (4) := @ * c (4);
                     k (4) := Rotate_Left (k (4), 18);
                     k (4) := @ * c (1);
                     h (4) := h (4) xor k (4);
                  when 9 =>
                     k (3) := @ * c (3);
                     k (3) := Rotate_Left (k (3), 17);
                     k (3) := @ * c (4);
                     h (3) := h (3) xor k (3);
                  when 5 =>
                     k (2) := @ * c (2);
                     k (2) := Rotate_Left (k (2), 16);
                     k (2) := @ * c (3);
                     h (2) := h (2) xor k (2);
                  when 1 =>
                     k (1) := @ * c (1);
                     k (1) := Rotate_Left (k (1), 15);
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
         h (1) := h (1) xor Unsigned_32 (Length);
         h (2) := h (2) xor Unsigned_32 (Length);
         h (3) := h (3) xor Unsigned_32 (Length);
         h (4) := h (4) xor Unsigned_32 (Length);

         h (1) := @ + h (2);
         h (1) := @ + h (3);
         h (1) := @ + h (4);
         h (2) := @ + h (1);
         h (3) := @ + h (1);
         h (4) := @ + h (1);

         h (1) := fmix32 (h (1));
         h (2) := fmix32 (h (2));
         h (3) := fmix32 (h (3));
         h (4) := fmix32 (h (4));

         h (1) := @ + h (2);
         h (1) := @ + h (3);
         h (1) := @ + h (4);
         h (2) := @ + h (1);
         h (3) := @ + h (1);
         h (4) := @ + h (1);
      end FINALIZE;

      return Shift_Left(Unsigned_128 (h (4)), 96)
             or Shift_Left(Unsigned_128 (h (3)), 64)
             or Shift_Left(Unsigned_128 (h (2)), 32)
             or Unsigned_128 (h (1));

   end Hash_128_32;
