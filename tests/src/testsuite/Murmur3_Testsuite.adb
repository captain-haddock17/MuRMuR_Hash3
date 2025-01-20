-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------

with Test_AdafHashMurm_001;
with Test_AdafHashMurm_002;
-- with Test_AdafHashMurm_003;
-- with Test_AdafHashMurm_004;

with AUnit.Test_Cases; use AUnit.Test_Cases;

package body Murmur3_Testsuite is

   function Suite return Access_Test_Suite
   is
      Test_001 : constant Test_Case_Access := new Test_AdafHashMurm_001.Test_Case;
      Test_002 : constant Test_Case_Access := new Test_AdafHashMurm_002.Test_Case;
      -- Test_003 : constant Test_Case_Access := new Test_AdafHashMurm_003.Test_Case;
      -- Test_004 : constant Test_Case_Access := new Test_AdafHashMurm_004.Test_Case;
      Result   : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test (Test_001);
      Result.Add_Test (Test_002);
      -- Result.Add_Test (Test_003);
      -- Result.Add_Test (Test_004);
      return Result;
   end Suite;

end Murmur3_Testsuite;
