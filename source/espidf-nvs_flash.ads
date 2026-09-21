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

   type nvs_type_t is
     (NVS_TYPE_U8,
      NVS_TYPE_U16,
      NVS_TYPE_U32,
      NVS_TYPE_U64,
      NVS_TYPE_I8,
      NVS_TYPE_I16,
      NVS_TYPE_I32,
      NVS_TYPE_I64,
      NVS_TYPE_STR,
      NVS_TYPE_BLOB,
      NVS_TYPE_ANY) with Convention => C;
   for nvs_type_t use
     (NVS_TYPE_U8    => 16#01#,
      NVS_TYPE_U16   => 16#02#,
      NVS_TYPE_U32   => 16#04#,
      NVS_TYPE_U64   => 16#08#,
      NVS_TYPE_I8    => 16#11#,
      NVS_TYPE_I16   => 16#12#,
      NVS_TYPE_I32   => 16#14#,
      NVS_TYPE_I64   => 16#18#,
      NVS_TYPE_STR   => 16#21#,
      NVS_TYPE_BLOB  => 16#42#,
      NVS_TYPE_ANY   => 16#ff#);

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

   function nvs_find_key
     (handle   : nvs_handle_t;
      key      : ESPIDF.C_Strings.char_array_string;
      out_type : out nvs_type_t) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_find_key";

   function nvs_find_key
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string) return esp_err_t;

private

   type nvs_handle_t is new uint32_t;

end ESPIDF.NVS_Flash;
