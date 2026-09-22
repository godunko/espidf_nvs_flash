--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System;

with ESPIDF.Ada_ESP_Check_Error;

package body ESPIDF.NVS_Flash is

   function nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.const_char_ptr;
      out_value : ESPIDF.C_Strings.char_ptr;
      length    : in out size_t) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_get_str";

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

   ----------------
   -- nvs_commit --
   ----------------

   procedure nvs_commit (handle : nvs_handle_t) is
   begin
      Ada_ESP_Check_Error (nvs_commit (handle));
   end nvs_commit;

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

   -----------------
   -- nvs_get_str --
   -----------------

   function nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array;
      length    : out size_t) return esp_err_t is
   begin
      length := out_value'Length;

      return
        nvs_get_str
          (handle,
           ESPIDF.C_Strings.As_const_char_ptr (key),
           ESPIDF.C_Strings.As_char_ptr (out_value),
           length);
   end nvs_get_str;

   -----------------
   -- nvs_get_str --
   -----------------

   procedure nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array;
      length    : out size_t) is
   begin
      Ada_ESP_Check_Error (nvs_get_str (handle, key, out_value, length));
   end nvs_get_str;

   -----------------
   -- nvs_get_str --
   -----------------

   function nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array) return esp_err_t
   is
      Length : size_t := out_value'Length;

   begin
      return nvs_get_str (handle, key, out_value, Length);
   end nvs_get_str;

   -----------------
   -- nvs_get_str --
   -----------------

   procedure nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array) is
   begin
      Ada_ESP_Check_Error (nvs_get_str (handle, key, out_value));
   end nvs_get_str;

   ------------------------
   -- nvs_get_str_length --
   ------------------------

   function nvs_get_str_length
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      length : out size_t) return esp_err_t is
   begin
      return
        nvs_get_str
         (handle,
          ESPIDF.C_Strings.As_const_char_ptr (key),
          ESPIDF.C_Strings.Null_char_ptr,
          length);
   end nvs_get_str_length;

   ------------------------
   -- nvs_get_str_length --
   ------------------------

   procedure nvs_get_str_length
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      length : out size_t) is
   begin
      Ada_ESP_Check_Error (nvs_get_str_length (handle, key, length));
   end nvs_get_str_length;

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

   -----------------
   -- nvs_set_str --
   -----------------

   procedure nvs_set_str
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      value  : ESPIDF.C_Strings.char_array_string) is
   begin
      Ada_ESP_Check_Error (nvs_set_str (handle, key, value));
   end nvs_set_str;

end ESPIDF.NVS_Flash;
