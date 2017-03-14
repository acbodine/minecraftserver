# minecraftserver
Run the Minecraft server in a Docker container, anywhere!

<img
  alt="Minecraft Diamond Sword"
  width=200
  src="http://www.thinkgeek.com/images/products/frontsquare/inmt_minecraft_deluxe_diamond_sword.jpg"
/>
<img
  alt="Docker"
  width=200
  src="http://blog.cloudera.com/wp-content/uploads/2015/12/docker-logo.png"
/>
<img
  alt="IBM Bluemix"
  width=200
  src="https://ih1.redbubble.net/image.160886161.3072/flat,800x800,075,f.jpg"
/>

## Docker

#### Build
```
$ make
```

#### Run
```
$ make run
```
After this step completes, you will have a container called `minecraftserver` starting up at the default port `25565`. Simply point your Minecraft client at `localhost` and you should be all set.

NOTE: `boot2docker` or `docker-machine` users will need to replace `localhost` with whatever your docker machine ip is.

#### Cleanup
```
$ make clean
```

## IBM Container Service (ICS)
NOTE: This setup requires that you have the Bluemix CLI and the IBM Containers plugin installed and in your `PATH`. [CLI and dev tools](https://console.ng.bluemix.net/docs/cli/index.html#cli)

NOTE: This setup requires that you have a free public ip in your Bluemix space to allocate to the Minecraft server. Otherwise you won't be able to connect to the container running on ICS. You can check this by running:
```
$ bx ic ips
$ bx ic ip-request # Only if you need to get an ip, and haven't used up your quota
```

#### Build
```
$ make
```

#### Run
```
$ make run-bluemix
```
After this step completes, you will have a container called `minecraftserver` starting up at the default port `25565`. But this container isn't publicy availabe for your Minecraft client to connect to yet. First get your new container's ID:
```
$ container_id=$(bx ic ps | grep minecraftserver | awk '{print $1}')
```
Then you simply bind a free ip that you have to your container (replace `$public_ip` with whatever you have availabe):
```
$ bx ic ip-bind $public_ip $container_id
```
Now you can point your Minecraft client to the `$public_ip` and you should be mining in no time, from anywhere!

#### Cleanup
```
$ make cleanup-bluemix
```

#### Upgrade
##### 1) IMPORTANT: Before doing the steps below, please make a backup of your existing server data. If this is the first time you have done this upgrade, then you will need to do steps 1-3. Otherwise, you only need to do step 2.
```
$ bx ic exec -it minecraftserver bash
$ tar -czf minecraftserver-backup.tgz \
    banned-ips.json \
    banned-players.json \
    eula.txt \
    ops.json \
    server.properties \
    usercache.json \
    whitelist.json \
    world
$ exit
$ bx ic cp minecraftserver:/minecraftserver-backup.tgz .
```

##### 2) As Minecraft server versions are released this repo's `Dockerfile` will be updated to reflect that. Simply make sure you are up-to-date with `master` branch, and then re-run the container on Bluemix.
```
$ git checkout master
$ git pull origin master
$ make run-bluemix
```

##### 3) This step is only necessary because I switched the container creation on Bluemix to include a volume to make upgrades easier and worry free. You need to do this with the server backup you made only once, after that all of your data is safe in a volume and you are free to do anything you want to your container. Just don't touch the volume `minecraftserver-data`
```
$ bx ic cp minecraftserver-backup.tgz minecraftserver:/root/
$ bx ic exec -it minecraftserver bash
$ cd /root/minecraftserver
$ tar -xzf ../minecraftserver-backup.tgz
$ exit
$ bx ic restart minecraftserver
```
