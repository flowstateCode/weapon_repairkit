['weaponrepairkit'] = {
    label = 'Weapon Repair Kit',
    weight = 200,
    stack = true,
    close = true,
    consume = 1,
    allowArmed = true,
    client = {
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' }, -- mechanic-style repair
        usetime = 5000,
        onStart = function(playerPed)
            local weapon = GetSelectedPedWeapon(playerPed)
            if weapon == `WEAPON_UNARMED` then return end

            local boneIndex = GetPedBoneIndex(playerPed, 57005) -- right hand
            local weaponModel = GetWeapontypeModel(weapon)
            RequestModel(weaponModel)
            while not HasModelLoaded(weaponModel) do Wait(10) end

            local weaponObj = CreateObject(weaponModel, 1.0, 1.0, 1.0, true, true, false)
            AttachEntityToEntity(weaponObj, playerPed, boneIndex, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

            -- Store object reference to delete later
            playerPed.RepairWeaponObj = weaponObj
        end,
        onStop = function(playerPed)
            if playerPed.RepairWeaponObj then
                DeleteObject(playerPed.RepairWeaponObj)
                playerPed.RepairWeaponObj = nil
            end
        end
    },
    server = {
        export = 'esx_weaponrepair.weaponrepairkit'
    }
},