-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuR_Hash3  was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

separate (AdaForge.Crypto.MuRMuR_Hash3)
   -- ------------------- --
   -- Hash_128_64 --
   -- ------------------- --
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
      h1, h2 : Unsigned_64 := Unsigned_64 (Seed);
      k1, k2 : Unsigned_64 := 0;
      c1     : constant Unsigned_64 := 16#87c3_7b91_1142_53d5#;
      c2     : constant Unsigned_64 := 16#4cf5_ad43_2745_937f#;

   begin

      Data := Map_to_Array (Key);

      if Nblocks > 0 then
         MAP_Head:
         declare
            Head_Data : constant Block_64_128 := Map_to_Block (Data);
         begin
            COMPUTE:
            for i in 1 .. Nblocks loop
               k1 := Adapt_Indianess_64 (Head_Data (i)(1));
               k2 := Adapt_Indianess_64 (Head_Data (i)(2));

               k1 := @ * c1;
               k1 := Rotate_Left (k1, 31);
               k1 := @ * c2;
               h1 := h1 xor k1;

               h1 := Rotate_Left (h1, 27);
               h1 := @ + h2;
               h1 := h1 * 5 + 16#52dc_e729#;

               k2 := @ * c2;
               k2 := Rotate_Left (k2, 33);
               k2 := @ * c1;
               h2 := h2 xor k2;

               h2 := Rotate_Left (h2, 31);
               h2 := @ + h1;
               h2 := h2 * 5 + 16#3849_5ab5#;
            end loop COMPUTE;
         end MAP_Head;
      end if;

      if Tail_Length > 0 then
         TAIL:
         declare
--         Tail     : constant array (1 .. 16) of Unsigned_8 := [ others => 0]; -- FIXME Data (Nblocks .. Nblocks + Tail_Length));
            k1, k2   : Unsigned_64 := 0;
         begin
         -- for i in reverse 9 .. Tail_Length loop
         --    k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 15), 8*(i-1)-64));
         -- end loop;
         -- k2 := @ * c2;
         -- k2 := Rotate_Left (k2, 33);
         -- k2 := @ * c1;
         -- h2 := h2 xor k2;

            if Tail_Length >= 15 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 15)), 8*(15-1)-64);
            end if;
            if Tail_Length >= 14 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 14)), 8*(14-1)-64);
            end if;
            if Tail_Length >= 13 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 13)), 8*(13-1)-64);
            end if;
            if Tail_Length >= 12 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 12)), 8*(12-1)-64);
            end if;
            if Tail_Length >= 11 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 11)), 8*(11-1)-64);
            end if;
            if Tail_Length >= 10 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 10)), 8*(10-1)-64);
            end if;
            if Tail_Length >= 9 then
               k2 := k2 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 9)), 8*(9-1)-64);
               k2 := @ * c2;
               k2 := Rotate_Left (k2, 33);
               k2 := @ * c1;
               h2 := h2 xor k2;
            end if;

         -- for i in reverse 1 .. Tail_Length loop
         --    k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 3)), 8*(8-1));
         -- end loop;
         -- k1 := @ * c1;
         -- k1 := Rotate_Left (k1, 31);
         -- k1 := @ * c2;
         -- h1 := h1 xor k1;

            if Tail_Length >= 8 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 8)), 8*(8-1));
            end if;
            if Tail_Length >= 7 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 7)), 8*(7-1));
            end if;
            if Tail_Length >= 6 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 6)), 8*(6-1));
            end if;
            if Tail_Length >= 5 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 5)), 8*(5-1));
            end if;
            if Tail_Length >= 4 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 4)), 8*(4-1));
            end if;
            if Tail_Length >= 3 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 3)), 8*(3-1));
            end if;
            if Tail_Length >= 2 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 2)), 8*(2-1));
            end if;
            if Tail_Length >= 1 then
               k1 := k1 xor Shift_Left (Unsigned_64 (Data (Nblocks * Hash_Length + 1)), 8*(1-1));
               k1 := @ * c1;
               k1 := Rotate_Left (k1, 31);
               k1 := @ * c2;
               h1 := h1 xor k1;
            end if;
         end TAIL;
      end if;

      FINALIZE:
      declare
      begin
         h1 := h1 xor Unsigned_64 (Length);
         h2 := h2 xor Unsigned_64 (Length);

         h1 := @ + h2;
         h2 := @ + h1;

         h1 := fmix64 (h1);
         h2 := fmix64 (h2);

         h1 := @ + h2;
         h2 := @ + h1;
      end FINALIZE;

      return Shift_Left(Unsigned_128 (h2), 64)
                or Unsigned_128 (h1);

   end Hash_128_64;
