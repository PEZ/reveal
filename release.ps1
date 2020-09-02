param ([Parameter(Mandatory)]$version)

function invoke {
    $exe, $argsForExe = $Args
    $ErrorActionPreference = 'Continue'
    try { & $exe $argsForExe } catch { Throw }
    if ($LASTEXITCODE) { Throw "$exe indicated failure (exit code $LASTEXITCODE; full command: $Args)." }
}

clj -A:build -m version $version
clj -Spom
invoke git commit -am "Release $version"
invoke git tag $version
invoke git push
invoke git push origin $version
clj -A:depstar "$version.jar"
clj -A:build -m deploy "$version.jar" (Read-Host -Prompt "Username") (Read-Host -Prompt "Token" -AsSecureString | ConvertFrom-SecureString -AsPlainText)
rm "$version.jar"


