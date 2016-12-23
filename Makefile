name = minecraftserver
port = 25565

all: build

# clean removes the minecraftserver container from the
# local Docker daemon
clean:
	# Don't let make fail if the container doesn't exist
	docker rm -fv minecraftserver || true

# build creates the minecraftserver image with the local
# Docker daemon
build: clean
	docker build -t $(name) --force-rm .

# run runs a new minecraftserver container on the local
# Docker daemon
run: build
	docker run --name $(name) -d -p $(port):$(port) $(name)

# clean-bluemix removes the minecraftserver container
# from Bluemix container service
clean-bluemix:
	bx ic rm -f minecraftserver
	# NOTE: Don't delete the volume here

# push-bluemix tags and pushes the minecraftserver image
# to the Bluemix container registry
push-bluemix: build
	docker tag $(name) registry.ng.bluemix.net/$(shell bx ic namespace get)/$(name)
	docker push registry.ng.bluemix.net/$(shell bx ic namespace get)/$(name)

# run-bluemix runs a new minecraftserver container on the Bluemix
# container service, and then follows the logs
run-bluemix: push-bluemix clean-bluemix
	# Create volume if it doesn't exist
	bx ic volume-create $(name)-data || true
	bx ic run --name $(name) -d -p $(port):$(port) -v $(name)-data:/root/$(name) registry.ng.bluemix.net/$(shell bx ic namespace get)/$(name)
	@echo "Waiting 30 seconds for the container to start ..."
	sleep 30
	@echo "Trying to follow the container logs for minecraftserver. If this fails, your container is just a bit slow to come up.. keep waiting"
	bx ic logs -f $(name)
	@echo "Remember, you still need to bind a public ip to the container in order to play Minecraft. See README."
