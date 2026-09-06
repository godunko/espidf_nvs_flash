--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.NVS_Flash is

   --------------------
   -- nvs_flash_init --
   --------------------

   procedure nvs_flash_init is
   begin
      Ada_ESP_Check_Error (nvs_flash_init);
   end nvs_flash_init;

end ESPIDF.NVS_Flash;
