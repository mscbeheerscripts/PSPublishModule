﻿function Get-MissingFunctions {
    [CmdletBinding()]
    param(
        [alias('Path')][string] $FilePath,
        [string[]] $Functions,
        [switch] $Summary,
        [switch] $SummaryWithCommands
    )
    $ListCommands = [System.Collections.Generic.List[Object]]::new()
    $Result = Get-ScriptCommands -FilePath $FilePath -CommandsOnly
    $FilteredCommands = Get-FilteredScriptCommands -Commands $Result -NotUnknown -NotCmdlet -Functions $Functions -NotApplication

    foreach ($_ in $FilteredCommands) {
        $ListCommands.Add($_)
    }
    # this gets commands along their ScriptBlock
    Get-RecursiveCommands -Commands $FilteredCommands

    $FunctionsOutput = foreach ($_ in $ListCommands) {
        "function $($_.Name) { $($_.ScriptBlock) }"
    }
    if ($SummaryWithCommands) {
        $Hash = @{
            Summary   = $ListCommands
            Functions = $FunctionsOutput
        }
        return $Hash
    } elseif ($Summary) {
        return $ListCommands
    } else {
        return $FunctionsOutput
    }
}