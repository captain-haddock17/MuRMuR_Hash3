with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package Perf_Text_001 is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   --  Name identifying the test case:
   overriding function Name (T : Test_Case) return Message_String;

   --  Register routines to be run:
   overriding procedure Register_Tests (T : in out Test_Case);

   --  Override if needed. Default empty implementations provided:

   --  Preparation performed before each routine:
   overriding procedure Set_Up (T : in out Test_Case);

   --  Cleanup performed after each routine:
   overriding procedure Tear_Down (T :  in out Test_Case);


end Perf_Text_001;
