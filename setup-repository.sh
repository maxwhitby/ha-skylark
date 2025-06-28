#!/bin/bash
# Run this script from a machine with git installed

echo "Setting up Home Assistant configuration repository..."

# Initialize git repository
git init

# Add all files (respecting .gitignore)
git add .

# Create initial commit
git commit -m "Initial Home Assistant configuration commit"

# Add remote repository (update with your repository URL)
echo ""
echo "Now add your remote repository:"
echo "git remote add origin https://github.com/YOUR_USERNAME/YOUR_HA_REPO.git"
echo ""
echo "Then push your changes:"
echo "git branch -M main"
echo "git push -u origin main"