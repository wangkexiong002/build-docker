# Docker image: wangkexiong/aerospike-amc

![License](https://img.shields.io/github/license/wangkexiong002/build-docker)
![5.0.0](https://img.shields.io/docker/v/wangkexiong/aerospike-amc/5.0.0?style=social)

## Aerospike Management Console

The Aerospike Management Console (AMC) is a web-based tool to monitor/manage an Aerospike cluster.

It provides live updates to the current status of a cluster. It includes features to let you see at a glance the throughput, storage usage, and configuration of a cluster.

Since version of 4.0, AMC has been rewritten in GO. We can build docker image from scratch to reduce its size.

The latest solution for aerospike cluster monitoring and alerting is Aerospike Monitoring Stack based on Prometheus and Grafana.

```bash
docker run -d -p 8081:8081 --name aerospike-console wangkexiong/aerospike-amc
```

Access through http://127.0.0.1:8081

