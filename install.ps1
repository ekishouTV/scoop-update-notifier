param(
    [string]$ExecutionDateTime = '10:00'
)

Set-Location $PSScriptRoot

$taskName = 'scoop-update-notifier'
$scriptName = 'execute-on-task-scheduler.vbs'

$action = New-ScheduledTaskAction -Execute (Convert-Path $scriptName)
$settings = New-ScheduledTaskSettingsSet -Hidden -AllowStartIfOnBatteries -StartWhenAvailable
$trigger = New-ScheduledTaskTrigger -DaysInterval 1 -Daily -At $ExecutionDateTime

Register-ScheduledTask -User $env:USERNAME -TaskName $taskName -Action $action -Settings $settings -Trigger $trigger
