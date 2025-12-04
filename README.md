# Paper Submission System
[中文](README-CN.md)

A full-stack paper submission and management system consisting of a React frontend and a Node.js/Express backend.

## Project Structure

The project is divided into two main parts:

- `client/`: Frontend application built with React + Vite + Mantine
- `server/`: Backend application built with Node.js + Express + MySQL

## Features

- User Authentication (JWT)
- Paper Submission & Management
- Review System
- Role-based Access Control (Authors, Reviewers, Administrators)
- File Upload Support
- Docker Support

## Tech Stack

### Client
- React
- Vite
- Mantine UI
- React Query
- React Router
- Axios
- i18next (Internationalization)

### Server
- Node.js
- Express
- MySQL
- JWT Authentication
- Multer (File Uploads)

## Getting Started

### Prerequisites
- Node.js (v16+)
- MySQL
- Docker & Docker Compose (Optional)

### Running with Docker Compose (Recommended)

1. Make sure Docker and Docker Compose are installed
2. Run the following command in the root directory:

```bash
docker-compose up --build
```

The services will be available at:
- Frontend: http://localhost:21743
- Backend API: http://localhost:5000

### Manual Setup

#### Server

1. Navigate to the server directory:
```bash
cd server
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables:
Create a `.env` file based on the configuration in `compose.yaml` or your local setup.

4. Initialize Database:
Execute the SQL scripts located in `server/SQL/` to set up your MySQL database.

5. Start the server:
```bash
npm start
```

#### Client

1. Navigate to the client directory:
```bash
cd client
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

## License

ISC
