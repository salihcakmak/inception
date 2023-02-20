#This makefile about inception project.
CONTAINERS	= $(shell docker ps -a)
IMAGES		= $(shell docker images -a)
VOLUMES		= $(shell docker volume ls -q)
NETWORKS	= $(shell docker network ls -q)

#This rule is set new hostname for localhost ip
hostname		:
				@ echo "127.0.0.1 scakmak.42.fr" >> /etc/hosts

#This rule if does not exist create volume folders
volume_dir		:
				@ mkdir -p /home/scakmak/data/wordpress
				@ mkdir -p /home/scakmak/data/mariadb

# -f, --file FILE Specify an alternate compose file (default values is docker-compose.yml)
up				: volume_dir
				@ docker compose -f srcs/docker-compose.yml up --build

down			:
				@ docker compose -f srcs/docker-compose.yml down

rm_containers	: down
				@ docker stop $(CONTAINERS)
				@ docker rm $(CONTAINERS)

rm_images		:
				@ docker rmi -f $(IMAGES)

rm_volumes		:
				@ docker volume rm $(VOLUMES)

rm_networks		:
				@ docker network rm $(NETWORKS) 2> /dev/null; true;

prune			:
				@ docker system prune -a --volume 2> /dev/null;
				@ docker system prune -a --force 2> /dev/null;

clean			: rm_containers rm_images rm_networks rm_networks prune
				@ rm -rf /home/scakmak/data/wordpress
				@ rm -rf /home/scakmak/data/mariadb