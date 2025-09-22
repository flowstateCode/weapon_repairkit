RegisterNetEvent('esx_weaponrepair:repairWeapon', function()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)

    if weapon == `WEAPON_UNARMED` then
        lib.notify({
            title = 'Weapon Repair',
            description = 'You must hold a weapon to repair it.',
            type = 'error',
            position = 'top'
        })
        return
    end

    local boneIndex = GetPedBoneIndex(ped, 57005)
    local weaponModel = GetWeapontypeModel(weapon)
    RequestModel(weaponModel)
    while not HasModelLoaded(weaponModel) do Wait(10) end

    local weaponObj = CreateObject(weaponModel, 1.0, 1.0, 1.0, true, true, false)
    AttachEntityToEntity(weaponObj, ped, boneIndex, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    local animDict = 'mini@repair'
    local animClip = 'fixing_a_ped'
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    TaskPlayAnim(ped, animDict, animClip, 8.0, -8.0, 5000, 49, 0, false, false, false)
    Wait(5000)

    ClearPedTasks(ped)
    DeleteObject(weaponObj)

    local _, maxAmmo = GetMaxAmmo(ped, weapon)
    if maxAmmo and maxAmmo > 0 then
        SetPedAmmo(ped, weapon, maxAmmo)
    end

    lib.notify({
        title = 'Weapon Repair',
        description = 'Your weapon has been repaired!',
        type = 'success',
        position = 'top'
    })
end)