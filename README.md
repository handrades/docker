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

Now with the new Microsoft, to be more specific Satya era. They are making some crazy things and they are moving crazy fast. This new Microsoft is really thinking about the customer and not themselves. But enough said, my point is that since this new Microsoft is moving so fast, so is their technology. Because of this I am sure some of the following information might not be relevant in a few months from now.

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

The output should look something like this:

```PowerShell
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:f9dfddf63636d84ef479d645ab5885156ae030f611a56f3a7ac7f2fdd86d7e4e
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

You just ran your first container! Attaboy, you are doing great job!

Let's now check which docker version we are running on.

```PowerShell
docker version
```

To retrieve more docker information more like a type of dashboard information you would have the retrieve system information. This will show you for example your container status, like stopped, running and paused state.Along with a little more information.

```PowerShell
docker system info
```

### Alpine VM

In Windows you can run Windows and Linux containers. The reason why you are also able to run Linux containers is because an Alpine Linux VM is created in Hyper-V automatically when you install Docker Desktop.

## Images

Docker images are like the OS ISO. The difference of this analogy is that the image will contain the OS, the app, its dependencies and everything that it requires to run your app. If you are coming from a VM world you can view it as your golden image. The thing with images is that they are read-only. Once you create one, you can delete it, but you can't modify it. If you need a new version you have to create an entirely new image.

### Container Registries

I view container registries as the Microsoft Store, Google Play or the App Store. This is were you upload your custom docker images and they will be available from the internet.

By default you will be pulling images from the __[Docker Hub](https://hub.docker.com)__, but you can also pull them from other places such as __[Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry)__, __[Amazon EC2 Container Registry](https://aws.amazon.com/ecr)__, __[Private Registry](https://docs.docker.com/registry)__ - very basic, __[Private Registry 2](https://jfrog.com/)__ - more robust, etc.

### Pull an Image

You can go into Docker Hub and find an image you are interested on. In this case I will be pulling a [PowerShell](https://hub.docker.com/_/microsoft-powershell) image. You can scroll down in their documentation and find several examples as to how to use their image. In this case I will just be pulling the image.

When we pull an image, we are retrieving the container image (Golden OS Image in VM terms) to be ready to go in our environment.

```PowerShell
docker pull mcr.microsoft.com/powershell:7.0.0-alpine-3.10
```

Every time you pull a Linux image it will be saved into the Alpine Linux VM. So as you keep adding more and more images the docker VM will keep increasing in size.

### Image Versioning

Be default when you pull an image it will grab the latest version. Actually when you pull an image you are executing it as __docker pull mcr.microsoft.com/powershell:latest__. The ":latest" specifies which version you want to pull. This is important because if you want to pull an older image that you know it works on your environment you could do something like __docker pull mcr.microsoft.com/powershell:7.0.0-alpine-3.10__.

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

REPOSITORY                     TAG                       IMAGE ID            CREATED             SIZE
mcr.microsoft.com/powershell   7.0.0-alpine-3.10         233aeb43c1f9        2 weeks ago         176MB
hello-world                    latest                    fce289e99eb9        10 days ago        1.84kB
```

I just need to grab the Image ID for my hello-world container and delete it. So I will just grab the first 4 characters.

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

REPOSITORY                     TAG                       IMAGE ID            CREATED             SIZE
mcr.microsoft.com/powershell   7.0.0-alpine-3.10         233aeb43c1f9        2 weeks ago         176MB
```

Now this is a true uninstall, that you will never get from uninstalling an application from a local machine.

### Prune Junk

As we start working more with Docker, we will be pulling more and more images and running a lot of containers. So we will be start getting more temp images and will will start adding up and consuming resources. SO we would want to prune all that.

```PowerShell
docker system prune
```

## DockerFile

So far we have talked about somebody elses image, but most likely we want to create our own. So with dockerfile we will be able to modify an image and create our own version. In a nutshell we have the following instructions:

* From
  * This is were you reference a base image to start with.
* Label
  * Metadata, this is where you could add the author.
* Run
  * This is where you run custom command like install from APT a package, starting a service, Run a script, etc.
* Copy
  * This will help you only copy things into the image.
* WorkDir
  * Is an alias to the docker container working directory you want to reference to.
* Expose
  * This is used for ports. This is the external port that will expose in the internal container.
* Env
  * Environmental variables to run your apps.
* CMD
  * Runs commands contained in your image along with arguments.

If you would like to learn more about docker images you can reference [this](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) link, but I will add some basic examples in the dockerfile folder.

### Building a Custom Image

I created a custom image and dumped it in the dockerfile folder. It's called 1-UD.dockerfile. So let's build it.

```PowerShell
docker build -t andradehector/ud:0.1 --file dockerfile\1-UD.dockerfile .
```

* docker build
  * Tells docker to build the image
* -t
  * Adds a tag name to the image you are building
  * In my case I tagged it as andradehector/ud:0.1. Where andradehector is my Docker Hub username. ud:0.1 is the name I want to give it along with the version.
* --file
  * By default if you name your docker file __dockerfile__ you don't need this parameter.
  * In my case since I named it something else and also saved it in a folder I have to specify the whole path to the file.
* .
  * The build context.

### Update an Image

You cannot update an image you re-tag it.

```PowerShell
docker build -t andradehector/ud:0.2 --file dockerfile\1-UD.dockerfile .
```

So now that you updated the image content you should now have two images. In this case version 0.1 and 0.2. The nice thing about containers is that even though you have two versions. For the second version it will only add the difference from version 0.1. So if you are familiar with Git, it would be the same concept for version controlling. You are not duplicating data from version 0.1, as it is used to build 0.2. This is very powerful!

### Tag Image

In case you forget to tag you image by default it will be tagged as latest. If you want to tag it something else like 0.3 you can run the following against the latest image.

```PowerShell
docker tag andradehector/ud:latest andradehector/ud:0.3
```

## Containers

```PowerShell
docker version
docker system info
docker images
docker ps
docker ps -a
#interactive container
#use the andradehector/ud:0.2 image
#run powershell with pwsh
docker run -it andradehector/ud:0.2 pwsh
get-process
exit
docker ps
docker ps -a
docker start c323
docker exec -it c323 pwsh
#exit container but not stopping container
control + P + Q
docker ps
docker stop c323
docker rm c323

# -d run a container in detach mode, in other words in the background
# -p map host port 3000 to container port 80
# --name container name
# image name
docker run -d -p 3000:80 --name UD andradehector/ud:0.2

#inspect is like right clicking on container
docker inspect c323


```

## Remote Hosts

You can run containers locally you have to

```PowerShell
docker run --name web1 UD:latest
```

asds

```PowerShell
docker run --name web1 --hostname myDockerServer UD:latest
```
