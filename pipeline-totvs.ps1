function Get-IniContent ($filePath)
{
    $ini = @{}
    switch -regex -file $FilePath
    {
        “^\[(.+)\]” # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        “^(;.*)$” # Comment
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = “Comment” + $CommentCount
            $ini[$section][$name] = $value
        } 
        “(.+?)\s*=(.*)” # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini
}

try {
  
  # Diretorio Base
  $BaseDir = "D:\totvs\protheus\treinamento\protheus12"
  
  # Diretorio com as includes
  $IncludeFolder = "$BaseDir\include"
  
  # Caminho do RPO onde os fontes eram compilados
  $BuildPath = "$BaseDir\apo\build"
  
  # Caminho do novo RPO
  $DestPath = "$BaseDir\apo\production\$ENV:BUILD_NUMBER"
  
  # Caminho do appserver de producao
  $ProductionAppServer = "$BaseDir\bin\appserver"
  
  # Le o arquivo ini e busca o SourcePath atual
  $IniData = Get-IniContent "$ProductionAppServer\appserver.ini"
  $SourcePath = $IniData['Producao']['SourcePath']
  Write-Host "RPO Current Folder: $SourcePath"
  
  # Copia o RPO atual para o diretorio BUILD
  Write-Host "Copying file $SourcePath\tttp120.rpo to $BuildPath"
  Copy-Item -Path $SourcePath\* -Destination $BuildPath -Recurse -Force
  
  # Compila os fontes utilizando o appserver
  cd $BaseDir\bin\appserver_devops
  
  ./appserver.exe -compile -files="$ENV:WORKSPACE" -includes="$IncludeFolder" -env=BUILD
  
  # Criando estrutura do novo RPO e copia o mesmo para o novo diretorio
  New-Item -ItemType Directory -Path $DestPath
  Copy-Item -Path $BuildPath\* -Destination "$DestPath\tttp120.rpo" -Recurse -Force
  
  # Troca a informacao no INI de producao
  Copy-Item -Path "$ProductionAppServer\appserver.ini" -Destination "$ProductionAppServer\appserver_Bkp.ini" -Force
  
  
  
  Write-Host "Updating appserver.ini..."
  Write-Host "Previous content: $SourcePath" 
  Write-Host "New content: $DestPath" 
  
  (Get-Content $ProductionAppServer\appserver.ini).replace($SourcePath, $DestPath) | Set-Content $ProductionAppServer\appserver.ini

}
catch
{
    write-host "Caught an exception"
    exit 1
}