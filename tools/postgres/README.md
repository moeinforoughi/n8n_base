1.  Create the necessary directories:

```bash
mkdir -p pgvector-data pgadmin-data
```
2.  Set the correct ownership (ensures the n8n user inside the container can write to the host):
    * The container runs as UID 1000 by default, so we set the host directories to match

```bash
sudo chown -R 1000:1000 pgvector-data pgadmin-data
```
3.  Set permissions:

```bash
chmod -R 755 pgvector-data pgadmin-data
```

4. Run the Services :

```bash
docker compose up -d
```

