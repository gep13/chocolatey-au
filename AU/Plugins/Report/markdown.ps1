. $PSScriptRoot\markdown_funcs.ps1

$now             = $Info.startTime.ToUniversalTime().ToString('yyyy-MM-dd HH:mm')
$au_version      = gmo au -ListAvailable | % Version | select -First 1 | % { "$_" }
$package_no      = $Info.result.all.Length
$Github_UserRepo = $Params.Github_UserRepo
$UserMessage     = $Params.UserMessage

$icon_ok = 'https://cdn.rawgit.com/majkinetor/au/integrate/AU/Plugins/Report/r_ok.png'
$icon_er = 'https://cdn.rawgit.com/majkinetor/au/integrate/AU/Plugins/Report/r_er.png'

"# Update-AUPackages"

#=== Header ===============================
@"
[![](https://ci.appveyor.com/api/projects/status/github/${Github_UserRepo}?svg=true)](https://ci.appveyor.com/project/$Github_UserRepo/build/$Env:APPVEYOR_BUILD_NUMBER)
[![$package_no](https://img.shields.io/badge/AU%20packages-$($package_no)-red.svg)](#ok)
[![$au_version](https://img.shields.io/badge/AU-$($au_version)-blue.svg)](https://www.powershellgallery.com/packages/AU)
[![](http://transparent-favicon.info/favicon.ico)](#)[![](http://transparent-favicon.info/favicon.ico)](#)
[![](http://transparent-favicon.info/favicon.ico)](#)[![](http://transparent-favicon.info/favicon.ico)](#)
**UTC**: $now [![](http://transparent-favicon.info/favicon.ico)](#) [$Github_UserRepo](https://github.com/$Github_UserRepo)

_This file is automatically generated by the [update_all.ps1](https://github.com/$Github_UserRepo/blob/master/update_all.ps1) script using the [AU module](https://github.com/majkinetor/au)._
"@ | Out-String

"$UserMesage"

#=== Body ===============================

$errors_word = if ($Info.error_count.total -eq 1) {'error'} else {'errors' }
if ($Info.error_count.total) {
    "<img src='$icon_er' width='24'> **LAST RUN HAD $($Info.error_count.total) [$($errors_word.ToUpper())](#errors) !!!**" }
else {
    "<img src='$icon_ok' width='24'> **Last run was OK**"
}

""
md_fix_newline $Info.stats

if ($Info.pushed) {
    md_title Pushed
    md_table $Info.result.pushed -Columns 'Name', 'Updated', 'Pushed', 'RemoteVersion', 'NuspecVersion'
}

if ($Info.error_count.total) {
    md_title Errors
    md_table $Info.result.errors -Columns 'Name', 'NuspecVersion', 'Error'
    $Info.result.errors | % {
        md_title $_.Name -Level 3
        md_code "$($_.Error)"
    }
}

if ($Info.result.ok) {
    md_title OK
    md_table $Info.result.ok -Columns 'Name', 'Updated', 'Pushed', 'RemoteVersion', 'NuspecVersion'
    $Info.result.ok | % {
        md_title $_.Name -Level 3
        md_code $_.Result
    }
}
