FROM mcr.microsoft.com/powershell:7.0.0-alpine-3.10
RUN pwsh -c "Install-Module UniversalDashboard.Community -Acceptlicense -Force"
RUN pwsh -c "Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/handrades/613c58b317374128b15a41e6aef6520f/raw/d30e4bb0625055cc221b3b4b5018f272ba4a1291/2-UD.ps1' -Method Get -OutFile /tmp/ud-example.ps1"
CMD [ "pwsh","-command","& ./tmp/ud-example.ps1" ]