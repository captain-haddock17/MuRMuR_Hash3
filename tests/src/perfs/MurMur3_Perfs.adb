with Perf_Unicode;
with Perf_Text;

package body MurMur3_Perfs is

   function Suite return Access_Test_Suite
   is
      Result : constant Access_Test_Suite := AUnit.Test_Suites.New_Suite;
   begin
      Result.Add_Test (Perf_Unicode.Suite);
      Result.Add_Test (Perf_Text.Suite);
      return Result;
   end Suite;

end MurMur3_Perfs;
