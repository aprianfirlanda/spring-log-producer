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

# ===== 2️⃣ Build & Push Docker image =====
echo_section "Building & Pushing Docker image..."
if ! docker buildx inspect multiarch >/dev/null 2>&1; then
  docker buildx create --name multiarch --driver docker-container --use
else
  docker buildx use multiarch
fi
docker buildx inspect --bootstrap >/dev/null
docker buildx build --platform linux/amd64,linux/arm64 -t ${IMAGE_NAME}:"${VERSION}" --push .

# ===== DONE =====
echo_section "✅ Build & push complete!"
echo "Image pushed: ${IMAGE_NAME}:${VERSION}"
