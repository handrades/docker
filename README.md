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

Let's now check which docker version we are running on, from a PowerShell window. By the way, I will be executing all the docker commands from a non elevated PowerShell window.

```PowerShell
docker version
```

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

You just ran your first container. Attaboy!

To retrieve more docker information more like a type of dashboard information you would have the retrieve the system information. This will show you for example your container status, like stopped, running and paused state. Along with a little more information.

```PowerShell
docker system info
```

Finally, let's clean up our work, by removing the container and the image. Since we will not be needing them any more. I will not go into detail about the following code as we will be go more in detail later on.

```PowerShell
docker rm $(docker ps -aq) -f
docker rmi hello-world
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

Once you are done with an image, we can remove it. First let's list all the images available.

```PowerShell
docker images

REPOSITORY                     TAG                       IMAGE ID            CREATED             SIZE
mcr.microsoft.com/powershell   7.0.0-alpine-3.10         233aeb43c1f9        2 weeks ago         176MB
```

You just need to grab the Image ID, __233aeb43c1f9__ in my case. In this case since I just have one image I could execute one of the following commands.

```PowerShell
docker rmi 2
docker rmi 23
docker rmi 233
docker rmi 233a
```

The output should look something like:

```PowerShell
Untagged: hello-world:latest
Untagged: hello-world@sha256:f9dfddf63636d84ef479d645ab5885156ae030f611a56f3a7ac7f2fdd86d7e4e
Deleted: sha256:fce289e99eb9bca977dae136fbe2a82b6b7d4c372474c9235adc1741675f587e
Deleted: sha256:af0b15c8625bb1938f1d7b17081031f649fd14e6b233688eea3c5483994a66a3
```

The reason why we are able to execute one of the 4 commands above is because we just have on image in our environment. If we were to have more images we would have to add more characters to the __container ID__ value. A lot of people usually just add the first 4 characters, in most cases this is enough. But note that depending on your environment you might need to add more.

So next time you __docker images__ you should not get any images back.

```PowerShell
docker images

REPOSITORY                     TAG                       IMAGE ID            CREATED             SIZE
```

Now this is a true uninstall, that you will never get from uninstalling an application from a local machine.

### DockerFile

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
docker build -t pwsh-ud --file dockerfile\1-UD.dockerfile .
```

* docker build
  * Tells docker to build the image
* -t
  * Adds a tag name to the image you are building
  * In my case I tagged it as __pwsh-ud__.
* --file
  * By default if you name your docker file __dockerfile__ you don't need this parameter.
  * In my case since I named it something else and also saved it in a folder I have to specify the whole path to the file.
* .
  * The build context.

### Update an Image

So let's say you updated your PowerShell dashboard and you now want to update it. You cannot update an image you re-tag it. So we just add a second version of the application.

```PowerShell
docker build -t pwsh-ud:0.2 --file dockerfile\2-UD.dockerfile .
```

So now that you updated the image content you should now have two images. The problem now is that since we did not added a version to our first image it was configured as latest. Which is not correct now.

### Tag Image

So we now need to tag the image. So let's tag the latest image to be version 0.1.

```PowerShell
docker tag pwsh-ud:latest pwsh-ud:0.1
```

If we run __docker images__ we should now see that we have three pwsh-ud images. Versions 0.1, 0.2 and latest.

```PowerShell
docker images

REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
pwsh-ud                        0.2                 ee20ad29f23d        3 minutes ago       241MB
pwsh-ud                        0.1                 bce45f0f4f26        4 minutes ago       241MB
pwsh-ud                        latest              bce45f0f4f26        4 minutes ago       241MB
```

If you look closely the image ID is repeated twice vor version 0.1 and latest. This means that there is some sort of pointer and that the storage is not affected by creating multiple tags from the same version.

So, let's now make the latest point to version 0.2.

```PowerShell
docker tag pwsh-ud:0.2 pwsh-ud:latest
```

So now when we list the images again we see that the latest is now pointing to version 0.2 by looking at the image ID.

```PowerShell
docker images

REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
pwsh-ud                        0.2                 ee20ad29f23d        7 minutes ago       241MB
pwsh-ud                        latest              ee20ad29f23d        7 minutes ago       241MB
pwsh-ud                        0.1                 bce45f0f4f26        8 minutes ago       241MB
```

The nice thing about containers is that even though we now have two Web Application versions. For the second version it will only add the difference from version 0.1. So if you are familiar with Git, it would be the same concept for version controlling. You are not duplicating data from version 0.1, as it is used to build 0.2. This is very powerful!

### Recap

```PowerShell
#Get docker version
docker version
#Start your first container, it will pull image and run it afterwards
docker run hello-world
#Get what I call Docker dashboard info
docker system info
#Download a Golden Image (speaking in VM terms)
docker pull mcr.microsoft.com/powershell:7.0.0-alpine-3.10
#List docker images
docker images
#Delete docker image by ID
docker rmi [Image ID]
#Build a custom docker image
docker build -t pwsh-ud --file dockerfile\1-UD.dockerfile .
#Increase version to a container (update docker file)
docker build -t pwsh-ud:0.2 --file dockerfile\2-UD.dockerfile .
#Tag a docker image
docker tag pwsh-ud:latest pwsh-ud:0.1
docker tag pwsh-ud:0.2 pwsh-ud:latest
```

## Containers

### Run Container Interactively

Well, we already have a few images laying around. So, let's run our first docker container.

```PowerShell
docker run -it pwsh-ud pwsh
```

* Docker run
  * Pulls the image from the container registry if it's not pulled already.
  * Starts the container
* -it
  * Runs the container in an interactive mode.
* pwsh-ud
  * Is the image you want to run. In this case I didn't specified the version so it will grab the latest version.
* pwsh
  * Is the command you want to run interactively. In this was we will be running PowerShell.

So you should now be in the container. You prompt should of changed to something like __PS />__. If you execute something like __hostname__ you should get the container's name.

```PowerShell
hostname
```

Ok, let's exit this container by executing __exit__.

```Powershell
exit
```

### List Containers

We should now have our prompt back. So let's see what is our container's status. Let's list it.

```PowerShell
docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
6d076d996560        pwsh-ud             "pwsh"              11 minutes ago      Exited (0) 4 minutes ago                       nostalgic_sutherland
```


### Start Container

So right now we can see after we __exit__ the container from the interactive PowerShell prompt the container was changed to a stopped status. Every time you see __Exited (#)__ in the status column it means that the container is stopped. So we now need to start it up.

```PowerShell
docker start 6d07
```

### Exec Container

To go back to the container's PowerShell prompt, we need to execute __docker exec__ in an interactive mode.

```PowerShell
docker exec -it 6d07 pwsh
```

* Docker exec
  * Runs commands against the specified container
* -it
  * Runs the container in an interactive mode.
* 6d07
  * In my case this is the Container ID I want to connect to.
* pwsh
  * This is the command I want to execute. In my case I want to connect to a PowerShell prompt.

So, what if I don't want to stop the container again but I want to exit it. You can type a few hotkeys to exit the container but don't stop it. they are the following:

```PowerShell
Ctrl + P + Q
```

### Stop Container

Even though the container is now running, we didn't set it up a port to listen for incoming Web Requests. So let's stop the container.

```PowerShell
docker stop 6d07
```

### Delete Container

Before we start up a new container let's delete the current container as we no longer have a use for it.

```PowerShell
docker rm 6d07
```

### Run Container

Now that our environment is clean, we can now start a new container to accept Web Requests.

```PowerShell
docker run -d -p 1002:80 --name UD02 pwsh-ud:0.2
```

* Docker run
  * Pulls the image from the container registry if it's not pulled already.
  * Starts the container
* -d
  * Runs the container in the background, in a detach mode.
* -p
  * 1002 is the port we will be connecting to
  * 80 is the container local port. I defined this port in my GitHub Gist that contains the PowerShell script.
* --name
  * you can name your container. In this case I named it UD.
* pwsh-ud:0.2
  * Is the image you want to run. In this case I specified that I want the 0.2 version.

Now that we have a container running let's connect to it from the web browser. Let's use PowerShell to open it from our default web browser.

```PowerShell
Start-Process http://localhost:1002
```

### Run Multiple Versions

In this case we have two container's versions. Version 0.1 and 0.2. Let's run them side by side.

```PowerShell
docker run -d -p 1001:80 --name UD01 pwsh-ud:0.1
```

Now let's open it from a web browser.

```PowerShell
Start-Process http://localhost:1001
```

You should now be able to compare the two versions we create it. Can you spot the differences?

This is very handy for troubleshooting purposes. You are now able to spin your applications no matter the version almost with a snap of your fingers.

### Inspect Container

In the VM world we are used to go to our hypervisor and finding our VM and looking into the VM properties. Well, inspecting the container could be the equivalent to this. So let's inspect one of the containers. First like always we need to retrieve the Container ID.

```PowerShell
docker ps

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
422d8e67a446        pwsh-ud:0.1         "pwsh -command '& ./…"   3 minutes ago       Up 3 minutes        0.0.0.0:1001->80/tcp   UD01
cf65a56f4e65        pwsh-ud:0.2         "pwsh -command '& ./…"   3 minutes ago       Up 3 minutes        0.0.0.0:1002->80/tcp   UD02
```

In my case I will grab Container ID 422d.

```PowerShell
docker inspect 422d
```

This should return a json string. If you like this view you can start scroll up and look for interesting values. Like the network settings or the commands running on the container. Since I prefer PowerShell, I am going to convert the json string to a .net object and go from there.

```PowerShell
$UD01 = docker inspect 422d | ConvertFrom-Json
$UD01
```

O yeah, a little more readable. So we now should be able to get the commands running in the container.

```PowerShell
$UD01.path
$UD01.args
```

So this is telling us that the path is using __pwsh__ and the arguments are __-command__ followed by __& ./tmp/ud-example.ps1__.

So now lets retrieve the Network settings.

```PowerShell
$UD01.NetworkSettings
```

At least for me since I am more used to PowerShell it is more readable. But since the output is json you can use another tools to visualize the data better.

### Cleanup in bulk

We currently have two containers running as we saw earlier. We now know that we either need the Container ID or the container name to execute a command to a container. The easiest way to retrieve the Container ID is by listing the containers in __quiet__ mode.

```PowerShell
docker ps -q

422d8e67a446
cf65a56f4e65
```

We already know how to delete a single container. Which is by using __docker rm [Container ID] -f even if it's running. Well since we just learned how to retrieve all the Container's IDs we can just append it to the remove command.

```PowerShell
docker rm $(docker ps -q) -f
```

If we re-run the list container command we should now get nothing back.

```PowerShell
docker ps -q
```

We can take the same approach for images too. So first let's retrieve all of our images IDs.

```PowerShell
docker images -q
```

Now let's remove all of our images.

```PowerShell
docker rmi $(docker images -q) -f
```

### Recreate Environment

And that's it, we just cleaned up out whole environment. But just like we clean it up we should be able to get the same environment up and running in less than a minute by executing the following commands:

```PowerShell
docker build -t pwsh-ud --file dockerfile\2-UD.dockerfile .
docker run -d -p 1000:80 pwsh-ud
Start-Process http://localhost:1000
```

This is the power of Docker, you can build and destroy environments a couple of minutes. This is why it is very powerful.

## Remote Hosts

You can run containers remotely too, by pointing to a docker server.

```PowerShell
docker run --name UD03 --hostname myDockerServer pwsh-ud
```

### Prune Junk

As we start working more with Docker, we will be pulling more and more images and running a lot of containers. So we will be start getting more temp images and will will start adding up and consuming resources. So we would want to prune all that.

```PowerShell
docker system prune
```

In our environment this is worthless because we just deleted everything. But it is good to know that there is a command that will delete everything that is unused.

### TroubleShooting

Eventually you will run into problems when working with containers and you will need to troubleshoot it. Some useful commands are __inspect__ which we already talked about, __top__ which will show you the processes runing inside the container and finally __logs__ which will display the output the commands you have executed have thrown.

```PowerShell
docker inspect 422d
docker top 422d
docker logs 422d
```

### Recap

```PowerShell
# Run container interactively
docker run -it pwsh-ud pwsh
hostname
exit
#List all the containers on our machine
docker ps -a
#Start a container
docker start [Name | Container ID]
#Connect interactively to a container and run PowerShell
docker exec -it [Name | Container ID] pwsh
# Exit container without stopping container
Ctrl + P + Q
#Stop a container
docker stop [Name | Container ID]
#Delete a container
docker rm [Name | Container ID]
# Run a container and map the external and internal ports
docker run -d -p 1002:80 --name UD02 pwsh-ud:0.2
# Open a web Browser that points to the recently created WebSite
Start-Process http://localhost:1002
# Open a second WebSite instance but using an older version
docker run -d -p 1001:80 --name UD01 pwsh-ud:0.1
# Open a web Browser that points to the recently created WebSite
Start-Process http://localhost:1001
# List just running containers
docker ps
# Look at the container's properties
docker inspect [Name | Container ID]
# Use PowerShell to retrieve the container's properties
$UD01 = docker inspect [Name | Container ID] | ConvertFrom-Json
$UD01
$UD01.path
$UD01.args
$UD01.NetworkSettings
# Get just the containers ID
docker ps -q
# Delete all the running containers
docker rm $(docker ps -q) -f
# Verify that they are now gone
docker ps -q
# Get just the images ID
docker images -q
# Delete all the images
docker rmi $(docker images -q) -f
# Recreate the lab again
docker build -t pwsh-ud --file dockerfile\2-UD.dockerfile .
docker run -d -p 1000:80 pwsh-ud
Start-Process http://localhost:1000
# run a container in a docker server
docker run --name UD03 --hostname myDockerServer pwsh-ud
# Prune Junk
docker system prune
#Troubleshooting
docker inspect [Name | Container ID]
docker top [Name | Container ID]
docker logs [Name | Container ID]
```
