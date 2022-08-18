with Interfaces;
with Ada.Text_IO;

package AdaForge.Crypto is
--  pragma (pure);

   package Hex32_IO is new Ada.Text_IO.Modular_IO (Interfaces.Unsigned_32);
   package Hex128_IO is new Ada.Text_IO.Modular_IO (Interfaces.Unsigned_128);


end AdaForge.Crypto;
