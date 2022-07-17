$ErrorActionPreference = 'Stop'

# Load assemblies.
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] > $null

# Main
Set-Location $PSScriptRoot

scoop update > $null
$updates = scoop status

$message = 'Up to date!'

if ($updates)
{
    $outdatedAppCount = ($updates | Measure-Object).Count
    if ($outdatedAppCount -eq 1)
    {
        $message = 'There is 1 update.'
    }
    else
    {
        $message = 'There are {0} updates.' -f $outdatedAppCount
    }

    if (Test-Path '.\previous-updates')
    {
        $updatesPrevious = Import-Clixml '.\previous-updates'
    }

    $isSameAsPrevious = $null -eq (Compare-Object $updatesPrevious $updates -Property Name, 'Latest Version')
    if ($isSameAsPrevious)
    {
        $toastLineFeed = '&#x0A;'
        $message = $message + $toastLineFeed + 'Should be update!'
    }

    $updates | Export-Clixml '.\previous-updates'
}

$content = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>scoop-update-notifier</text>
            <text>$message</text>
        </binding>
    </visual>
</toast>
"@

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($content)

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(5)

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe')
$notifier.Show($toast)
