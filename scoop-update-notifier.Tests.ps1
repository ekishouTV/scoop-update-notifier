BeforeAll {
    # NOTE: Import a function from a self contained script without execution.
    # This magic from https://jakubjares.com/2019/06/09/2019-07-testing-whole-scripts/ .
    function f () {}
    New-Alias -Name Notify-Update -Value f
    . $PSScriptRoot/scoop-update-notifier.ps1 
    Remove-Item Alias:Notify-Update
    Remove-Item "function:/f"

    if (Test-Path .\previous-updates) {
        Remove-Item .\previous-updates
    }
    
    Mock scoop.cmd {} -ParameterFilter { $args[0] -eq 'update' }
}

Describe "scoop-update-notifier" {
    It "Up to date!" {
        Mock scoop.cmd {} -ParameterFilter { $args[0] -eq 'status' }
        Notify-Update | Should -Be 'Up to date!'
    }

    It "There is an update. <sameAsPrevious>" -ForEach @(
        @{sameAsPrevious = 'Not same as previous.'; message = 'There is an update.' }
        @{sameAsPrevious = 'Same as previous.'; message = 'There is an update.&#x0A;Should be update!' }
    ) {
        Mock scoop.cmd { [PSCustomObject]@{Name = 'hoge' } } -ParameterFilter { $args[0] -eq 'status' }
        Notify-Update | Should -Be $message
    }

    It "There are updates. <sameAsPrevious>" -ForEach @(
        @{sameAsPrevious = 'Not same as previous.'; message = 'There are 3 updates.' }
        @{sameAsPrevious = 'Same as previous.'; message = 'There are 3 updates.&#x0A;Should be update!' }
    ) {
        Mock scoop.cmd {
            (
                [PSCustomObject]@{Name = 'hoge' },
                [PSCustomObject]@{Name = 'fuga' },
                [PSCustomObject]@{Name = 'piyo' }
            )
        } -ParameterFilter { $args[0] -eq 'status' }
        Notify-Update | Should -Be $message
    }
}
