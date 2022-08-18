with Test_Murmur3_001;
with Test_Murmur3_002;
-- with Test_Murmur3_003;
-- with Test_Murmur3_004;

with AUnit.Test_Cases; use AUnit.Test_Cases;

package body Test_Murmur3 is

   function Suite return Access_Test_Suite
   is
      Test_001 : constant Test_Case_Access := new Test_Murmur3_001.Test_Case;
      Test_002 : constant Test_Case_Access := new Test_Murmur3_002.Test_Case;
      -- Test_003 : constant Test_Case_Access := new Test_Murmur3_003.Test_Case;
      -- Test_004 : constant Test_Case_Access := new Test_Murmur3_004.Test_Case;
      Result   : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test (Test_001);
      Result.Add_Test (Test_002);
      -- Result.Add_Test (Test_003);
      -- Result.Add_Test (Test_004);
      return Result;
   end Suite;

end Test_Murmur3;
