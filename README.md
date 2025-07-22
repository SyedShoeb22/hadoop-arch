# 🧰 Oozie + Hadoop + Hive + Zookeeper - Dockerized Big Data Stack

This setup runs Apache Oozie with Hadoop HDFS, Hive, and Zookeeper using Docker Compose. It also supports uploading and running Oozie workflows.

---

## 📁 Folder Structure

```
project-root/
├── docker-compose.yml
├── hadoop-config/
│   └── core-site.xml
└── oozie-hive-wf/
    ├── workflow.xml
    └── job.properties
```

---

## 📦 Prerequisites

- Docker
- Docker Compose
- Basic familiarity with Hadoop and Oozie

---

## 🔧 1. Configure core-site.xml

Create a directory `./hadoop-config/` and inside it, add a file `core-site.xml`:

```xml
<configuration>
  <!-- Allow Oozie to impersonate other users -->
  <property>
    <name>hadoop.proxyuser.root.hosts</name>
    <value>*</value>
  </property>
  <property>
    <name>hadoop.proxyuser.root.groups</name>
    <value>*</value>
  </property>
</configuration>
```

---

## 🐳 2. Docker Compose Setup

Add this to your `docker-compose.yml`:

```yaml
oozie:
  image: juanmartinez/oozie:5.2.0
  container_name: oozie
  ports:
    - "11000:11000"
  depends_on:
    - zookeeper
    - hive-metastore
    - hive-server
    - resourcemanager
    - namenode
    - datanode
  volumes:
    - ./hadoop-config/core-site.xml:/opt/hadoop/etc/hadoop/core-site.xml
  environment:
    SERVICE_PRECONDITION: "zookeeper:2181 hive-metastore:9083 hive-server:10000 resourcemanager:8088 namenode:50070 datanode:50075"
```

Make sure to also include the Hadoop containers like `namenode`, `datanode`, and `resourcemanager`.

---

## 🚀 3. Start Containers

```bash
docker-compose up -d
```

---

## 📤 4. Upload Oozie Workflow to HDFS

Upload oozie-hive-wf folder to oozie container

```bash
docker cp ./oozie-hive-wf oozie:/opt/oozie/oozie-hive-wf
```

Enter the Oozie container:

```bash
docker exec -it oozie bash
```

Upload workflow to HDFS:

```bash
hdfs dfs -mkdir -p /user/oozie-hive-wf
hdfs dfs -put /opt/oozie/oozie-hive-wf /user/oozie-hive-wf/
```

---

## 📝 5. Example job.properties

In `oozie-hive-wf/job.properties`, define:

```properties
nameNode=hdfs://namenode:8020
jobTracker=resourcemanager:8032
queueName=default
oozie.wf.application.path=${nameNode}/user/oozie-hive-wf/oozie-hive-wf
oozie.use.system.libpath=true
```

---

## ▶️ 6. Run Oozie Job

Inside the container:

```bash
cd /opt/oozie/oozie-hive-wf
oozie job -oozie http://localhost:11000/oozie -config job.properties -run
```

If you encounter this error:
```
User: root is not allowed to impersonate root
```
Make sure the `core-site.xml` file has the proxyuser configs and is mounted properly.

---

## 🐞 7. Troubleshooting

- **Kerberos Warnings**: You may see warnings related to Kerberos. These are usually safe to ignore if you're not using Kerberos.
- **Impersonation Issues**: Confirm your `core-site.xml` has:
  ```xml
  <property>
    <name>hadoop.proxyuser.root.hosts</name>
    <value>*</value>
  </property>
  <property>
    <name>hadoop.proxyuser.root.groups</name>
    <value>*</value>
  </property>
  ```

---

## 📦 Optional: Push Container to Docker Hub

To tag and push your image:

```bash
docker tag your-custom-image username/oozie-custom:tag
docker push username/oozie-custom:tag
```

---

## 📬 Connect

- Oozie Web UI: [http://localhost:11000/oozie](http://localhost:11000/oozie)
- HDFS UI (NameNode): [http://localhost:50070](http://localhost:50070)

---

## ✅ Next Steps

- Create Hive actions in your workflows
- Integrate Spark or Pig jobs
- Automate workflow uploads and runs via script
