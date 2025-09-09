[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

iwr -UseBasicParsing 'https://ninite.com/.net4.8.1-7zip-chrome-firefox-foxit-vcredistx15-windirstat-zoom/ninite.exe' `
  -OutFile 'C:\Windows\Temp\ninite.exe'

$p = Start-Process -FilePath 'C:\Windows\Temp\ninite.exe' -PassThru
$p.WaitForExit()

Remove-Item 'C:\Users\Public\Desktop\*.lnk' -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\Desktop\*.lnk" -Force -ErrorAction SilentlyContinue