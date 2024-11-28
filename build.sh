# Step 1: Build the Docker image
docker build  --platform linux/amd64   -t cups .

# # Step 2: Stop the existing container (if running)
docker stop cups-container

# # Step 3: Remove the stopped container
docker rm cups-container

docker run -d -p 631:631 -e CUPS_USER_ADMIN=admin -e CUPS_USER_PASSWORD=admin --name cups-container cups
