FROM mcr.microsoft.com/powershell:7.0.0-alpine-3.10
RUN pwsh -c "Install-Module universaldashboard -Acceptlicense -Force"
RUN pwsh -c "Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/handrades/9d1a14e6baf0bc477812d36b766cbf4d/raw/6cc719b5e97ea68c473c72ed9a6d143ff4fc30a2/UD-Basic-test.ps1' -Method Get -OutFile /tmp/ud-example.ps1"
CMD [ "pwsh","-command","& ./tmp/ud-example.ps1" ]