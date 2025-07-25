#! /usr/bin/python

import pyspark

#Create List
numbers = [1,2,1,2,3,4,4,6]

# Creating RDD using parallelize method of SparkContext
rdd = sc.parallelize(numbers)

#Returning distinct elements from RDD
distinct_numbers = rdd.distinct().collect()

#Print
print(f'Distinct Numbers: {distinct_numbers}')