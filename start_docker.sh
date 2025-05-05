
# remove the rest containers if have
docker compose down

# build images
docker compose build --no-cache

# start up containers from all images
docker compose up

# Get a list of all the listening TCP and UDP ports 
netstat -lntu
