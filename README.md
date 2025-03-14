# gm_shaderbuild
Allows anyone to hotload shaders using a fix by renaming the contents.


# Install Instructions
Step 1) Install: https://github.com/ficool2/sdk_screenspace_shaders

Step 2) Apply the content of this folder into the existing addon into the folder in step 1, of the above repository. 
        This appear like so:
![image](https://github.com/user-attachments/assets/68d4cd0e-0a15-4827-a155-7f2b74986897)


Step 3) Adjust game path within `process_shaders_single_30.ps1` relative to the game paths described @ lines 13-15
        If you're game's relative path is different, please locate them and change the lines to match your project.

        This should be the path to your materials folder, shader path and your local version (within the setup of step 1) the material file template.

Step 4) Attach the following code bracket to the vscode setup we're using (Thanks Ficool!)
The file should be called: "TASKS.JSON" which is located in the main '.vscode' folder.


```
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
```

Like so:
![image](https://github.com/user-attachments/assets/72b09926-f4ed-4d63-a3c2-cb46353189aa)


# License

## MIT License with Attribution Requirement  

© 2025 - EthanTheGreat 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, subject to the following conditions:  

### Attribution Requirement  
Any derivative works, copies, or distributions of this Software must include the following citation within the source code:  

```plaintext
This software includes code developed by EthanTheGreat.
