local ox = exports.ox_inventory

exports('weaponrepairkit', function(event, item, inventory, slot, data)
    local src = inventory.id

    if event == 'usingItem' then
        local current = ox:GetCurrentWeapon(src)
        local weapon_name
        if type(current) == 'table' then
            weapon_name = current.name or current.hash or current.label
        elseif type(current) == 'string' then
            weapon_name = current
        end

        if not weapon_name or weapon_name == '' or weapon_name == 'unarmed' then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'error',
                description = 'You must hold a weapon to use this.',
                position = 'top'
            })
            return false 
        end
        return
    end

    if event == 'usedItem' then
        local current = ox:GetCurrentWeapon(src)
        local weapon_name
        if type(current) == 'table' then
            weapon_name = current.name or current.hash or current.label
        elseif type(current) == 'string' then
            weapon_name = current
        end

        if weapon_name then
            local items = ox:GetInventoryItems(src)
            for _, v in pairs(items or {}) do
                if v and (v.name == weapon_name or v.name == string.lower(weapon_name or '')) then
                    ox:SetDurability(src, v.slot, 100)
                    TriggerClientEvent('ox_lib:notify', src, {
                        type = 'success',
                        description = 'Your weapon has been repaired!',
                        position = 'top'
                    })
                    return
                end
            end
        end

        TriggerClientEvent('esx_weaponrepair:repairWeapon', src)
        return
    end
end)