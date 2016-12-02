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
  src="https://pbs.twimg.com/profile_images/378800000124779041/fbbb494a7eef5f9278c6967b6072ca3e_400x400.png"
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

## Migrate (Local or Bluemix)
If you have an existing server you want to preserve game data from,
simply copy those artifacts to the root of this repo before you start
building the Docker image.

HINT: if you are wondering what files you need look at the `.gitignore`
