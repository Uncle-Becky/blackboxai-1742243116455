#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Claude Code Interface...${NC}\n"

# Check Node.js version
echo "Checking Node.js version..."
if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js is not installed. Please install Node.js 18 or higher.${NC}"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2)
if (( $(echo "$NODE_VERSION 18.0.0" | awk '{print ($1 < $2)}') )); then
    echo -e "${RED}Node.js version must be 18 or higher. Current version: $NODE_VERSION${NC}"
    exit 1
fi

echo -e "${GREEN}Node.js version $NODE_VERSION detected${NC}\n"

# Check for Claude Code CLI
echo "Checking Claude Code CLI installation..."
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Claude Code CLI not found. Installing globally...${NC}"
    npm install -g @anthropic-ai/claude-code
else
    echo -e "${GREEN}Claude Code CLI detected${NC}"
fi

# Create necessary directories
echo -e "\nCreating necessary directories..."
mkdir -p server/uploads
mkdir -p server/logs
mkdir -p server/data
echo -e "${GREEN}Directories created${NC}"

# Install dependencies
echo -e "\nInstalling dependencies..."

# Root dependencies
echo "Installing root dependencies..."
npm install

# Client dependencies
echo "Installing client dependencies..."
cd client
npm install
cd ..

# Server dependencies
echo "Installing server dependencies..."
cd server
npm install
cd ..

echo -e "${GREEN}Dependencies installed successfully${NC}"

# Set up environment variables if not exists
if [ ! -f server/.env ]; then
    echo -e "\nCreating .env file..."
    cp server/.env.example server/.env 2>/dev/null || cat > server/.env << EOL
# Server Configuration
PORT=3001

# Database Configuration
DB_PATH=./data/claude-code.db

# File Upload Configuration
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=10485760 # 10MB in bytes

# Logging Configuration
LOG_LEVEL=info
EOL
    echo -e "${GREEN}.env file created${NC}"
fi

# Final setup message
echo -e "\n${GREEN}Setup completed successfully!${NC}"
echo -e "${BLUE}To start the development server:${NC}"
echo -e "1. Run ${GREEN}npm run dev${NC} to start both client and server"
echo -e "2. Or start them separately:"
echo -e "   - Client: ${GREEN}cd client && npm run dev${NC}"
echo -e "   - Server: ${GREEN}cd server && npm run dev${NC}"
echo -e "\nThe application will be available at:"
echo -e "- Frontend: ${GREEN}http://localhost:3000${NC}"
echo -e "- Backend API: ${GREEN}http://localhost:3001${NC}"
