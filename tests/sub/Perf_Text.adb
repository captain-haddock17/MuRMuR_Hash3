with Perf_Text_001;

with AUnit.Test_Cases; use AUnit.Test_Cases;

package body Perf_Text is

   function Suite return Access_Test_Suite
   is
      Test_001 : constant Test_Case_Access := new Perf_Text_001.Test_Case;
      Result   : constant Access_Test_Suite := new Test_Suite;
   begin
      Result.Add_Test (Test_001);
      return Result;
   end Suite;

end Perf_Text;
