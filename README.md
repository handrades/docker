# Docker

Currently containers are targeted towards developers. It is mainly a platform for developing, shipping and running applications.

As of today (April 2020) in my personal opinion I don't think that containers are a VM replacements. There are still some things you can't do in a container that a VM can do like for example joining a container to a domain. Not that this is relevant to an application that is disposable but to some enterprises this is very important because of their policies. Nevertheless, VMs and Containers are two different technologies and I don't think we can compare them apples to apples. Over time I do think that containers will gain more traction in the Windows environment and more features will be added to Windows OS to be more suited for containers. Eventually VMs might be replaced by containers, who knows.

## VMs and Containers

Even though they are not the same if you come from a VM background they might have some similarities that might help you grasp the container lingo easier. So let's talk about some similarities between them.

VMs | Containers
--- | ---
Golden OS Image | Image
VM | Container
Hypervisor | Huh?

Just like VMs, containers depend on physical resources like RAM, Processor, Network and Storage. So they both depend on a physical machine that provides the resources. You can run containers in Mac, Linux and Windows. In this article I will be talking about how to setup Docker in a Windows environment.

Now the new Microsoft, to be more specific Satya era. They are making some crazy things and they are moving crazy fast. This new Microsoft is really thinking about the customer and not themselves. But enough said, my point is that since this new Microsoft is moving so fast, so is their technology. Because of this I am sure some of the following information might not be relevant in a few months from now.

Often people used to tell me that Medical Doctors was a hard profession because they always had to stay up to date by going to conferences and keep taking new classes to be up to date. This is why I was not interested in it. Well, I made a really bad decision on IT, because they are worst. Technology evolves so much faster that it is hard to keep up with it, but at the same time you will never get bored.

Enough said so let's jump into the good stuff.

## PreReqs

### System Requirements for Windows

* Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later).
* Hyper-V and Containers Windows features must be enabled.
* The following hardware prerequisites are required to successfully run Client Hyper-V on Windows 10:

  * 64 bit processor with Second Level Address Translation (SLAT)
  * 4GB system RAM
  * BIOS-level hardware virtualization support must be enabled in the BIOS settings. For more information, see Virtualization.

## Install Docker

The easiest way to install Docker Desktop in Windows is using Chocolatey. Open a elevated PowerShell window and run the following code.

```Powershell
Try{
    choco
} catch {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
choco install docker-desktop -y
```

That's it! it's installed.

Once Docker is installed you can run your first hello world container from a PowerShell window. In this case you don't necessarily have to open an elevated window.

```PowerShell
docker run hello-world
```

### Alpine VM

In Windows you can run Windows and Linux containers. The reason why you are also able to run Linux containers is because an Alpine Linux VM is created in Hyper-V automatically when you install Docker Desktop.

## VM to Containers

Before we begin we need to understand some container lingo. As I mentioned earlier, containers and VMs are not the same. If you come from a VM background

## Images

Docker images are like the OS ISO. The difference of this analogy is that the image will contain the OS, the app, its dependencies and everything that it requires to run your app. If you are coming from a VM world you can view it as your golden image. The thing with images is that they are read-only. Once you create one, you can delete it, but you can't modify it. If you need a new version you have to create an entirely new image.

### Container Registries

I view container registries as the Microsoft Store, Google Play or the App Store. This is were you upload your custom docker images and they will be available from the internet.

By default you will be pulling images from the __[Docker Hub](https://hub.docker.com)__, but you can also pull them from other places such as __[Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry)__, __[Amazon EC2 Container Registry](https://aws.amazon.com/ecr)__, __[Private Registry](https://docs.docker.com/registry)__ - very basic, __[Private Registry 2](https://jfrog.com/)__ - more robust, etc.

### Pull an Image

You can go into Docker Hub and find an image you are interested on. In this case I will be pulling a [MySQL](https://hub.docker.com/_/mysql) image. You can scroll down in their documentation and find several examples as to how to use their image. In this case I will just be pulling the image.

When we pull an image, we are retrieving the container image (Golden OS Image in VM terms) to be ready to go in our environment.

```PowerShell
docker pull mysql
```

Every time you pull a Linux image it will be saved into the Alpine Linux VM. So as you keep adding more and more images the VM will keep increasing in size.

### Image Versioning

Be default when you pull an image it will grab the latest version. Actually when you pull an image you are executing it as __docker pull mysql:latest__. The ":latest" specifies which version you want to pull. This is important because if you want to pull an older image that you know it works on your environment you could do something like __docker pull mysql:8.0.19__.

### Removing an Image

Once you are done with an image for example our hello world image, we can remove it. To do that we first need to see if there are not running containers (Virtual Machines in VM terms) from our hello world image, so let's verify.

```PowerShell
docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                         PORTS               NAMES
ea50bf78b6cb        hello-world         "/hello"            52 minutes ago      Exited (0) 52 minutes ago                          nifty_feynman
```

In my case I had one container in an _exited_ (Shut Down in VM terms) status, so I need to delete it first. To delete it, we need to grab the first 4 characters from the container ID column. In my case the the first 4 characters were ea50.

```PowerShell
docker rm ea50
```

Now that the container (Virtual Machine in VM terms) is deleted we can delete the image (Golden OS Image in VM terms) too. First let list all the images available.

```PowerShell
docker images ls

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql               latest              9228ee8bac7a        10 days ago         547MB
hello-world         latest              fce289e99eb9        10 days ago       1.84kB
```

For some reason the Created column always gets jacked up in my personal experience, but that's fine. I just need to grab the Image ID for my hello-world container and delete it.

```PowerShell
docker rmi fce2

Untagged: hello-world:latest
Untagged: hello-world@sha256:f9dfddf63636d84ef479d645ab5885156ae030f611a56f3a7ac7f2fdd86d7e4e
Deleted: sha256:fce289e99eb9bca977dae136fbe2a82b6b7d4c372474c9235adc1741675f587e
Deleted: sha256:af0b15c8625bb1938f1d7b17081031f649fd14e6b233688eea3c5483994a66a3
```

You should get a similar output, letting you know that the image has been removed. So next time you __docker image ls__ you should now get only one image available.

```PowerShell
docker images ls

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql               latest              9228ee8bac7a        10 days ago         547MB
```

Now this is a tru uninstall, that you will never get from uninstalling an application from a local machine.

### Prune Junk

As we start working more with Docker, we will be pulling more and more images and running a lot of containers. So we will be start getting more temp images and will will start adding up and consuming resources. SO we would want to prune all that.

```PowerShell
docker system prune
```

## 