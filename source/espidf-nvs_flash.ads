--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.C_Strings;

package ESPIDF.NVS_Flash is

   type nvs_open_mode_t is
     (NVS_READONLY,
      NVS_READWRITE) with Convention => C;

   type nvs_handle_t is private;

   function nvs_flash_init return esp_err_t
     with Import, Convention => C, External_Name => "nvs_flash_init";

   procedure nvs_flash_init;

   function nvs_open
     (namespace_name : ESPIDF.C_Strings.char_array_string;
      open_mode      : nvs_open_mode_t;
      out_handle     : out nvs_handle_t) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_open";

   procedure nvs_open
     (namespace_name : ESPIDF.C_Strings.char_array_string;
      open_mode      : nvs_open_mode_t;
      out_handle     : out nvs_handle_t);

private

   type nvs_handle_t is new uint32_t;

end ESPIDF.NVS_Flash;
