(
    rollout JacsRollout "JExport" width:264 height:48
    (
        button eButton "Export" pos:[8,8] width:72 height:24 
        button exportType "FBX" pos:[86,8] width:28 height:24
        checkbox ZeroPos "Zero" pos:[120,20] width:42 height:15
        checkbox ExportPrompt "Prompt" pos:[120,4] width:55 height:15
        button Aboutbutton "About" pos:[184,2] width:72 height:16
        button FolderButton "Folder" pos:[184,20] width:72 height:16
        
        fn export path prompt = (
            makeDir @"Exports\"
            if prompt then (
                exportFile path selectedOnly:true
            ) else (
                exportFile path #noPrompt selectedOnly:true
            )
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
                    node.pos = [0,0,0]
                    exportPath = maxFilePath + "Exports\\" + node.name + "." + (toLower exportType.text)
                    export exportPath prompt
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
        messageBox "created by http://www.jacrossiter.com & Olli Koskelainen" title:"About"
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