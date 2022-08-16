-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuRHash3 was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

separate (AdaForge.Crypto.MuRMuRHash3)
   -- ------------------- --
   -- Hash_x64_128 --
   -- ------------------- --
   procedure Hash_x64_128 ( 
               Key    : in Object; 
               seed   : unsigned_32 := 0;
               result : out unsigned_128) is
   
      h1, h2   : unsigned_64 := unsigned_64 (seed);
      c1 : constant unsigned_64 := 16#87c3_7b91_1142_53d5#;
      c2 : constant unsigned_64 := 16#4cf5_ad43_2745_937f#;
  
   
   -- for COMPUTE
      Data     : Key_String_64;
      nblocks  : constant Integer := Key_String_64'Last / 16;
      k1, k2   : unsigned_64 := 0;
   
   begin
      Data := Map_to_array_64 (Key);
   COMPUTE:
      for i in 1 .. nblocks loop
         k1 := getblock_64 (Data, i * 2 + 1);
         k2 := getblock_64 (Data, i * 2 + 2);
   
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
   
   TAIL:
      declare
         Tail     : constant array (1 .. 16) of unsigned_8 := [ others => 0]; -- FIXME Data (nblocks .. nblocks + Tail_Length));
         Tail_Length        : constant Integer := Key_String_64'Last mod 16;
         k1, k2   : unsigned_64 := 0;
      begin
         if Tail_Length >= 15 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 48);
         end if;
         if Tail_Length >= 14 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 40);
         end if;
         if Tail_Length >= 13 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 32);
         end if;
         if Tail_Length >= 12 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 24);
         end if;
         if Tail_Length >= 11 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 16);
         end if;
         if Tail_Length >= 10 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 8);
         end if;
         if Tail_Length >= 9 then 
            k2 := k2 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 0);
            k2 := @ * c2;
            k2 := Rotate_Left (k2, 33);
            k2 := @ * c1;
            h2 := h2 xor k2;
         end if;
         if Tail_Length >= 8 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 56);
         end if;
         if Tail_Length >= 7 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 48);
         end if;
         if Tail_Length >= 6 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 40);
         end if;
         if Tail_Length >= 5 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 32);
         end if;
         if Tail_Length >= 4 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 24);
         end if;
         if Tail_Length >= 3 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 16);
         end if;
         if Tail_Length >= 2 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 8);
         end if;
         if Tail_Length >= 1 then 
            k1 := k1 xor Shift_Left (unsigned_64 (tail  (Tail_Length)), 0);
            k1 := @ * c1;
            k1 := Rotate_Left (k1, 31);
            k1 := @ * c2;
            h1 := h1 xor k1;
         end if;
      end TAIL;
   
   FINALIZE:
      declare
      begin
         h1 := h1 xor Unsigned_64 (Key_String_64'Last);
         h2 := h2 xor Unsigned_64 (Key_String_64'Last);
   
         h1 := @ + h2;
         h2 := @ + h1;
   
         h1 := fmix64 (h1);
         h2 := fmix64 (h2);
   
         h1 := @ + h2;
         h2 := @ + h1;
      end FINALIZE;
      
      result := Shift_Left(unsigned_128 (h2), 64) 
                or unsigned_128 (h1);
   
   end Hash_x64_128;
