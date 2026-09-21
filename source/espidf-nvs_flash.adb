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

   --------------
   -- nvs_open --
   --------------

   procedure nvs_open
     (namespace_name : ESPIDF.C_Strings.char_array_string;
      open_mode      : nvs_open_mode_t;
      out_handle     : out nvs_handle_t) is
   begin
      Ada_ESP_Check_Error (nvs_open (namespace_name, open_mode, out_handle));
   end nvs_open;

end ESPIDF.NVS_Flash;
