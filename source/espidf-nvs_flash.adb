--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System;

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.NVS_Flash is

   ---------------
   -- nvs_close --
   ---------------

   procedure nvs_close (handle : in out nvs_handle_t) is
      procedure Imported
        (handle : nvs_handle_t)
        with Import, Convention => C, External_Name => "nvs_close";

   begin
      Imported (handle);
      handle := 0;
   end nvs_close;

   ------------------
   -- nvs_find_key --
   ------------------

   function nvs_find_key
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string) return esp_err_t
   is
      function Imported
        (handle   : nvs_handle_t;
         key      : ESPIDF.C_Strings.char_array_string;
         out_type : System.Address) return esp_err_t
        with Import, Convention => C, External_Name => "nvs_find_key";

   begin
      return Imported (handle, key, System.Null_Address);
   end nvs_find_key;

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
