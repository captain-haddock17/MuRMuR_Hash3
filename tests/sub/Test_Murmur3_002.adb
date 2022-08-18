with AdaForge.Crypto.MuRMuR_Hash3 ;
with Interfaces;
with Ada.Text_IO;

with AUnit.Assertions; use AUnit.Assertions;

package body Test_Murmur3_002 is

   --  Identifier of test case:
   overriding function Name (T : Test_Case) return Message_String is
   begin
      return Format ("Test_Murmur3_002 - Verification Tests");
   end Name;

   overriding procedure Set_Up (T : in out Test_Case) is
   begin
      --  Do any necessary set ups.  If there are none,
      --  omit from both spec and body, as a default
      --  version is provided in Test_Cases.
      null;
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
                        "Hash_128() on a 256 array of hashed values with seeds on a 32bit platform");
      Register_Routine (T,
                        Verification128_64_Test'Access,
                        "Hash_128() on a 256 array of hashed values with seeds on a 64bit platform");
   end Register_Tests;

end Test_Murmur3_002;
