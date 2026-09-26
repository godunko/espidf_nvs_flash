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
   --  Mode of opening the non-volatile storage.
   --  @enum NVS_READONLY Read only
   --  @enum NVS_READWRITE Read and write

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
   --  Types of variables.
   --  @enum NVS_TYPE_U8 Type `uint8_t`
   --  @enum NVS_TYPE_U16 Type `uint16_t`
   --  @enum NVS_TYPE_U32 Type `uint32_t`
   --  @enum NVS_TYPE_U64 Type `uint64_t`
   --  @enum NVS_TYPE_I8 Type `int8_t`
   --  @enum NVS_TYPE_I16 Type `int16_t`
   --  @enum NVS_TYPE_I32 Type `int32_t`
   --  @enum NVS_TYPE_I64 Type `int64_t`
   --  @enum NVS_TYPE_STR Type string
   --  @enum NVS_TYPE_BLOB Type blob
   --  @enum NVS_TYPE_ANY Must be last
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
   --  Opaque type representing handle of the non-volatile storage.

   function nvs_flash_init return esp_err_t
     with Import, Convention => C, External_Name => "nvs_flash_init";
   --  Initialize the default NVS partition.
   --
   --  This API initialises the default NVS partition. The default NVS
   --  partition is the one that is labeled "nvs" in the partition table.
   --
   --  When "NVS_ENCRYPTION" is enabled in the menuconfig, this API enables
   --  the NVS encryption for the default NVS partition as follows:
   --    1. Read security configurations from the first NVS key partition
   --       listed in the partition table. (NVS key partition is any "data"
   --       type partition which has the subtype value set to "nvs_keys")
   --    2. If the NVS key partition obtained in the previous step is empty,
   --       generate and store new keys in that NVS key partition.
   --    3. Internally call `nvs_flash_secure_init` with the security
   --       configurations obtained/generated in the previous steps.
   --
   --  Post initialization NVS read/write APIs remain the same irrespective
   --  of NVS encryption.
   --  @return
   --    - `ESP_OK` if storage was successfully initialized
   --    - `ESP_ERR_NVS_NO_FREE_PAGES` if the NVS storage contains no empty
   --      pages (which may happen if NVS partition was truncated)
   --    - `ESP_ERR_NOT_FOUND` if no partition with label "nvs" is found in
   --      the partition table
   --    - `ESP_ERR_NO_MEM` if memory could not be allocated for the
   --      internal structures
   --    - one of the error codes from the underlying flash storage driver
   --    - error codes from `nvs_flash_read_security_cfg` API (when
   --      "NVS_ENCRYPTION" is enabled)
   --    - error codes from `nvs_flash_generate_keys` API (when
   --      "NVS_ENCRYPTION" is enabled)
   --    - error codes from `nvs_flash_secure_init_partition` API (when
   --      "NVS_ENCRYPTION" is enabled)

   procedure nvs_flash_init;
   --  Initialize the default NVS partition.
   --
   --  This API initialises the default NVS partition. The default NVS
   --  partition is the one that is labeled "nvs" in the partition table.
   --
   --  When "NVS_ENCRYPTION" is enabled in the menuconfig, this API enables
   --  the NVS encryption for the default NVS partition as follows:
   --    1. Read security configurations from the first NVS key partition
   --       listed in the partition table. (NVS key partition is any "data"
   --       type partition which has the subtype value set to "nvs_keys")
   --    2. If the NVS key partition obtained in the previous step is empty,
   --       generate and store new keys in that NVS key partition.
   --    3. Internally call `nvs_flash_secure_init` with the security
   --       configurations obtained/generated in the previous steps.
   --
   --  Post initialization NVS read/write APIs remain the same irrespective
   --  of NVS encryption.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_NVS_NO_FREE_PAGES` if the NVS storage contains no empty
   --      pages (which may happen if NVS partition was truncated)
   --    - `ESP_ERR_NOT_FOUND` if no partition with label "nvs" is found in
   --      the partition table
   --    - `ESP_ERR_NO_MEM` if memory could not be allocated for the
   --      internal structures
   --    - one of the error codes from the underlying flash storage driver
   --    - error codes from `nvs_flash_read_security_cfg` API (when
   --      "NVS_ENCRYPTION" is enabled)
   --    - error codes from `nvs_flash_generate_keys` API (when
   --      "NVS_ENCRYPTION" is enabled)
   --    - error codes from `nvs_flash_secure_init_partition` API (when
   --      "NVS_ENCRYPTION" is enabled)

   function nvs_open
     (namespace_name : ESPIDF.C_Strings.char_array_string;
      open_mode      : nvs_open_mode_t;
      out_handle     : out nvs_handle_t) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_open";
   --  Open non-volatile storage with a given namespace from the default NVS
   --  partition.
   --
   --  Multiple internal ESP-IDF and third party application modules can
   --  store their key-value pairs in the NVS module. In order to reduce
   --  possible conflicts on key names, each module can use its own
   --  namespace. The default NVS partition is the one that is labelled "nvs"
   --  in the partition table.
   --  @param namespace_name
   --    Namespace name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1)
   --    characters. Shouldn't be empty.
   --  @param open_mode
   --    `NVS_READONLY` opens a read only handle. `NVS_READWRITE` opens a
   --    read/write handle, erase and set operations are allowed; previous
   --    data is marked as deleted only and new data is written to a new
   --    location.
   --  @param out_handle
   --    If successful (return code is zero), handle will be returned in this
   --    argument.
   --  @return
   --    - `ESP_OK` if storage handle was opened successfully
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_INITIALIZED` if the storage driver is not
   --      initialized
   --    - `ESP_ERR_NVS_PART_NOT_FOUND` if the partition with label "nvs" is
   --      not found
   --    - `ESP_ERR_NVS_NOT_FOUND` if namespace doesn't exist yet and mode is
   --      `NVS_READONLY`
   --    - `ESP_ERR_NVS_INVALID_NAME` if namespace name doesn't satisfy
   --      constraints
   --    - `ESP_ERR_NO_MEM` if memory could not be allocated for the
   --      internal structures
   --    - `ESP_ERR_NVS_NOT_ENOUGH_SPACE` if there is no space for a new entry
   --      or there are too many different namespaces (maximum allowed
   --      different namespaces: 254)
   --    - `ESP_ERR_NOT_ALLOWED` if the NVS partition is read-only and mode is
   --      `NVS_READWRITE`
   --    - other error codes from the underlying storage driver

   procedure nvs_open
     (namespace_name : ESPIDF.C_Strings.char_array_string;
      open_mode      : nvs_open_mode_t;
      out_handle     : out nvs_handle_t);
   --  Open non-volatile storage with a given namespace from the default NVS
   --  partition.
   --
   --  Multiple internal ESP-IDF and third party application modules can
   --  store their key-value pairs in the NVS module. In order to reduce
   --  possible conflicts on key names, each module can use its own
   --  namespace. The default NVS partition is the one that is labelled "nvs"
   --  in the partition table.
   --  @param namespace_name
   --    Namespace name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1)
   --    characters. Shouldn't be empty.
   --  @param open_mode
   --    `NVS_READONLY` opens a read only handle. `NVS_READWRITE` opens a
   --    read/write handle, erase and set operations are allowed; previous
   --    data is marked as deleted only and new data is written to a new
   --    location.
   --  @param out_handle
   --    If successful, handle will be returned in this argument.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_INITIALIZED` if the storage driver is not
   --      initialized
   --    - `ESP_ERR_NVS_PART_NOT_FOUND` if the partition with label "nvs" is
   --      not found
   --    - `ESP_ERR_NVS_NOT_FOUND` if namespace doesn't exist yet and mode is
   --      `NVS_READONLY`
   --    - `ESP_ERR_NVS_INVALID_NAME` if namespace name doesn't satisfy
   --      constraints
   --    - `ESP_ERR_NO_MEM` if memory could not be allocated for the
   --      internal structures
   --    - `ESP_ERR_NVS_NOT_ENOUGH_SPACE` if there is no space for a new entry
   --      or there are too many different namespaces (maximum allowed
   --      different namespaces: 254)
   --    - `ESP_ERR_NOT_ALLOWED` if the NVS partition is read-only and mode is
   --      `NVS_READWRITE`
   --    - other error codes from the underlying storage driver

   function nvs_commit
     (handle : nvs_handle_t) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_commit";
   --  Write any pending changes to non-volatile storage.
   --
   --  After setting any values, `nvs_commit` must be called to ensure
   --  changes are written to non-volatile storage. Individual
   --  implementations may write to storage at other times, but this is not
   --  guaranteed.
   --  @param handle
   --    Storage handle obtained with `nvs_open`. Handles that were opened
   --    read only cannot be used.
   --  @return
   --    - `ESP_OK` if the changes have been written successfully
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - other error codes from the underlying storage driver

   procedure nvs_commit (handle : nvs_handle_t);
   --  Write any pending changes to non-volatile storage.
   --
   --  After setting any values, `nvs_commit` must be called to ensure
   --  changes are written to non-volatile storage. Individual
   --  implementations may write to storage at other times, but this is not
   --  guaranteed.
   --  @param handle
   --    Storage handle obtained with `nvs_open`. Handles that were opened
   --    read only cannot be used.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - other error codes from the underlying storage driver

   procedure nvs_close (handle : in out nvs_handle_t);
   --  Close the storage handle and free any allocated resources.
   --
   --  This subprogram should be called for each handle opened with
   --  `nvs_open` once the handle is not in use any more. Closing the handle
   --  may not automatically write the changes to nonvolatile storage. This
   --  has to be done explicitly using `nvs_commit`. Once this subprogram is
   --  called on a handle, the handle should no longer be used.
   --  @param handle Storage handle to close. It is reset to null value.

   function nvs_find_key
     (handle   : nvs_handle_t;
      key      : ESPIDF.C_Strings.char_array_string;
      out_type : out nvs_type_t) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_find_key";
   --  Lookup key-value pair with given key name.
   --
   --  Note that function may indicate both existence of the key as well as
   --  the data type of NVS entry if it is found.
   --  @param handle Storage handle obtained with `nvs_open`.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param out_type
   --    Output variable populated with data type of NVS entry in case key
   --    was found.
   --  @return
   --    - `ESP_OK` if NVS entry for key provided was found
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - other error codes from the underlying storage driver

   function nvs_find_key
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string) return esp_err_t;
   --  Lookup key-value pair with given key name.
   --
   --  Note that function indicates existence of the key only, data type of
   --  NVS entry is not provided.
   --  @param handle Storage handle obtained with `nvs_open`.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @return
   --    - `ESP_OK` if NVS entry for key provided was found
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - other error codes from the underlying storage driver

   function nvs_get_str_length
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      length : out size_t) return esp_err_t;
   --  Get length of the string value for given key.
   --
   --  If key does not exist, or the requested variable type doesn't match
   --  the type which was used when setting a value, an error is returned.
   --
   --  `length` is in bytes, and includes null terminator.
   --  @param handle Handle obtained from `nvs_open` function.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param length Length required to hold the value.
   --  @return
   --    - `ESP_OK` if the value was retrieved successfully
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints

   procedure nvs_get_str_length
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      length : out size_t);
   --  Get length of the string value for given key.
   --
   --  If key does not exist, or the requested variable type doesn't match
   --  the type which was used when setting a value, an error is returned.
   --
   --  `length` is in bytes, and includes null terminator.
   --  @param handle Handle obtained from `nvs_open` function.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param length Length required to hold the value.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints

   function nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array;
      length    : out size_t) return esp_err_t;
   --  Get string value for given key.
   --
   --  If key does not exist, or the requested variable type doesn't match
   --  the type which was used when setting a value, an error is returned.
   --
   --  In case of any error, `out_value` is not modified.
   --
   --  Use `nvs_get_str_length` to get the size necessary to store the value.
   --  @param handle Handle obtained from `nvs_open` function.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param out_value Output value.
   --  @param length
   --    Actual length of the value written, includes zero terminator.
   --  @return
   --    - `ESP_OK` if the value was retrieved successfully
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints
   --    - `ESP_ERR_NVS_INVALID_LENGTH` if length of `out_value` is not
   --      sufficient to store data

   procedure nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array;
      length    : out size_t);
   --  Get string value for given key.
   --
   --  If key does not exist, or the requested variable type doesn't match
   --  the type which was used when setting a value, an error is returned.
   --
   --  In case of any error, `out_value` is not modified.
   --
   --  Use `nvs_get_str_length` to get the size necessary to store the value.
   --  @param handle Handle obtained from `nvs_open` function.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param out_value Output value.
   --  @param length
   --    Actual length of the value written, includes zero terminator.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints
   --    - `ESP_ERR_NVS_INVALID_LENGTH` if length of `out_value` is not
   --      sufficient to store data

   function nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array) return esp_err_t;
   --  Get string value for given key.
   --
   --  If key does not exist, or the requested variable type doesn't match
   --  the type which was used when setting a value, an error is returned.
   --
   --  In case of any error, `out_value` is not modified.
   --
   --  Use `nvs_get_str_length` to get the size necessary to store the value.
   --  @param handle Handle obtained from `nvs_open` function.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param out_value Output value.
   --  @return
   --    - `ESP_OK` if the value was retrieved successfully
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints
   --    - `ESP_ERR_NVS_INVALID_LENGTH` if length of `out_value` is not
   --      sufficient to store data

   procedure nvs_get_str
     (handle    : nvs_handle_t;
      key       : ESPIDF.C_Strings.char_array_string;
      out_value : out ESPIDF.C_Strings.char_array);
   --  Get string value for given key.
   --
   --  If key does not exist, or the requested variable type doesn't match
   --  the type which was used when setting a value, an error is returned.
   --
   --  In case of any error, `out_value` is not modified.
   --
   --  Use `nvs_get_str_length` to get the size necessary to store the value.
   --  @param handle Handle obtained from `nvs_open` function.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param out_value Output value.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_FAIL` if there is an internal error; most likely due to
   --      corrupted NVS partition (only if NVS assertion checks are disabled)
   --    - `ESP_ERR_NVS_NOT_FOUND` if the requested key doesn't exist
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints
   --    - `ESP_ERR_NVS_INVALID_LENGTH` if length of `out_value` is not
   --      sufficient to store data

   function nvs_set_str
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      value  : ESPIDF.C_Strings.char_array_string) return esp_err_t
     with Import, Convention => C, External_Name => "nvs_set_str";
   --  Set string for given key.
   --
   --  Note that the underlying storage will not be updated until
   --  `nvs_commit` is called.
   --  @param handle
   --    Handle obtained from `nvs_open` function. Handles that were opened
   --    read only cannot be used.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param value
   --    The value to set. The maximum length (including null character) is
   --    4000 bytes, if there is one complete page free for writing. This
   --    decreases, however, if the free space is fragmented.
   --  @return
   --    - `ESP_OK` if value was set successfully
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_READ_ONLY` if storage handle was opened as read only
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints
   --    - `ESP_ERR_NVS_NOT_ENOUGH_SPACE` if there is not enough space in the
   --      underlying storage to save the value
   --    - `ESP_ERR_NVS_REMOVE_FAILED` if the value wasn't updated because
   --      flash write operation has failed. The value was written however,
   --      and update will be finished after re-initialization of nvs,
   --      provided that flash operation doesn't fail again.
   --    - `ESP_ERR_NVS_VALUE_TOO_LONG` if the string value is too long

   procedure nvs_set_str
     (handle : nvs_handle_t;
      key    : ESPIDF.C_Strings.char_array_string;
      value  : ESPIDF.C_Strings.char_array_string);
   --  Set string for given key.
   --
   --  Note that the underlying storage will not be updated until
   --  `nvs_commit` is called.
   --  @param handle
   --    Handle obtained from `nvs_open` function. Handles that were opened
   --    read only cannot be used.
   --  @param key
   --    Key name. Maximum length is (NVS_KEY_NAME_MAX_SIZE-1) characters.
   --    Shouldn't be empty.
   --  @param value
   --    The value to set. The maximum length (including null character) is
   --    4000 bytes, if there is one complete page free for writing. This
   --    decreases, however, if the free space is fragmented.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_NVS_INVALID_HANDLE` if handle has been closed or is NULL
   --    - `ESP_ERR_NVS_READ_ONLY` if storage handle was opened as read only
   --    - `ESP_ERR_NVS_INVALID_NAME` if key name doesn't satisfy constraints
   --    - `ESP_ERR_NVS_NOT_ENOUGH_SPACE` if there is not enough space in the
   --      underlying storage to save the value
   --    - `ESP_ERR_NVS_REMOVE_FAILED` if the value wasn't updated because
   --      flash write operation has failed. The value was written however,
   --      and update will be finished after re-initialization of nvs,
   --      provided that flash operation doesn't fail again.
   --    - `ESP_ERR_NVS_VALUE_TOO_LONG` if the string value is too long

private

   type nvs_handle_t is new uint32_t;

end ESPIDF.NVS_Flash;
