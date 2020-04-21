[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/big-data-europe/docker-hadoop-spark-workbench)

# How to use HDFS/Spark Workbench

- start the simple workbench
```
    make start
```
- start the workbench with 3 workers
```bash
    make start-scale-spark
```

## Interfaces

* Namenode: http://localhost:50070
* Datanode: http://localhost:50075
* Spark-master: http://localhost:8080
* Spark-notebook: http://localhost:9001
* Hue (HDFS Filebrowser): http://localhost:8088/home

## Important

When opening Hue, you might encounter ```NoReverseMatch: u'about' is not a registered namespace``` error after login. I disabled 'about' page (which is default one), because it caused docker container to hang. To access Hue when you have such an error, you need to append /home to your URI: ```http://docker-host-ip:8088/home```

## Docs
* [Motivation behind the repo and an example usage @BDE2020 Blog](http://www.big-data-europe.eu/scalable-sparkhdfs-workbench-using-docker/)

## Count Example for Spark-Shell
- this example works with `namenode` and `spark-master` (or one of `bde_spark-worker_x`)

__setup HDFS__

```
docker exec -it namenode bash -c "\
mkdir -p /user/root \
echo "Hello Docker Docker Hello" > /user/root/workcount.txt \
hdfs dfs -put ./user/* /user"
```

__view changes in visual file system__

- view the file in hue browser (user=hue, password=whatever-you-want)
- http://localhost:8080/home
- http://localhost:8088/filebrowser/view=/user/root
- did you get a login error? Look up @ ##Docs

__spark-master/worker pulls files from HDFS__
- start spark-shell in `spark-master` or `bde_spark-worker_x` (if you get `hive` error, Ctrl+c and retry!)

```bash
docker exec -it spark-master bash -c "/spark/bin/spark-shell"
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
20/04/21 19:17:26 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
20/04/21 19:17:30 WARN metastore.ObjectStore: Failed to get database global_temp, returning NoSuchObjectException
Spark context Web UI available at http://172.30.0.6:4040
Spark context available as 'sc' (master = local[*], app id = local-1587496647073).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.2-SNAPSHOT
      /_/
         
Using Scala version 2.11.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_121)
Type in expressions to have them evaluated.
Type :help for more information.
```

- now you can read the text file in
```bash

scala> val f1 = spark.read.textFile("wordcount.txt")
f1: org.apache.spark.sql.Dataset[String] = [value: string]

scala> f1.count()
res0: Long = 1

scala> f1.collect()
res1: Array[String] = Array(hello world hello docker)
```

## Count Example for Spark-Submit

__example-wordcount.py__

- you must have `wordcount.txt` available in HDFS!
- add it here: http://localhost:8088/filebrowser/view=/user/root

```bash
make example-wordcount

world: 2
docker: 2
```

__example-json.py__

- you must have "schema.json" available in HDFS!
- add it here: http://localhost:8088/filebrowser/view=/user/root

```bash
make example-json-schema
```
