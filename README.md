# 🐳 Inception

Inception is a system administration project from the 42 curriculum.  
The goal is to set up a small infrastructure using Docker and Docker Compose.

---

## 📖 About the Project

This project consists of creating and managing multiple Docker containers that work together to host a website.

Each service runs in its own container and communicates with others through a Docker network.

This project focuses on:

- Docker and Docker Compose
- Containerization
- Networking
- Service configuration
- Environment variables

---

## ⚙️ Services

The infrastructure includes:

- **NGINX** – Web server with TLS support  
- **WordPress** – Website application  
- **MariaDB** – Database server  

Each service runs in its own container and is configured using custom Dockerfiles.

---

## 🌐 Access

The website is accessible at:

```
https://merdal.42.fr
```

Login page:

```
https://merdal.42.fr/wp-admin
```

### 👤 Users

- **Admin**  
  Has full administrative rights and can manage the entire website (content, users, settings).

- **User**  
  Has limited permissions and cannot access administrative features.

---

## 🧠 Concepts Learned

- How to build custom Docker images
- How to manage multiple containers
- How containers communicate via networks
- How to use volumes for persistent data
- How to configure services securely

---

## 📦 Installation

Clone the repository:

```bash
git clone https://github.com/Mert5558/Inception.git
cd Inception
```

---

## 🚀 Usage

Build and start the infrastructure:

```bash
make
```

Stop and clean everything:

```bash
make clean
```

---
