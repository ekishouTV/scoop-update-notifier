$ErrorActionPreference = 'Stop'

# Load assemblies.
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] > $null

function Notify-Update {
    Set-Location $PSScriptRoot

    scoop update
    $updates = scoop status

    $message = 'Up to date!'

    if ($updates) {
        $outdatedAppCount = ($updates | Measure-Object).Count
        if ($outdatedAppCount -eq 1) {
            # FIXME: End up reaching this context  even if only "WARN  Scoop bucket(s) out of date. Run 'scoop update' to get the latest changes." .
            $message = 'There is an update.'
        }
        else {
            $message = 'There are {0} updates.' -f $outdatedAppCount
        }

        if (Test-Path '.\previous-updates') {
            $updatesPrevious = Import-Clixml '.\previous-updates'

            $isSameAsPrevious = $null -eq (Compare-Object $updatesPrevious $updates -Property Name, 'Latest Version')
            if ($isSameAsPrevious) {
                $toastLineFeed = '&#x0A;'
                $message = $message + $toastLineFeed + 'Should be update!'
            }
        }

        $updates | Export-Clixml '.\previous-updates'
    }

    # NOTE: This is necessary for testing.
    Write-Output $message

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
}

Notify-Update
