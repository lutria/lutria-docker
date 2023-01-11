# Lutria Docker

Deploys Lutria system components using Docker Compose.

Currently this includes:
* MinIO
* Mongo - single node replica set
* NATS

## Usage

### Initial setup

#### 1. Create secrets directory

Create a `secrets` directory inside the `lutria-docker` repository.

#### 2. Generate Mongo keyfile:

Generate a random key to use for Mongo SCRAM authentication:

```shell
openssl rand -base64 756 > ./secrets/mongo-keyfile
chmod 600 ./secrets/mongo-keyfile
chown 999:999 ./secrets/mongo-keyfile # must be owned by the user with uid 999 and gid 999
```

#### 3. Populate credentials

Add the following files to the `secrets` directory with the credentials that you want to use:

* minio-root-password
* minio-root-username
* mongo-app-password
* mongo-app-username
* mongo-root-password
* mongo-root-username

#### 4. Bring the services up
```shell
docker compose up -d
```

#### X. Modify hosts file (optional)
If you want to be able to connect to the Mongo replica set from the host, i.e.
from a client that's not running within the Docker network, then add the
following to the `/etc/hosts` file on the host:

```
127.0.0.1    mongo
```

Connect to Mongo as admin user:
```shell
docker exec -it mongo mongo -u $(cat ./secrets/mongo-root-username) -p $(cat ./secrets/mongo-root-password)
```

Connect to Mongo as application user:
```shell
docker exec -it mongo mongo localhost/lutria -u $(cat ./secrets/mongo-app-username) -p $(cat ./secrets/mongo-app-password)
```

**Documentation**
* https://github.com/minio/minio/blob/master/docs/docker/README.md
