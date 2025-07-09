modules.libraries.settings = {}
-- this doesnt have any loggine because the logging lib requires the settings lib meaning that its either logging cant use settings or settings cant use logging

modules.libraries.settings._settings = require "settings"

function modules.libraries.settings:create(name,value,default)
    if not self._settings[name] then
        self._settings[name] = {value = value, default = default}
        return self._settings[name]
    end
end

function modules.libraries.settings:getSetting(name,default)
    if not self._settings[name] or self._settings.value then
        return default
    end
    return self._settings[name].value
end

function modules.libraries.settings:getValue(name,createSettingIfNotExists,default)
    if not self._settings[name] then
        if createSettingIfNotExists then
            self:create(name, default, default)
            return default
        end
        return default
    end
    if self._settings[name].value == nil then
        if not self._settings[name].default then
            self._settings[name].default = default
        end
        return self._settings[name].default
    end
    return self._settings[name].value
end

function modules.libraries.settings:setValue(name,value)
    if not self._settings[name] then
        return
    end
    self._settings[name].value = value
end

function modules.libraries.settings:setDefault(name,default)
    if not self._settings[name] then
        return
    end
    self._settings[name].default = default
end

function modules.libraries.settings:resetToDefault(name)
    if not self._settings[name] then
        return
    end
    if not self._settings[name].default then
        return
    end
    self._settings[name].value = self._settings[name].default
end