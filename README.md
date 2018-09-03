# Sidecar Restore Volumes

Example deploy on  ```deploy_sidecar_example/docker-compose.yml```

For kubernetes job see `kubernetes/jobs.yml`

Copy `env.sample` as `.env`

Run ONE TIME ONLY. Restores tar.gz configured on `.env` file replacing contents of existing folders

## S3 config

ENVIROMENT VARIABLE   | DESCRIPTION | Values
----------   | ---------- | --------------  
**TAR_TO_RESTORE** | full file path on bucket | string
**TAR_PATH** | directory on bucket (where latest file will be considered) | string
S3_BUCKET | Bucket name | string
S3_HOST | host:port | `host:port`
S3_PROTOCOL | protocol type | `http` or `https`
S3_KEY | key | string
S3_SECRET | secret | string
TRANSFORM_FROM | rsync from directory after extraction | string
TRANSFORM_TO | rsync to directory after extraction (deletes content) | string

## Optional Variables to change wp-config.php wordpress

ENVIROMENT VARIABLE   | DESCRIPTION | Values
----------   | ---------- | --------------  
NEW_WORDPRESS_HOST | Db Host replaced on wp-config.php | string
NEW_WORDPRESS_DBNAME | Db name replaced on wp-config.php | string
NEW_WORDPRESS_DBUSER | Db user replaced on wp-config.php | string
NEW_WORDPRESS_DBPASS | Db password replaced on wp-config.php | string
**NEW_WORDPRESS_WPCONFIG_PATH** | Path of wp-config.php file, needed to enable replace function | string


# Usage with named file

Create `.env` file:

```bash
TAR_TO_RESTORE="dumpdata/XXXXX.tar.gz"
### S3 or minio host
S3_HOST=minio:9000
### Protocol
S3_PROTOCOL=http
### Your bucket name
S3_BUCKET=cicciopollo
### minio or s3 credentials
S3_KEY=85A8U57ZITLSLFBYKNCG
S3_SECRET=14MAuAetrv7y3E6zAuUOimXy5KYRqrZKw3cWuEe/
```

# Usage with latest file from directory

Create `.env` file:

```bash
TAR_PATH="dumpdata" #no trailing slash
### S3 or minio host
S3_HOST=minio:9000
### Protocol
S3_PROTOCOL=http
### Your bucket name
S3_BUCKET=cicciopollo
### minio or s3 credentials
S3_KEY=85A8U57ZITLSLFBYKNCG
S3_SECRET=14MAuAetrv7y3E6zAuUOimXy5KYRqrZKw3cWuEe/
```

Create `docker-compose.yml` file:

```yml
version: '2'
services:
  sidecar-restore-volumes:
      image: beeckup/sidecar-restore-volumes:latest
      restart: "no"
      environment:
        - TAR_TO_RESTORE=${TAR_TO_RESTORE} ## or - TAR_PATH=${TAR_PATH}
        - S3_BUCKET=${S3_BUCKET}
        - S3_KEY=${S3_KEY}
        - S3_SECRET=${S3_SECRET}
        - S3_HOST=${S3_HOST}
        - S3_PROTOCOL=${S3_PROTOCOL}
      volumes_from:
        - wordpress:rw  # example mounted volumes for backups
###################
##### example wordpress install
  wordpress:
      image: wordpress
      restart: always
      ports:
        - "80:80"
      volumes:
        - ./wp-app:/var/www/html

```

Launch with

```bash
docker-compose up -d
```
