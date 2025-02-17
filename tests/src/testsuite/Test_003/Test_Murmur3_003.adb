-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------

with AUnit.Assertions; use AUnit.Assertions;

--  Template for test case body.
package body Test_AdafHashMurm_003 is

   --  Identifier of test case:
   overriding function Name (T : Test_Case) return Message_String is
   begin
      return Format ("Test_AdafHashMurm_003");
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
   -- Unit_Test_03 --
   -- ------------ --
   -- Appending zero bytes to a key should always cause it to produce a different
   -- hash value
   procedure Unit_Test_03 (T : in out AUnit.Test_Cases.Test_Case'Class) is separate;


   --  Register test routines to call:
   overriding procedure Register_Tests (T : in out Test_Case) is
      use Test_Cases, Test_Cases.Registration;
   begin
      --  Repeat for each test routine.
      Register_Routine (T, Unit_Test_03'Access, "Appended Zeroes Test");
   end Register_Tests;

end Test_AdafHashMurm_003;
