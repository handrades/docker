# PreReqs

## System Requirements for Windows
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

## Alpine VM
--

In Windows you can run Windows and Linux containers. The reason why you are also able to run Linux containers is because an Alpine Linux VM is created in Hyper-V automatically when you install Docker Desktop.

# Images

Docker images are like the OS ISO. The difference of this analogy is that the image will contain the OS, the app, its dependencies and everything that it requires to run your app. If you are coming from a VM world you can view it as your golden image. The thing with images is that they are read-only. Once you create one, you can delete it, but you can't modify it. If you need a new version you have to create an entirely new image.

## Container Registries
---

I view container registries as the Microsoft Store, Google Play or the App Store. This is were you upload your custom docker images and they will be available from the internet.

By default you will be pulling images from the __[Docker Hub](https://hub.docker.com)__, but you can also pull them from other places such as __[Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry)__, __[Amazon EC2 Container Registry](https://aws.amazon.com/ecr)__, __[Private Registry](https://docs.docker.com/registry)__ - very basic, __[Private Registry 2](https://jfrog.com/)__ - more robust, etc.

## Pull an Image
---

You can go into Docker Hub and find an image you are interested on. In this case I will be pulling a [MySQL](https://hub.docker.com/_/mysql) image. You can scroll down in their documentation and find several examples as to how to use their image. In this case I will just be pulling the image.

When we pull an image, we are running it on our machine, we are retrieving the image to be ready to go in our environment.

```PowerShell
docker pull mysql
```

Every time you pull a Linux image it will be saved into the Alpine Linux VM. So as you keep adding more and more images the VM will keep increasing in size.

## Image Versioning
---

Be default when you pull an image it will grab the latest version. Actually when you pull an image you are executing it as __docker pull mysql:latest__. The ":latest" specifies which version you want to pull. This is important because if you want to pull an older image that you know it works on your environment you could do something like __docker pull mysql:8.0.19__.

## Removing an Image
---

Once you are done with an image for example our hello world image, we can remove it. To do that we first need to see if there are no running containers from the hello world image, so let's verify.

```PowerShell
docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                         PORTS               NAMES
ea50bf78b6cb        hello-world         "/hello"            52 minutes ago      Exited (0) 52 minutes ago                          nifty_feynman
```

In my case I had one container running, so I need to remove it first as it is currently in a pause mode. To remove it we need to grab the first 4 characters from the container ID column. In my case the the first 4 characters were ea50.

```PowerShell
docker rm ea50
```

