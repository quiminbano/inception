FILE = srcs/docker-compose.yml

PROGRAM = docker-compose

all: .dummy

.dummy:
		$(PROGRAM) -f $(FILE) up -d
		@touch .dummy

stop:
		$(PROGRAM) -f $(FILE) down
		@rm .dummy

fclean:
		rm -f .dummy
		docker system prune --all --force --volumes