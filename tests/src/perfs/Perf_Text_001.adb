with AUnit.Assertions; use AUnit.Assertions;

--  Template for test case body.
package body Perf_Text_001 is

   --  Identifier of test case:
   overriding function Name (T : Test_Case) return Message_String is
   begin
      return Format ("Perf_Text_001");
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

   procedure Unit_Test_01 (R : in out AUnit.Test_Cases.Test_Case'Class) is separate;
   procedure Unit_Test_02 (R : in out AUnit.Test_Cases.Test_Case'Class) is separate;
   procedure Unit_Test_03 (R : in out AUnit.Test_Cases.Test_Case'Class) is separate;

   --  Register test routines to call:
   overriding procedure Register_Tests (T : in out Test_Case) is
      use Test_Cases.Registration;
   begin
      --  Repeat for each test routine.
      Register_Routine (T, Unit_Test_01'Access, "Description of test routine n°1");
      Register_Routine (T, Unit_Test_02'Access, "Description of test routine n°2");
      Register_Routine (T, Unit_Test_03'Access, "Description of test routine n°3");
   end Register_Tests;

end Perf_Text_001;
