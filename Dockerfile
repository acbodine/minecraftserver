FROM ubuntu:16.04

# Args
ARG v=1.11.2

# Install Java
RUN apt-get autoclean
RUN apt-get clean
RUN apt-get update
RUN apt-get install -y \
    curl \
    default-jre
RUN apt-get clean

# Install Minecraft server
WORKDIR /opt/minecraft
RUN cd /opt/minecraft
RUN curl -LO# https://s3.amazonaws.com/Minecraft.Download/versions/${v}/minecraft_server.${v}.jar
RUN ln -s minecraft_server.${v}.jar minecraft_server.jar

EXPOSE 25565

COPY entrypoint.sh .

ENTRYPOINT ["sh", "entrypoint.sh"]
