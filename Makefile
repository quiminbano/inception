all:
	@if [ ! -d "/home/corellan/data/db" ]; then \
		mkdir -p /home/corellan/data/db; \
	fi
	@if [ ! -d "/home/corellan/data/wp" ]; then \
		mkdir -p /home/corellan/data/wp; \
	fi
	docker-compose -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -f  ./srcs/docker-compose.yml down

clean:
	docker-compose -f ./srcs/docker-compose.yml down --rmi all -v

fclean: clean
	@if [ -d "/home/corellan/data" ]; then \
	rm -rf /home/corellan/data/* && \
	echo "successfully removed all contents from /home/corellan/data"; \
	fi;

prune:
	docker system prune --all --force --volumes

reset:
	docker stop $$(docker ps -qa) ; docker rm $$(docker ps -qa) ; \
	docker rmi -f $$(docker images -qa) ; docker volume rm $$(docker volume ls -q) ; \
	docker network rm $$(docker network ls -q)

re: fclean all

info:
		@echo "=============================== IMAGES ==============================="
		@docker images
		@echo
		@echo "============================= CONTAINERS ============================="
		@docker ps -a
		@echo
		@echo "=============== NETWORKS ==============="
		@docker network ls
		@echo
		@echo "====== VOLUMES ======"
		@docker volume ls