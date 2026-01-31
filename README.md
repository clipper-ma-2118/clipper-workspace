# Clipper Task Tracker

A trivial full-stack web app built by Clipper.

## Architecture
- **Frontend:** Vanilla JS / HTML
- **Backend:** Node.js + Express
- **Database:** PostgreSQL

## How to Run Locally

1. **Ensure Docker and Docker Compose are installed.**
2. **Clone the repo:**
   ```bash
   git clone git@github.com:clipper-ma-2118/clipper-workspace.git
   cd clipper-workspace
   ```
3. **Start the app:**
   ```bash
   docker-compose up --build
   ```
4. **Visit the app:**
   Open [http://localhost:3000](http://localhost:3000) in your browser.

## Features
- Persistence: Tasks are saved in a Postgres database.
- Orchestration: Single command setup via Docker Compose.
- Automated Init: Database schema is created on first boot.
