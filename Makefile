clean-examples:
	docker exec -it namenode hadoop fs -rm -r /user/*
	docker exec -it namenode hadoop fs -rm -r /tmp/*

start:
	./start-hadoop-spark-workbench.sh

start-scale-spark:
ifdef num
	docker-compose up -d --scale spark-worker=$(num)
else
	@echo 'RUN: default to 3 workers.'
	docker-compose up -d --scale spark-worker=3
endif

stop:
	docker-compose down

stop-clean: stop
	@echo 'RUN: STOPPING ALL, pruning containers, volumes, and networks'
	docker system prune -a && docker volume prune && docker network prune

clean:
	@ echo 'RUN: pruning containers, volumes, and networks'
	docker system prune -a && docker volume prune && docker network prune

example-json-schema:
	docker exec -it spark-master bash -c "./spark/bin/spark-submit --master local[*] /spark/stuff/json-schema.py schema.json"

example-wordcount:
	docker exec -it spark-master bash -c "./spark/bin/spark-submit --master local[*] /spark/stuff/wordcount.py wordcount.txt"
