#Written By Ficool originally, Modified by EthanTheGreat
#Resolves workaround for hotloading shaders.

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][System.IO.FileInfo]$File,
    #[Parameter(Mandatory=$true)][string]$Version,
    [Parameter(Mandatory=$false)][System.UInt32]$Threads
)

# Please Define Paths
# Define Game Directory !!!! Please change the following paths, if it's not the same root directory.
$material_path = "C:/Program Files (x86)/Steam/steamapps/common/GarrysMod/garrysmod/materials/effects/shaders" # End path for VMTS
$shader_path = "C:/Program Files (x86)/Steam/steamapps/common/GarrysMod/garrysmod/shaders/fxc/" # Shader Export path. I'd just store them here.
$templatePath = Join-Path $PSScriptRoot "/materials/effects/shaders/template.vmt" #Universal Static Reference. Necessary for repetition.
# THIS ABOVE MUST, include $vertexshader now.

$Version = "30"; #default, free to change, won't matter.
    if ($File.BaseName -match "_vs2") {
        $Version = "20b";
    }
    if ($File.BaseName -match "_vs3") {
        $Version = "30";
    }
    if ($File.BaseName -match "_ps2") {
        $Version = "20b";
    }
    if ($File.BaseName -match "_ps3") {
        $Version = "30";
    }

$baseFileName = $File.BaseName
Write-Output "Writing Shaders for $Version as: $baseFileName..."

if ($Version -notin @("20b", "30", "40", "41", "50", "51")) {
	return
}

# Create a vmt file from template if it doesn't exist
$baseName = $File.BaseName -replace "_(vs|ps|gs|hs|ds|cs|ms)?[23]x$", ""
$baseName2 = $baseFileName.Substring(0, $baseFileName.Length - 1) + "0.vcs"
$baseName3 = $baseFileName.Substring(0, $baseFileName.Length - 1) + "0"

#If Vertex Shader
$isPixelShader = 0
$isVertexShader = 0

$shaderPostFix = ""
if ($File.BaseName -match "_vs") {
    $isVertexShader = 1
    $shaderPostFix = "_vs"+$Version
} elseif ($File.BaseName -match "_ps") {
    $isPixelShader = 1
    $shaderPostFix = "_ps"+$Version
} else {
    # Optional: Handle cases where neither is found
    Write-Output "$File.BaseName"
    return
}



if ((Test-Path $templatePath) -and -not (Test-Path $vmtPath)) {
    $content = Get-Content $templatePath -Raw
        if($isVertexShader) {
            $content = $content -replace '\$vertexshader\s+"[^"]*"', "`$vertexshader `"$baseName`$shaderPostFix`""
        }

        if($isPixelShader) { 
            $content = $content -replace '\$pixshader\s+"[^"]*"', "`$pixshader `"$baseName`$shaderPostFix`""
        }
    Set-Content -Path $vmtPath -Value $content
}

# Run ShaderCompile
if ($Threads -ne 0) {
	& "$PSScriptRoot\ShaderCompile" "-threads" $Threads "-ver" $Version "-shaderpath" $File.DirectoryName $File.Name
} else {
    & "$PSScriptRoot\ShaderCompile" "-ver" $Version "-shaderpath" $File.DirectoryName $File.Name
}

#--------------#
# Define the file path
$countFilePath = Join-Path $PSScriptRoot "../../refresh_count.txt"

# Check if the file exists; if not, create it with a default value of 0
if (!(Test-Path $countFilePath)) {
    "0" | Set-Content -Path $countFilePath
}

# Read the file and convert the content to an integer
$count = Get-Content -Path $countFilePath | ForEach-Object { [int]$_ }

# Increment the count
$count++

# Write the updated count back to the file
$count | Set-Content -Path $countFilePath

# Display the new count for debugging
Write-Host "Updated count: $count"

$oldCount = $count - 1
$oldCount = $oldCount.ToString()
$count = $count.ToString()

#======================================================= Copy Paste =================================#
# Determine Output File as VMT
$outputFileName = "$baseName.vmt"  # Adjust if the output file has a different format
$outputFilePath = Join-Path $PSScriptRoot "/../../materials/effects/shaders/$outputFileName"
$destinationPath = Join-Path $material_path $outputFileName
$fin = $count + "_" + $baseName3
# Ensure the game directory exists
if (!(Test-Path $material_path)) {
    New-Item -ItemType Directory -Path $material_path -Force
}

# Copy the file and overwrite if it exists
if (Test-Path $outputFilePath) {
    Copy-Item -Path $outputFilePath -Destination $destinationPath -Force

    if ((Test-Path $destinationPath)) {
        
        $content = Get-Content $destinationPath -Raw
        if($isVertexShade) {
            $content = $content -replace '\$vertexshader\s+"[^"]*"', "`$vertexshader `"$fin`""
        }

        if($isPixelShader) { 
            $content = $content -replace '\$pixshader\s+"[^"]*"', "`$pixshader `"$fin`""
        }
        
        Set-Content -Path $destinationPath -Value $content
    }

    Write-Host "Successfully copied:`n$outputFilePath `nTo`n $destinationPath"
} else {
    Write-Host "Error: Output file $outputFilePath not found. Add Default VMT file!"
}

#===================================#
#======================================================= Copy Paste (Shader) =================================#
# Determine Output File (Shader) & Delete 

$outputFilePath = Join-Path $PSScriptRoot "/../../shadersrc/shaders/fxc/$baseName2"
$destinationPath = Join-Path $shader_path $baseName2

# Ensure the shader directory exists
if (!(Test-Path $shader_path)) {
    New-Item -ItemType Directory -Path $shader_path -Force
}

# Copy the file and overwrite if it exists
if (Test-Path $outputFilePath) {
    $newFileName = $count + "_$baseName2"
    $newDestinationPath = Join-Path $shader_path $newFileName

    Copy-Item -Path $outputFilePath -Destination $newDestinationPath -Force
    Write-Host "Successfully copied: $outputFilePath to $newDestinationPath"
} else {
    Write-Host "Error: Output file $outputFilePath not found. Did not locate VCS file."
}

#===================================================================================#
# Remove old files ---
$oldName = $oldCount + "_" + $baseName2
$destructionPath = Join-Path $shader_path $oldName

# Check if the file exists and remove it
if (Test-Path $destructionPath) {
    Remove-Item -Path $destructionPath -Force
    Write-Host "Old Removed: $destructionPath"
} else {
    Write-Host "File not found: $destructionPath"
}