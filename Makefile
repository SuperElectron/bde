get-example:
	if [ ! -f example/SparkWriteApplication.jar ]; then \
	wget -O example/SparkWriteApplication.jar https://www.dropbox.com/s/7dn0horm8ocbu0p/SparkWriteApplication.jar ; \
	fi

example: get-example
	docker run --rm -it --network dockerhadoopsparkworkbench_default --env-file ./hadoop.env -e SPARK_MASTER=spark://spark-master:7077 --volume $(shell pwd)/example:/example bde2020/spark-base:2.1.0-hadoop2.8-hive-java8 /spark/bin/spark-submit --master spark://spark-master:7077 /example/SparkWriteApplication.jar
	docker exec -it namenode hadoop fs -cat /tmp/numbers-as-text/part-00000

clean-example:
	docker exec -it namenode hadoop fs -rm -r /tmp/numbers-as-text

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
