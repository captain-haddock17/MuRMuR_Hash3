-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuR_Hash3  was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

separate (AdaForge.Crypto.MuRMuR_Hash3)
      -- ------------------- --
      -- Hash_128_32 --
      -- ------------------- --
   function Hash_128_32 (
               Key : Object;
               Length : Natural := Object'Size / 8;
               Seed : Unsigned_32 := 0)
               return Unsigned_128 is

      Data        : Data_8b;
      Hash_Length : constant Integer := 16; -- bytes = 128 bits
      Nblocks     : constant Integer := Length / Hash_Length;
--    Tail_Length : constant Integer := Length mod Hash_Length;
      Tail_Length : constant Integer := Length - Nblocks * Hash_Length;

   -- for COMPUTE
      h1, h2, h3, h4 : Unsigned_32 := Seed;
      k1, k2, k3, k4 : Unsigned_32 := 0;
      c1       : constant Unsigned_32 := 16#239b_961b#;
      c2       : constant Unsigned_32 := 16#ab0e_9789#;
      c3       : constant Unsigned_32 := 16#38b3_4ae5#;
      c4       : constant Unsigned_32 := 16#a1e3_8b93#;

   begin
      Data := Map_to_Array (Key);

      if Nblocks > 0 then
         MAP_Head:
         declare
            Head_Data : constant Block_32_128 := Map_to_Block (Data);
         begin
            COMPUTE:
            for i in 1 .. Nblocks loop
               k1 := Adapt_Indianess_32 (Head_Data (i)(1));
               k2 := Adapt_Indianess_32 (Head_Data (i)(2));
               k3 := Adapt_Indianess_32 (Head_Data (i)(3));
               k4 := Adapt_Indianess_32 (Head_Data (i)(4));

               k1 := @ * c1;
               k1 := Rotate_Left (k1, 15);
               k1 := @ * c2;
               h1 := h1 xor k1;
      
               h1 := Rotate_Left (h1, 19);
               h1 := @ + h2;
               h1 := h1 * 5 + 16#561c_cd1b#;
      
               k2 := @ * c2;
               k2 := Rotate_Left (k2, 16);
               k2 := @ * c3;
               h2 := h2 xor k2;
      
               h2 := Rotate_Left (h2, 17);
               h2 := @ + h3;
               h2 := h2 * 5 + 16#0bca_a747#;
      
               k3 := @ * c3;
               k3 := Rotate_Left (k3, 17);
               k3 := @ * c4;
               h3 := h3 xor k3;
      
               h3 := Rotate_Left (h3, 15);
               h3 := @ + h4;
               h3 := h3 * 5 + 16#96cd_1c35#;
      
               k4 := @ * c4;
               k4 := Rotate_Left (k4, 18);
               k4 := @ * c1;
               h4 := h4 xor k4;

               h4 := Rotate_Left (h4, 13);
               h4 := @ + h1;
               h4 := h4 * 5 + 16#32ac_3b17#;
            end loop COMPUTE;
         end MAP_Head;
      end if;

      if Tail_Length > 0 then
      TAIL:
         declare
   --         Tail     : constant array (1 .. Hash_Length) of Unsigned_8 := [others => 0];
         k1, k2, k3, k4 : Unsigned_32 := 0;
         begin
            if Tail_Length >= 15 then
               k4 := k4 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 15)), 8*(15-1)-3*32);
            end if;
            if Tail_Length >= 14 then
               k4 := k4 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 14)), 8*(14-1)-3*32);
            end if;
            if Tail_Length >= 13 then
               k4 := k4 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 13)), 8*(13-1)-3*32);
               k4 := @ * c4;
               k4 := Rotate_Left (k4, 18);
               k4 := @ * c1;
               h4 := h4 xor k4;
            end if;
            if Tail_Length >= 12 then
               k3 := k3 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 12)), 8*(12-1) -2*32);
            end if;
            if Tail_Length >= 11 then
               k3 := k3 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 11)), 8*(11-1)-2*32);
            end if;
            if Tail_Length >= 10 then
               k3 := k3 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 10)), 8*(10-1)-2*32);
            end if;
            if Tail_Length >= 9 then
               k3 := k3 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 9)), 8*(9-1) -2*32);
               k3 := @ * c3;
               k3 := Rotate_Left (k3, 17);
               k3 := @ * c4;
               h3 := h3 xor k3;
            end if;
            if Tail_Length >= 8 then
               k2 := k2 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length +8)), 8*(8-1) -1*32);
            end if;
            if Tail_Length >= 7 then
               k2 := k2 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 7)), 8*(7-1) -1*32);
            end if;
            if Tail_Length >= 6 then
               k2 := k2 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 6)), 8*(6-1) -1*32);
            end if;
            if Tail_Length >= 5 then
                  k2 := k2 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 5)), 8*(5-1) -1*32);
                  k2 := @ * c2;
                  k2 := Rotate_Left (k2, 16);
                  k2 := @ * c3;
                  h2 := h2 xor k2;
            end if;
            if Tail_Length >= 4 then
               k1 := k1 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 4)), 8*(4-1));
            end if;
            if Tail_Length >= 3 then
               k1 := k1 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 3)), 8*(3-1));
            end if;
            if Tail_Length >= 2 then
               k1 := k1 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 2)), 8*(2-1));
            end if;
            if Tail_Length >= 1 then
               k1 := k1 xor Shift_Left (Unsigned_32 (Data (Nblocks * Hash_Length + 1)), 8*(1-1));
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
         h2 := h2 xor Unsigned_32 (Length);
         h3 := h3 xor Unsigned_32 (Length);
         h4 := h4 xor Unsigned_32 (Length);

         h1 := @ + h2;
         h1 := @ + h3;
         h1 := @ + h4;
         h2 := @ + h1;
         h3 := @ + h1;
         h4 := @ + h1;

         h1 := fmix32 (h1);
         h2 := fmix32 (h2);
         h3 := fmix32 (h3);
         h4 := fmix32 (h4);

         h1 := @ + h2;
         h1 := @ + h3;
         h1 := @ + h4;
         h2 := @ + h1;
         h3 := @ + h1;
         h4 := @ + h1;
      end FINALIZE;

      return Shift_Left(Unsigned_128 (h4), 96)
             or Shift_Left(Unsigned_128 (h3), 64)
             or Shift_Left(Unsigned_128 (h2), 32)
             or Unsigned_128 (h1);

   end Hash_128_32;
