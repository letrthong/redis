#!/bin/bash

# --- Check and Fix Previous dpkg Interruption ---
echo "--- 1. Checking for interrupted package operations ---"
sudo dpkg --configure -a

# --- Fix Incorrect Docker Repository Setup ---
echo "--- 2. Cleaning up any previous, incorrect Docker repository files ---"

# This line removes the faulty 'docker.list' file if it exists
sudo rm -f /etc/apt/sources.list.d/docker.list

# --- Install Prerequisites and GPG Key ---
echo "--- 3. Installing prerequisites and importing Docker GPG key ---"

# Install dependencies needed for repository setup
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# --- Add Correct Ubuntu Repository ---
echo "--- 4. Adding the correct official Docker (Ubuntu) repository ---"

# This uses the correct 'ubuntu' path and the distribution codename (e.g., 'jammy')
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- Final Update and Installation ---
echo "--- 5. Running final package update ---"
sudo apt update

echo "--- 6. Installing Docker Engine and Compose Plugin ---"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# --- Post-Installation Setup ---
echo "--- 7. Setting up Docker for non-root user access ---"

# Add the current user ($USER) to the 'docker' group
sudo usermod -aG docker $USER

echo "--------------------------------------------------------"
echo "✅ Docker Installation Complete!"
echo "➡️ ACTION REQUIRED: You must log out and log back in, or run 'newgrp docker' for non-root access to take effect."
echo "➡️ Test with: docker run hello-world (after relogging/newgrp)"
echo "--------------------------------------------------------"
