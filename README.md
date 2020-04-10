# PreReqs

## System Requirements
---

* Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later).
* Hyper-V and Containers Windows features must be enabled.
* The following hardware prerequisites are required to successfully run Client Hyper-V on Windows 10:

  * 64 bit processor with Second Level Address Translation (SLAT)
  * 4GB system RAM
  * BIOS-level hardware virtualization support must be enabled in the BIOS settings. For more information, see Virtualization.


# Install Docker

You can install Docker in Windows using Chocolatey. Open a elevated PowerShell window and run the following code.

```Powershell
Try{
    choco
} catch {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
choco install docker-desktop -y
```

Once Docker is installed you can run your first hello world container from a PowerShell window. In this case you don't necessarily have to open an elevated window.

```PowerShell
docker run hello-world
```

# Images and Container Registries

I view it as the Microsoft Store, Google Play or the App Store. This is were you upload your custom docker images and they will be available from the internet.

By default you will be pulling images from the __Docker Hub__, but you can also pull them from other places such as __Azure Container Registry__, __Amazon EC2 Container Registry__, __Private registry__, etc.

