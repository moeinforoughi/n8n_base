# n8n_base: Materials for n8n Setup and Workflows

This repository provides materials for setting up and running n8n using Docker Compose.

## 1. Prerequisites

You need the following installed:

* **Git**
    * [Install Git](https://github.com/git-guides/install-git)
* **Docker and Docker Compose**
    * [Install Docker Desktop (Windows/Mac)](https://docs.docker.com/desktop/install/)
    * [Install Docker Engine (Linux)](https://docs.docker.com/engine/install/)

## 2. Configuration Setup

### A. Configure Environment Variables

1.  Copy the example environment file:
```bash
cp .env.example .env
```

2.  **Edit the .env file** to set your desired values.
    * **Mandatory:** At minimum, set your N8N_HOST 
    * **Recommendation:** For production, uncomment and set N8N_EDITOR_BASE_URL and WEBHOOK_URL.

### B. Setting the n8n Version

You can define the desired n8n version by changing the tag in both docker-compose.vol.yml and docker-compose.bind.yml.

* Current version in files: 1.116.2 (Update this to the latest stable version if necessary).

## 3. Storage Setup (Bind Mounts Only)

If you are using **Docker Volumes** (docker-compose.vol.yml), you can **skip this section**. Docker manages the persistent storage automatically.

If you are using **Bind Mounts** (docker-compose.bind.yml), you must create and secure the directories:

1.  Create the necessary directories:

```bash
mkdir -p data local-files
```

2.  Set the correct ownership (ensures the n8n user inside the container can write to the host):
    * The container runs as UID 1000 by default, so we set the host directories to match

```bash
sudo chown -R 1000:1000 data local-files
```

3.  Set permissions:

```bash
chmod -R 755 data local-files
```

## 4. Running n8n with Docker Compose

Choose your preferred storage method:

### A. Run with Docker Volumes (Recommended)
Persistent data is managed by Docker in a named volume, which is usually simpler.
```bash
docker compose -f docker-compose.vol.yml up -d
```
### B. Run with Bind Mounts
Persistent data is stored in the data and local-files directories next to your docker-compose.bind.yml file.

```bash
docker compose -f docker-compose.bind.yml up -d
```

## 5. Accessing n8n

After running the command, wait a few moments for the container to start.

* **Local Machine (Default):** Open http://localhost:5678 in your browser.
* **VM/VPS (Direct IP):** Open http://SERVER_IP:5678 (e.g., http://74.56.122.50:5678).
* **With Reverse Proxy/Domain:** Open your configured domain (e.g., https://myn8n.com).