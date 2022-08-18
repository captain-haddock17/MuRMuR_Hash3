-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------
with AdaForge.Crypto;

with AdaForge.Crypto.MuRMuR_Hash3 ;
with Interfaces;
-- with Ada.Text_IO;

with AUnit.Assertions; use AUnit.Assertions;

package body Test_Murmur3_002 is

   subtype key_index is Natural range 0..255;
   type key_array is array (key_index) of Interfaces.Unsigned_8;
   key : key_array := (others => 0);

   --  Identifier of test case:
   overriding function Name (T : Test_Case) return Message_String is
   begin
      return Format ("Test_Murmur3_002 - Verification Tests");
   end Name;

   overriding procedure Set_Up (T : in out Test_Case) is
   begin
      CREATE_DATA:
      -- Hash keys of the form (0), (0,1), (0,1,2) ... up to (0,...,255)
      -- using 256-N as the seed
      for i in key'Range loop
         key (i) := Interfaces.Unsigned_8 (i);
      end loop CREATE_DATA;
   end Set_Up;

   overriding procedure Tear_Down (T : in out Test_Case) is
   begin
      --  Do any necessary cleanups, so the next test
      --  has a clean environment.  If there is no
      --  cleanup, omit spec and body, as default is
      --  provided in Test_Cases.
      null;
   end Tear_Down;

   -- ------------------ --
   -- Verification Tests --
   -- ------------------ --
   -- This should hopefully be a thorough and uambiguous test of whether a hash
   -- is correctly implemented on a given platform
   procedure Verification32_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is separate;
   procedure Verification128_32_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is separate;
   procedure Verification128_64_Test (T : in out AUnit.Test_Cases.Test_Case'Class) is separate;

   --  Register test routines to call:
   overriding procedure Register_Tests (T : in out Test_Case) is
      use Test_Cases, Test_Cases.Registration;
   begin
      Register_Routine (T,
                        Verification32_Test'Access,
                        "Hash_32()  on a 256 array of hashed values with seeds");
      Register_Routine (T,
                        Verification128_32_Test'Access,
                        "Hash_128() on a 256 array of hashed values with seeds on a 32-bit platform");
      Register_Routine (T,
                        Verification128_64_Test'Access,
                        "Hash_128() on a 256 array of hashed values with seeds on a 64-bit platform");
   end Register_Tests;

end Test_Murmur3_002;
