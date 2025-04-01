

param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"
$PropertyBag = $ScomAPI.CreatePropertyBag()

$RemoteFolderPath = "\\SCOM-MS2\ImageStore"
$State = "Unknown"
$FileCount = 0
$Threshold = 5
$whoami = whoami.exe

# Original One liner
# Test-Path \\SCOM-MS2\ImageStore



Try {
    If (Test-Path $RemoteFolderPath) {
        $FileCount = (Get-ChildItem $RemoteFolderPath -PathType Leaf | Measure-Object).Count
        if ($FileCount -lt $Threshold) {
            $State = "UnderThreshold"
            }
        else    {
            $State = "OverThreshold"
            }
        }

    }

    catch {
            $State = "OverThreshold"
            $FileCount = "Unknown - Path not available"
    }
       
    finally  {
    # Properties of our alert

    $ScomAPI.LogScriptEvent("RemoteFolderCheck.ps1",9999,2,"Check Folder Test = " + $CheckFolder + ", Remote Folder Path = " + $RemoteFolderPath + ", State = " + $State + ", FileCount = " + $FileCount + ", Threshold = " + $Threshold)

    $PropertyBag.AddValue("FileCount",$FileCount)
    $PropertyBag.AddValue("Threshold",$Threshold)
    $PropertyBag.AddValue("RemoteFolderPath",$RemoteFolderPath)
    $PropertyBag.AddValue("WhoamI",$whoami)
    
    # Property Bag for Health State
    $PropertyBag.AddValue("State",$State)

    # Return $PropertyBag to SCOM
    $PropertyBag
}


