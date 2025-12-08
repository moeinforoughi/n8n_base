# Quick setup (Postgres + pgAdmin)

1. Create data directories

```bash
mkdir -p pgvector-data pgadmin-data
```

2. (Linux) Adjust ownership and permissions so the container can write data

```bash
sudo chown -R 1000:1000 pgvector-data pgadmin-data
chmod -R 755 pgvector-data pgadmin-data
```

3. Configure environment variables

- A sample `.env` file has been added to this folder. Edit `tools/postgres/.env` and replace the example values with your desired credentials. The Compose file uses these variables by default.

Example `.env` fields (edit as needed):

```
POSTGRES_USER=myuser
POSTGRES_PASSWORD=securepassword
POSTGRES_DB=mydb
PGADMIN_DEFAULT_EMAIL=admin@example.com
PGADMIN_DEFAULT_PASSWORD=adminpassword
POSTGRES_PORT=5432
PGADMIN_PORT=8080
```

If you prefer to hard-code values, open `docker-compose.yml` and update the `environment:` blocks for the `postgres` and `pgadmin` services, but storing secrets in `.env` is recommended.

4. Start the stack (bash)

```bash
docker compose up -d
```

5. Stop the stack and view logs (bash)

```bash
docker compose down
docker compose logs -f
```

Notes:
- The `docker-compose.yml` in this folder now uses environment variable substitution with safe defaults. If you change `.env` values, run `docker compose down` then `docker compose up -d` to apply the new credentials.
- Data is persisted to `./pgvector-data` and `./pgadmin-data`. Removing those folders or running `docker compose down --volumes` will remove persisted data.

