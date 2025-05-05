# https://docs.docker.com/engine/install/debian/
# https://depot.dev/blog/docker-clear-cache

# free space
docker system prune -a

# stop all containers
docker stop $(docker ps -a -q)

# Removing all containers
docker container prune

# remove all containers
docker rm $(docker ps -a -q)

# remove all unused images to free disk
docker image prune -a -f

# remove the rest containers if have
docker compose down
