#!/bin/bash
set -e  # exit if any command fails

# ===== CONFIGURATION =====
APP_NAME="spring-log-producer"
IMAGE_NAME="aprianfirlanda/${APP_NAME}"
GIT_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")
GIT_COMMIT=$(git rev-parse --short HEAD)
VERSION="${GIT_TAG}-${GIT_COMMIT}"

# ===== FUNCTIONS =====
echo_section() {
  echo
  echo "=============================="
  echo "▶ $1"
  echo "=============================="
}

# ===== 1️⃣ Build JAR =====
echo_section "Building Spring Boot JAR..."
./mvnw -DskipTests package

# ===== 2️⃣ Build Docker image =====
echo_section "Building Docker image..."
docker build -t ${IMAGE_NAME}:${VERSION} .

# ===== 3️⃣ Push Docker image =====
echo_section "Pushing image to Docker Hub..."
docker push ${IMAGE_NAME}:"${VERSION}"

# ===== DONE =====
echo_section "✅ Build & push complete!"
echo "Image pushed: ${IMAGE_NAME}:${VERSION}"
