with AUnit.Reporter.Text; use AUnit.Reporter.Text;
with AUnit.Run; use AUnit.Run;

--  Suite for this level of tests:
with Murmur3_Testsuite;

procedure TestSuite is

   procedure Run is new Test_Runner (Murmur3_Testsuite.Suite);

   Reporter : Text_Reporter;

begin
   Set_Use_ANSI_Colors (Reporter, True);
   Run (Reporter);
end TestSuite;
