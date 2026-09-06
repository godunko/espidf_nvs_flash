--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package ESPIDF.NVS_Flash is

   function nvs_flash_init return esp_err_t
     with Import, Convention => C, External_Name => "nvs_flash_init";

   procedure nvs_flash_init;

end ESPIDF.NVS_Flash;
