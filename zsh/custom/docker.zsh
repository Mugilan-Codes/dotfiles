# TODO: add more
# REF: https://medium.com/hackernoon/handy-docker-aliases-4bd85089a3b8

# TODO: add explanation
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcudb="docker-compose up -d --build"
alias dcd="docker-compose down"
alias dcdv="docker-compose down -v"
alias dl="docker logs"
alias dlf="docker logs -f"

# REF: https://www.reddit.com/r/docker/comments/l5l2f4/simplifying_the_docker_command_line/gkx68rv?utm_source=share&utm_medium=web2x&context=3
alias dps='docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}"'
# To get all container names and their IP addresses in just one single command.
dip() {
  docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq) | while read container; do echo $container | cut -c2-; done
}

# Open & Run Docker Desktop
alias d_open="open -a Docker"

# See all space Docker takes up
alias d_space="docker system df"

# Delete all containers
alias d_con_purge="docker container prune"

# Delete all untagged images
alias d_img_purge="docker image prune"

# Kill all running containers
alias d_kill="docker kill $(docker ps -q)"

# REF: https://stackoverflow.com/a/20686101/12381908
# Get IP address of running container
# alias d_ip="docker inspect [CONTAINER ID] | grep -wm1 IPAddress | cut -d '"' -f 4"
d_ip() {
  if [ -n "$1" ]
  then
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
  else
    echo "need to add <container_id>/<container_name>" >&2
    echo "==> d_ip [container_id_or_name]"
  fi
}

# REF: https://www.reddit.com/r/docker/comments/77ly8o/what_are_your_favorite_docker_related_aliases_and/domy74x?utm_source=share&utm_medium=web2x&context=3
# This prints the last log line of each running container on a system. I use it in a compute cluster to show a quick status of each container
lastlogline () {
  docker ps -q | xargs -I'{}' sh -c 'docker inspect {} -f "  -- {{.Name}}" && docker logs --tail 1 {}'
}