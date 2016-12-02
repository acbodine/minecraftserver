FROM ubuntu:16.04

# Args
ARG v=1.11

# Install Java
RUN apt-get autoclean
RUN apt-get clean
RUN apt-get update
RUN apt-get install -y \
    curl \
    default-jre
RUN apt-get clean

# Install Minecraft server
RUN curl -LO# https://s3.amazonaws.com/Minecraft.Download/versions/${v}/minecraft_server.${v}.jar
RUN ln -s minecraft_server.${v}.jar minecraft_server.jar
RUN echo "eula=true" > eula.txt

# NOTE: Copy any existing server data
COPY . .

EXPOSE 25565

ENTRYPOINT ["java"]
CMD ["-Xmx1024M", "-Xms1024M", "-jar", "minecraft_server.jar", "nogui"]
