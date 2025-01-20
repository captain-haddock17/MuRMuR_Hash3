-------------------------------------------------------------------------------
--  MuRMuR_Hash (v3) was written by Austin Appleby,
--  and is placed in the public domain.
--  The author disclaims copyright in his C source code.
-------------------------------------------------------------------------------
--  William J. Franck has ported the C code to Ada with adaptations.
--  https://github.com/aappleby/smhasher/blob/master/src/MurmurHash3.h
--
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------

with Ada.Containers;
with System;
with Interfaces;

generic
   type Object is private;
   -- /!\ Instantiation will rise warnings about unchecked conversions having different sizes.
   -- This is intentional as we cast 'Object' data to a formated 32- 64-bits array 
   -- use '-gnatwZ' to suppress warnings on those unchecked conversions 
   -- as the types are known at compile time and may have different smaller sizes (thus safe). 

package AdaForge.Hash.MuRMuR3  is
   -------------------------------------------------------------------------------
   -- Note - The x86 and x64 versions do _not_ produce the same results, as the
   -- algorithms are optimized for their respective platforms. You can still
   -- compile and run any of them on any platform, but your performance with the
   -- non-native version will be less than optimal.
   --
   -------------------------------------------------------------------------------
   --  https://github.com/daisuke-t-jp/MurmurHash-Swift
   --  https://github.com/daisuke-t-jp/MurmurHash-Swift/blob/master/Sources/MurmurHash/AdaForge.Hash.MuRMuR3 _x86_32.swift
   --  https://github.com/daisuke-t-jp/MurmurHash-Swift/blob/master/Sources/MurmurHash/AdaForge.Hash.MuRMuR3 Tail.swift
   -------------------------------------------------------------------------------

   -- ------------ --
   -- 32 bits hash --
   -- ------------ --
   -- return Unsigned_32
   function Hash_32 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Interfaces.Unsigned_32 := 0)
               return Interfaces.Unsigned_32
               with Pre => Length <= Object'Size / 8;

   -- return Ada.Containers.Hash_Type
   function Hash_32 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Interfaces.Unsigned_32 := 0)
               return Ada.Containers.Hash_Type
               with Pre => Length <= Object'Size / 8;

   -- return String
   function Hash_32 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Interfaces.Unsigned_32 := 0)
               return String
               with Pre => Length <= Object'Size / 8;

   -- ------------- --
   -- 128 bits hash --
   -- ------------- --
   -- return Unsigned_128
   function Hash_128 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Interfaces.Unsigned_32 := 0;
               Word_Size : Integer := System.Word_Size)
               return Interfaces.Unsigned_128
               with Pre => Length <= Object'Size / 8;

   -- return String
   function Hash_128 (
               Key: Object;
               Length : Natural := Object'Size / 8;
               Seed   : Interfaces.Unsigned_32 := 0;
               Word_Size : Integer := System.Word_Size)
               return String
               with Pre => Length <= Object'Size / 8;

end AdaForge.Hash.MuRMuR3 ;