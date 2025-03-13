
############# Install Instructions #############
Step 1) Install: https://github.com/ficool2/sdk_screenspace_shaders
Step 2) Apply existing addon into the root folder, of the above repository. 
Step 3) Adjust game path within `process_shaders_single_30.ps1` relative to the game paths described @ lines 13-15

Please Modify the ps1 file with the following folder paths:
        <garrysmod>/<garrysmod>/materials/effects/shaders
        <garrysmod>/<garrysmod>/shaders/fxc
        <ToolDir>/materials/effects/shaders/template

Attach the following code bracket to the vscode setup we're using (Thanks Ficool!)
The file should be called: "TASKS.JSON" which is located in the main '.vscode' folder.


....
....

        {
            "label": "Build Shader (FAST)",
            "type": "shell",
            "command": "powershell",
            "args": [
                "-NoLogo",
                "-ExecutionPolicy",
                "Bypass",
                "-Command",
                "bin\\process_shaders_single_30.ps1"
                "${file}"
            ],
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            },
            "problemMatcher": [],
            "options": {
                "cwd": "${workspaceFolder}/shadersrc"
            }
        },

....

.....
