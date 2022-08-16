with AUnit.Assertions; use AUnit.Assertions;

--  Template for test case body.
package body Test_Murmur3_002 is

   --  Identifier of test case:
   overriding function Name (T : Test_Case) return Message_String is
   begin
      return Format ("Test_Murmur3_002");
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


   -- ------------ --
   -- Unit_Test_02 --
   -- ------------ --
   -- Basic sanity checks -
   -- A hash function should not be reading outside the bounds of the key.
   -- Flipping a bit of a key should, with overwhelmingly high probability,
   -- result in a different hash.
   -- Hashing the same key twice should always produce the same result.
   -- The memory alignment of the key should not affect the hash result.
   procedure Unit_Test_02 (T : in out AUnit.Test_Cases.Test_Case'Class) is separate;


   --  Register test routines to call:
   overriding procedure Register_Tests (T : in out Test_Case) is
      use Test_Cases, Test_Cases.Registration;
   begin
      --  Repeat for each test routine.
      Register_Routine (T, Unit_Test_02'Access, "Basic sanity checks");
   end Register_Tests;

end Test_Murmur3_002;
