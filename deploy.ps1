

$wd = pwd
$pubdir = "$PSScriptRoot\bin\Debug\net7.0\publish"

<#
$time = Get-Date -f "yyyy.MM.dd.hhmm"
$timestampcs = @"
namespace BlazorAddIn.Shared
{
	public static class Timestamp
	{
		public static string version = "$time";
	}
}
"@
$timestampcs > $PSScriptRoot\Shared\Timestamp.cs
#>
<#
git branch -D gh-pages
git checkout --orphan gh-pages

#>
if (Test-Path $PSScriptRoot\docs) {
	Remove-Item $PSScriptRoot\docs\* -Recurse
}

dotnet publish --self-contained

#Remove-Item $PSScriptRoot\docs -Recursew
Copy-Item -Recurse $pubdir\wwwroot\* .\docs

#Copy-Item -Recurse $pubdir\wwwroot $PSScriptRoot\.\docs

#Copy-Item $PSScriptRoot\MesWordAddinManifest.xml $pubdir\docs\
Copy-Item $PSScriptRoot\_config.yml $PSScriptRoot\docs\
Copy-Item $PSScriptRoot\CNAME $PSScriptRoot\docs\

cd $PSScriptRoot\docs

Remove-Item .git -Recurse
git init
git branch -D gh-pages
git checkout --orphan gh-pages
git remote add origin git@github.com:tokakuya/SMWE.git
git add *
git commit -m "force commit"
git push origin gh-pages -f

git checkout main

cd $wd