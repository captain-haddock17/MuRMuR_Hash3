-------------------------------------------------------------------------------
-- AdaForge.Crypto.MuRMuRHash3 was written by Austin Appleby, and is placed in the public
-- domain. The author hereby disclaims copyright to this source code.
-------------------------------------------------------------------------------

with Ada.Text_IO;
with Ada.Integer_Text_IO;
separate (AdaForge.Crypto.MuRMuRHash3)
   -------------------------------------------------------------------------------
   -- 32 bits hash --
   -------------------------------------------------------------------------------
   procedure Hash_x86_32 ( 
               Key : Object;
               Length : Integer := Object'Size/8;
               Seed : unsigned_32 := 0;
               Result : out unsigned_32)
   is
      h1       : unsigned_32 := seed;
      c1       : constant unsigned_32 := 16#cc9e_2d51#;
      c2       : constant unsigned_32 := 16#1b87_3593#;
      len      : Integer := Length;
   
      -- for COMPUTE
      Data     : Key_String_8;
      nblocks  : constant Integer := Length / 4;
      Tail_Length  : constant Integer := Length - nblocks*4;
      k1       : unsigned_32;

   package Hex_String is new Ada.Text_IO.Modular_IO (unsigned_32);
   subtype String_32Hex is String(1..32/4 +4);
   HexString : String_32Hex := [others => 'x'];

   begin 

      Data := Map_to_array_8 (Key);
      -- Ada.Text_IO.Put_Line ("====================");
      -- Ada.Text_IO.Put ("key " );
      -- Ada.Integer_Text_IO (Data (0));
      -- Ada.Integer_Text_IO (Data (1));
      -- Ada.Integer_Text_IO (Data (2));
      -- Ada.Integer_Text_IO (Data (3));
      -- Ada.Text_IO.Put_line ("(" & Length'Image & ")");
      -- Ada.Text_IO.Put_Line ("nblocks =" & nblocks'Image);
      -- Ada.Text_IO.Put_Line ("Tail_Length =" & Tail_Length'Image);

      if nblocks > 0 then
         MAP_Head:
         declare
--            type Head_Array is array (1 .. nblocks) of unsigned_32;
            function Map_to_array_32 is new Ada.Unchecked_Conversion (
                  Source => Key_String_8, 
                  Target => Key_String_32);
            Head : Constant Key_String_32 := Map_to_array_32 (Data);
         begin
            COMPUTE:
            for i in reverse 1 .. nblocks loop
               k1 := getblock_32 (Head, i);
   
               k1 := @ * c1;
               k1 := Rotate_Left (k1, 15);
               k1 := @ * c2;
       
               h1 := h1 xor k1;
               h1 := Rotate_Left (h1, 13); 
               h1 := h1 * 5 + 16#e654_6b64#;
            end loop COMPUTE;
         end MAP_Head;   
      end if;
      Hex_String.Put (To   => HexString,
                   Item => h1,
                  Base  => 16);
      -- Ada.Text_IO.Put_Line("h1 Base  =" & HexString );

      if Tail_Length > 0 then
         -- Ada.Text_IO.Put_Line ("nblocks*4+1 =" & Integer'Image(nblocks*4+1));
         -- Ada.Text_IO.Put_Line ("nblocks*4 + Tail_Length =" & Integer'Image(nblocks*4 + Tail_Length));
         TAIL:
         declare
            type Tail_Array is array (1 .. Tail_Length) of unsigned_8;
            function Map_to_array_8 is new Ada.Unchecked_Conversion (
                  Source => Key_String_8, 
                  Target => Tail_array);
--            Tail : Tail_array := Map_to_array_8 (Data (nblocks*4+1 .. nblocks*4 + Tail_Length));
            k1 : unsigned_32 := 0;
   
         begin
            if Tail_Length >= 3 then
               k1 := k1 xor Shift_Left (Unsigned_32 (Data (nblocks*4 + 3)), 16);
            end if;
            if Tail_Length >= 2 then
               k1 := k1 xor Shift_Left (Unsigned_32 (Data (nblocks*4 + 2)), 8);
            end if;
            if Tail_Length >= 1 then
               k1 := k1 xor Unsigned_32 (Data (nblocks*4 + 1));
               k1 := @ * c1; 
               k1 := Rotate_Left (k1, 15); 
               k1 := @ * c2; 
               h1 := h1 xor k1;
            end if;
         end TAIL;
      end if;
      Hex_String.Put (To   => HexString,
                   Item => h1,
                  Base  => 16);
      -- Ada.Text_IO.Put_Line("h1 Tail  =" & HexString );

   FINALIZE:
      declare
      begin
         h1 := h1 xor Unsigned_32 (Length);
         h1 := fmix32 (h1);   
      end FINALIZE;

      result := h1;
      Hex_String.Put (To   => HexString,
                   Item => h1,
                  Base  => 16);
      -- Ada.Text_IO.Put_Line("h1 Hash  =" & HexString );
   
   end Hash_x86_32; 
   
