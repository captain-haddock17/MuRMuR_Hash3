-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuRHash3 was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

separate (AdaForge.Crypto.MuRMuRHash3)
   -------------------------------------------------------------------------------
   -- 32 bits hash --
   -------------------------------------------------------------------------------
   function PHash_32 ( 
               Key : Object;
               Length : Integer := Object'Size/8;
               Seed : unsigned_32 := 0)
               return unsigned_32 is
   
      h1       : unsigned_32 := seed;
      carry    : unsigned_32 := 0;
      c1       : constant unsigned_32 := 16#cc9e_2d51#;
      c2       : constant unsigned_32 := 16#1b87_3593#;
      len      : constant Unsigned_32 := Key'Size / 8;

      -- PHash_32_Process --
      procedure PHash_32_Process ( 
               h1       : in out unsigned_32;
               Carry    : in out unsigned_32;
               Key  : Object;
               Len      : Unsigned_32) is
      -- for COMPUTE
      Data     : Key_String_32;
--      block    : Unsigned_x86_128; --FIXME Unsigned_x86_128 := Key + nblocks * 4;
      nblocks  : constant Integer := Key_String_32'Last / 4;
      k1       : unsigned_32;
      Tail_Length        : constant Integer := Integer (Carry mod 4);
   
      begin 
         Data := Map_to_array_32 (Key);
         COMPUTE:
            for i in reverse 1 .. nblocks loop
               k1 := getblock_32 (Data, i);
   
               k1 := @ * c1;
               k1 := Rotate_Left (k1, 15);
               k1 := @ * c2;
       
               h1 := h1 xor k1;
               h1 := Rotate_Left (h1, 13); 
               h1 := h1 * 5 + 16#e654_6b64#;
            end loop COMPUTE;

         -- Copy out new running hash and carry
         -- h1
         Carry := (Carry and not 16#FF#) or Unsigned_32 (Tail_Length);
      end PHash_32_Process;

      -- PHash_32_Result --
      function PHash_32_Result ( 
               h        : unsigned_32;
               Carry    : unsigned_32;
               Total_Length : Unsigned_32)
               return unsigned_32 is
      begin
         TAIL:
            declare
               h1 : unsigned_32 := h;
               k1 : unsigned_32 := 0;
               Tail_Length        : constant Integer := Integer(Carry mod 4);
--             tail     : constant array (1 .. 4) of unsigned_8 := [ others => 0]; --FIXME Data (nblocks .. nblocks + Tail_Length));
   
            begin
               if Tail_Length > 0 then
                  k1 := k1 xor Shift_Left (Carry, (4 - Tail_Length) * 8);
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
               Len      => Len);
      return PHash_32_Result (
               h        => h1,
               Carry    => carry,
               Total_Length => Len);
   end PHash_32; 
