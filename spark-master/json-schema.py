
from __future__ import print_function
import sys
from pyspark.sql import SparkSession


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: json-schema <some-file.json>", file=sys.stderr)
        exit(-1)

    spark = SparkSession\
        .builder\
        .appName("readJSON")\
        .getOrCreate()

    df = spark.read.json(sys.argv[1])
    newline = "\n"
    header = "*"*5
    print(newline + header + "\tSTARTING PYSPARK JOB\t" + header)
    print(spark)
    df.printSchema()
    df.show()
    print(newline + header + "\tFINISHED PYSPARK JOB\t" + header + newline)

    spark.stop()
