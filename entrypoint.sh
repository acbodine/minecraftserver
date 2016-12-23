#/bin/sh

mkdir -p /root/minecraftserver

cd /root/minecraftserver

echo "eula=true" > eula.txt

java -Xmx1024M -Xms1024M -jar /opt/minecraft/minecraft_server.jar nogui
