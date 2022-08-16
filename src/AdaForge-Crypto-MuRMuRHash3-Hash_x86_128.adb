-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuRHash3 was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

separate (AdaForge.Crypto.MuRMuRHash3) 
      -- ------------------- --
      -- Hash_x86_128 --
      -- ------------------- --
   procedure Hash_x86_128 ( 
               Key : in Object;
               seed : unsigned_32 := 0;
               result : out unsigned_128 ) is
   
      Data     : Key_String_32;
      h1, h2, h3, h4 : unsigned_32 := seed;
      c1       : constant unsigned_32 := 16#239b_961b#; 
      c2       : constant unsigned_32 := 16#ab0e_9789#;
      c3       : constant unsigned_32 := 16#38b3_4ae5#; 
      c4       : constant unsigned_32 := 16#a1e3_8b93#;
   -- for COMPUTE
      nblocks  : constant Integer := Key_String_32'Last / 16;
      k1, k2, k3, k4 : unsigned_32 := 0;
   
   begin
      Data := Map_to_array_32 (Key);
   COMPUTE:
      for i in reverse 1 .. nblocks loop
   
         k1 := getblock_32 (Data, i * 4 + 1);
         k2 := getblock_32 (Data, i * 4 + 2);
         k3 := getblock_32 (Data, i * 4 + 3);
         k4 := getblock_32 (Data, i * 4 + 4);
   
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
   
   TAIL:
      declare
         Tail     : constant array (1 .. 16) of unsigned_8 := [ others => 0]; -- FIXME Data (nblocks .. nblocks + Tail_Length));
         Tail_Length        : constant Integer := Key_String_32'Last mod 16;
      k1, k2, k3, k4 : unsigned_32 := 0;
      begin
         if Tail_Length >= 15 then
            k4 := k4 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 16);
         end if;
         if Tail_Length >= 14 then
            k4 := k4 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 8);
         end if;
         if Tail_Length >= 13 then
            k4 := k4 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 0);
            k4 := @ * c4;
            k4 := Rotate_Left (k4, 18);
            k4 := @ * c1;
            h4 := h4 xor k4;
         end if;
         if Tail_Length >= 12 then
            k3 := k3 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 24);
         end if;
         if Tail_Length >= 11 then
            k3 := k3 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 16);
         end if;
         if Tail_Length >= 10 then
            k3 := k3 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 8);
         end if;
         if Tail_Length >= 9 then
            k3 := k3 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 0);
            k3 := @ * c3;
            k3 := Rotate_Left (k3, 17);
            k3 := @ * c4;
            h3 := h3 xor k3;
         end if;
         if Tail_Length >= 8 then
            k2 := k2 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 24);
         end if;
         if Tail_Length >= 7 then
            k2 := k2 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 16);
         end if;
         if Tail_Length >= 6 then
            k2 := k2 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 8);
         end if;
         if Tail_Length >= 5 then
               k2 := k2 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 0);
               k2 := @ * c2; 
               k2 := Rotate_Left (k2, 16); 
               k2 := @ * c3;
               h2 := h2 xor k2;
         end if;
         if Tail_Length >= 4 then
            k1 := k1 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 24);
         end if;
         if Tail_Length >= 3 then
            k1 := k1 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 16);
         end if;
         if Tail_Length >= 2 then
            k1 := k1 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 8);
         end if;
         if Tail_Length >= 1 then
            k1 := k1 xor Shift_Left (Unsigned_32 (Tail (Tail_Length)), 0);
            k1 := @ * c1;
            k1 := Rotate_Left (k1, 15);
            k1 := @ * c2;
            h1 := h1 xor k1;
         end if;
      end TAIL;

   FINALIZE:
      declare
      begin
         h1 := h1 xor Unsigned_32 (Key_String_32'Last);
         h2 := h2 xor Unsigned_32 (Key_String_32'Last);
         h3 := h3 xor Unsigned_32 (Key_String_32'Last);
         h4 := h4 xor Unsigned_32 (Key_String_32'Last);
      
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
      
      result := Shift_Left(unsigned_128 (h4), 96) 
               or Shift_Left(unsigned_128 (h3), 64)
               or Shift_Left(unsigned_128 (h2), 32)
               or unsigned_128 (h1);
   
   end Hash_x86_128;
   