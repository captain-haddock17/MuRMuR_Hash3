with AUnit.Reporter.Text; use AUnit.Reporter.Text;
with AUnit.Run; use AUnit.Run;

--  Suite for this level of tests:
with Tests;

procedure TestSuite is

   procedure Run is new Test_Runner (Tests.Suite);

   Reporter : Text_Reporter;

begin
   Set_Use_ANSI_Colors (Reporter, True);
   Run (Reporter);
end TestSuite;
