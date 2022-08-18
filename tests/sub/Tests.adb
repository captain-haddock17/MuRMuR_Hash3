-------------------------------------------------------------------------------
--  SPDX-License-Identifier: Apache-2.0
--  SPDX-FileCopyrightText: Copyright 2022 William J. Franck (william.franck@adaforge.org)
--  SPDX-Creator: William J. Franck (william.franck@adaforge.org)
-------------------------------------------------------------------------------

with Test_Murmur3;

package body Tests is

   function Suite return Access_Test_Suite
   is
      Result : constant Access_Test_Suite := AUnit.Test_Suites.New_Suite;
   begin
      Result.Add_Test (
         Test_Murmur3.Suite);
      return Result;
   end Suite;

end Tests;
