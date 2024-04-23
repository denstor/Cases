Example of creating FastAPI in a Docker container for a text-to-text Hugface ML model (https://huggingface.co/google/flan-t5-small).

STEPS:

1/ create files: requirements.txt, app.py, Dockerfile

2/ run virtual environment in terminal:
python3 -m venv venv
source venv/bin/activate

3/ pip install -r requirements.txt

4/ docker build -t myimage .

5/ docker run -d --name mycontainer -p 80:80 myimage

6/ run http link in explorer to generate text



FastAPI in Containers - Docker
When deploying FastAPI applications a common approach is to build a Linux container image. It's normally done using Docker. You can then deploy that container image in one of a few possible ways.

What is a Container
Containers (mainly Linux containers) are a very lightweight way to package applications including all their dependencies and necessary files while keeping them isolated from other containers (other applications or components) in the same system.

Linux containers run using the same Linux kernel of the host (machine, virtual machine, cloud server, etc). This just means that they are very lightweight (compared to full virtual machines emulating an entire operating system).

This way, containers consume little resources, an amount comparable to running the processes directly (a virtual machine would consume much more).

Containers also have their own isolated running processes (commonly just one process), file system, and network, simplifying deployment, security, development, etc.

What is a Container Image
A container is run from a container image.

A container image is a static version of all the files, environment variables, and the default command/program that should be present in a container. Static here means that the container image is not running, it's not being executed, it's only the packaged files and metadata.

In contrast to a "container image" that is the stored static contents, a "container" normally refers to the running instance, the thing that is being executed.

Containers and Processes
A container image normally includes in its metadata the default program or command that should be run when the container is started and the parameters to be passed to that program. Very similar to what would be if it was in the command line.

When a container is started, it will run that command/program (although you can override it and make it run a different command/program).

A container is running as long as the main process (command or program) is running.

https://fastapi.tiangolo.com/deployment/docker/