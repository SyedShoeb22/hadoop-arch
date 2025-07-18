```bash
docker compose up -d
```
```bash
docker exec -it docker-hadoop-hive-parquet-hive-server-1 bash
```
```bash
beeline -u jdbc:hive2://localhost:10000 -n hive
```
