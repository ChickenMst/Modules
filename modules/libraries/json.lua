modules.libraries.json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Credit
-------------------------------------------------------------------------------

-- This is a modified version of https://github.com/rxi/json.lua/blob/master/json.lua

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

modules.libraries.json._escape_char_map = {
  [ "\\" ] = "\\",
  [ "\"" ] = "\"",
  [ "\b" ] = "b",
  [ "\f" ] = "f",
  [ "\n" ] = "n",
  [ "\r" ] = "r",
  [ "\t" ] = "t",
}

modules.libraries.json._escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(modules.libraries.json._escape_char_map) do
  modules.libraries.json._escape_char_map_inv[v] = k
end


function modules.libraries.json._escape_char(c)
  return "\\" .. (modules.libraries.json._escape_char_map[c] or string.format("u%04x", c:byte()))
end


function modules.libraries.json._encode_nil(val)
  return "null"
end


function modules.libraries.json:_encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then modules.libraries.logging:error("libraries.json","circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        modules.libraries.logging:error("libraries.json","invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      modules.libraries.logging:error("libraries.json","invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, self._encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"

  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        modules.libraries.logging:error("libraries.json","invalid table: mixed or invalid key types")
      end
      table.insert(res, self:_encode(k, stack) .. ":" .. self:_encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


function modules.libraries.json:_encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', self._escape_char) .. '"'
end


function modules.libraries.json:_encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    modules.libraries.logging:error("libraries.json","unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


modules.libraries.json._type_func_map = {
  [ "nil"     ] = modules.libraries.json._encode_nil,
  [ "table"   ] = modules.libraries.json._encode_table,
  [ "string"  ] = modules.libraries.json._encode_string,
  [ "number"  ] = modules.libraries.json._encode_number,
  [ "boolean" ] = tostring,
}


function modules.libraries.json:_encode(val, stack)
  local t = type(val)
  local f = self._type_func_map[t]
  if f then
    return f(val, stack)
  end
  modules.libraries.logging:error("libraries.json","unexpected type '" .. t .. "'")
end


function modules.libraries.json:encode(val)
  return ( self._encode(val) )
end


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

function modules.libraries.json:_create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

modules.libraries.json._space_chars = modules.libraries.json:_create_set(" ", "\t", "\r", "\n")
modules.libraries.json._delim_chars = modules.libraries.json:_create_set(" ", "\t", "\r", "\n", "]", "}", ",")
modules.libraries.json._escape_chars = modules.libraries.json:_create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
modules.libraries.json._literals = modules.libraries.json:_create_set("true", "false", "null")

modules.libraries.json._literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


function modules.libraries.json:_next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


function modules.libraries.json:_decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  modules.libraries.logging:error("libraries.json", string.format("%s at line %d col %d", msg, line_count, col_count) )
end


function modules.libraries.json:_codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  modules.libraries.logging:error("libraries.json", string.format("invalid unicode codepoint '%x'", n) )
end


function modules.libraries.json:_parse_unicode_escape(s)
  local n1 = tonumber( s:sub(1, 4),  16 )
  local n2 = tonumber( s:sub(7, 10), 16 )
   -- Surrogate pair?
  if n2 then
    return self:_codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return self:codepoint_to_utf8(n1)
  end
end


function modules.libraries.json:_parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      self:_decode_error(str, j, "control character in string")

    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                 or str:match("^%x%x%x%x", j + 1)
                 or self:_decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. self:_parse_unicode_escape(hex)
        j = j + #hex
      else
        if not self._escape_chars[c] then
          self:_decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. modules.libraries.json._escape_char_map_inv[c]
      end
      k = j + 1

    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  self:_decode_error(str, i, "expected closing quote for string")
end


function modules.libraries.json:_parse_number(str, i)
  local x = self:_next_char(str, i, self._delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    self:_decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


function modules.libraries.json:_parse_literal(str, i)
  local x = self:_next_char(str, i, self._delim_chars)
  local word = str:sub(i, x - 1)
  if not self._literals[word] then
    self:_decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return self._literal_map[word], x
end


function modules.libraries.json:_parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = self:_next_char(str, i, self._space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = self:_parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = self:_next_char(str, i, self._space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then self:_decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


function modules.libraries.json:_parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = self:_next_char(str, i, self._space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      self:_decode_error(str, i, "expected string for key")
    end
    key, i = self:_parse(str, i)
    -- Read ':' delimiter
    i = self:_next_char(str, i, self._space_chars, true)
    if str:sub(i, i) ~= ":" then
      self:_decode_error(str, i, "expected ':' after key")
    end
    i = self:_next_char(str, i + 1, self._space_chars, true)
    -- Read value
    val, i = self:_parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = self:_next_char(str, i, self._space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then self:_decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


modules.libraries.json._char_func_map = {
  [ '"' ] = modules.libraries.json._parse_string,
  [ "0" ] = modules.libraries.json._parse_number,
  [ "1" ] = modules.libraries.json._parse_number,
  [ "2" ] = modules.libraries.json._parse_number,
  [ "3" ] = modules.libraries.json._parse_number,
  [ "4" ] = modules.libraries.json._parse_number,
  [ "5" ] = modules.libraries.json._parse_number,
  [ "6" ] = modules.libraries.json._parse_number,
  [ "7" ] = modules.libraries.json._parse_number,
  [ "8" ] = modules.libraries.json._parse_number,
  [ "9" ] = modules.libraries.json._parse_number,
  [ "-" ] = modules.libraries.json._parse_number,
  [ "t" ] = modules.libraries.json._parse_literal,
  [ "f" ] = modules.libraries.json._parse_literal,
  [ "n" ] = modules.libraries.json._parse_literal,
  [ "[" ] = modules.libraries.json._parse_array,
  [ "{" ] = modules.libraries.json._parse_object,
}


function modules.libraries.json:_parse(str, idx)
  local chr = str:sub(idx, idx)
  local f = modules.libraries.json._char_func_map[chr]
  if f then
    return f(str, idx)
  end
  self:decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function modules.libraries.json:decode(str)
  if type(str) ~= "string" then
    modules.libraries.logging:error("libraries.json","expected argument of type string, got " .. type(str))
  end
  local res, idx = self:_parse(str, self:_next_char(str, 1, self._space_chars, true))
  idx = self:_next_char(str, idx, self._space_chars, true)
  if idx <= #str then
    self:_decode_error(str, idx, "trailing garbage")
  end
  return res
end