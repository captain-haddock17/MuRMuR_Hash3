separate (Perf_MuRMur3_001)
procedure Unit_Test_03 (R : in out AUnit.Test_Cases.Test_Case'Class) is
   pragma Unreferenced (R);
begin
   --  Do something:
   null;

   --  Test for expected conditions. Multiple assertions
   --  and actions are ok:
   Assert (False, "Indication of what failed 1");
   Assert (False, "Indication of what failed 2");
   Assert (False, "Indication of what failed 3");
end Unit_Test_03;
