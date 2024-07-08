FishBase API
============

***Update*** The Ruby-based fishbase API with custom endpoints has been deprecated.

Fishbase and Sealifebase data can now be accessed programmatically using a standard S3 API at the following endpoints:

https://fishbase.ropensci.org/fishbase
https://fishbase.ropensci.org/sealifebase

For example, in python:

```python
import duckdb
duckdb.read_parquet("https://fishbase.ropensci.org/fishbase/species.parquet") 
```

These endpoints are provided by the open source [MINIO Server](https://min.io/) which conforms to the current (v4) [AWS S3 REST API](https://docs.aws.amazon.com/AmazonS3/latest/API/Welcome.html).  This supports direct REST queries or any of the many great and well-maintained client packages and tools, including [minio client](https://min.io/docs/minio/linux/reference/minio-mc.html),  [python `boto`](https://aws.amazon.com/sdk-for-python/), [Apache Arrow](https://arrow.apache.org/), etc.   

