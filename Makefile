NAME_IMAGE		=s21_$(shell  grep FROM Dockerfile|sed 's|:.*||'|sed 's|.*/||'|sed 's|.* ||')
NAME_CONTAINER	=$(NAME_IMAGE)

all: start_cs

# mcs decimal_convert.cs && mono decimal_convert.exe | tee convert.log && rm decimal_convert.exe

docker_build: Dockerfile
	docker build -t $(NAME_IMAGE) .

docker_run:
	# docker run --name $(NAME_CONTAINER) --rm -i -t -v $(shell pwd):/s21_home $(NAME_IMAGE)
	docker run --name $(NAME_CONTAINER) --rm -d -t -v $(shell pwd):/s21_home $(NAME_IMAGE)
	# 2>/dev/null || true

in_container:
	docker exec -it $(NAME_CONTAINER) bash

docker_stop:
	docker stop $(NAME_CONTAINER) || true

docker_rm: docker_stop
	docker rmi $(NAME_IMAGE) || true

start_cs:
	docker exec -it $(NAME_CONTAINER) mcs decimal_convert.cs 
	docker exec -it $(NAME_CONTAINER) mono decimal_convert.exe>convert.log
	cat convert.log
	@docker exec -it $(NAME_CONTAINER) rm decimal_convert.exe

clean:
	rm -rf convert.log decimal_convert.exe