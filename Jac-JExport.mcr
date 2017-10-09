(
    rollout JacsRollout "JExport" width:338 height:40
    (
        button eButton "Export" pos:[8,8] width:72 height:24 tooltip:"Export Selected Meshes"
        button exportType "FBX" pos:[86,8] width:28 height:24 tooltip:"Toggle FBX/OBJ"
        checkbox ZeroPos "Zero" pos:[120,20] width:42 height:15 tooltip:"Move each object to 0,0,0 on Export"
        checkbox ExportPrompt "Prompt" pos:[120,4] width:55 height:15 tooltip:"Bring up prompt on Export"
        checkbox ZeroXforms "Xforms" pos:[184,20] width:55 height:15 tooltip:"Reset Xforms on Export"
        checkbox RotX "Rot X" pos:[184,4] width:55 height:15 tooltip:"Rotate X-axis 90deg on Export (for Unity)"
        button Aboutbutton "About" pos:[248,2] width:72 height:16
        button FolderButton "Folder" pos:[248,20] width:72 height:16 tooltip:"Open Export Folder"

        fn export path prompt = (
            makeDir @".\Exports\"
            if prompt then (
                exportFile path selectedOnly:true
            ) else (
                exportFile path #noPrompt selectedOnly:true
            )
        )

        fn RotatePivotOnly obj rotation = (local rotValInv=inverse (rotation as quat)
            animate off in coordsys local obj.rotation*=RotValInv
            obj.objectoffsetpos*=RotValInv
            obj.objectoffsetrot*=RotValInv
            )

        on eButton pressed do
        (
            if (selection.count == 0) or (maxfilepath=="") then (messageBox "Make sure you have saved your max file and have selected an Object before Exporting!")
            else (
                if exportPrompt.checked then ( prompt = true ) else (prompt = false )
                selarray = selection as array
                for node in selarray do (
                    select node
                    oripos = node.pos
                    if ZeroPos.checked then ( node.pos = [0,0,0] ) else ()
                    if ZeroXforms.checked then ( macros.run "PolyTools" "ResetXForm" ) else ()
                    if RotX.checked then ( RotatePivotOnly $selection (EulerAngles 90 0 0) ) else ()
                    exportPath = maxFilePath + "Exports\\" + node.name + "." + (toLower exportType.text)
                    export exportPath prompt
                    if RotX.checked then ( RotatePivotOnly $selection (EulerAngles -90 0 0) ) else ()
                    node.pos = oripos
                )
                select selarray
            )
        )
        on exportType pressed do (
            if exportType.text == "FBX" then (
                exportType.text = "OBJ"
            ) else (
                exportType.text = "FBX"
            )
        )

        --(
        on Aboutbutton pressed do
        (
        messageBox "created by http://www.jacrossiter.com , Olli Koskelainen and Jake Oliver" title:"About"
        )
        on FolderButton pressed do
        (
        if (doesfileexist"exports"==true) then
        (ShellLaunch "explorer.exe" (MaxFilePath+"Exports\\"))
        else
        (messageBox "You haven't exported anything yet!")
        )
        --)
    )

    createdialog JacsRollout
    cui.RegisterDialogBar JacsRollout style:#(#cui_dock_all, #cui_floatable)

)
