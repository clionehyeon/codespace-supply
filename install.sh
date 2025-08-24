#!/bin/bash

set -e

echo "ℹ️ 기본 환경 구축 시작"

echo "==> 시스템 패키지 업데이트..."
sudo apt update && sudo apt upgrade -y

echo "📦 ==> 필수 개발 도구 설치..."
sudo apt install -y build-essential cmake git libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libgl1-mesa-dev libxi-dev
echo "📦 ==> 필수 개발 도구 설치완료"

echo "🔧 기본 환경 구축 완료"

echo "🔧 Vulkan SDK + GLFW 환경 구축 시작"

echo "📦 ==> Vulkan SDK 관련 패키지 설치..."
wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-noble.list http://packages.lunarg.com/vulkan/lunarg-vulkan-noble.list
sudo apt update
sudo apt install vulkan-sdk
echo "📦 ==> Vulkan SDK 관련 패키지 설치완료"

echo "📦 ==> GLFW 설치..."
sudo apt install libglfw3 libglfw-dev
echo "📦 ==> GLFW 설치완료"

echo "🔧 Vulkan SDK + GLFW 환경 구축 완료"

echo "🔧 VCN 환경 구축 시작"

echo "📦 ==> noVCN, Xtigervcn 설치..."
mkdir -p ~/setup-display && cd ~/setup-display
cat > docker-compose.yml <<EOF
services:
  display:
    image: ghcr.io/dtinth/xtigervnc-docker:main
    tmpfs: /tmp
    restart: always
    environment:
      VNC_GEOMETRY: 1440x900
    ports:
      - 127.0.0.1:5900:5900
      - 127.0.0.1:6000:6000
  novnc:
    image: geek1011/easy-novnc
    restart: always
    command: -a :5800 -h display --no-url-password
    ports:
      - 127.0.0.1:5800:5800
EOF
docker compose up -d
echo "📦 ==> noVCN, Xtigervcn 구축 완료"

echo "🔧 VCN 환경 구축 완료"

echo "✅ Vulkan, GLFW 환경 구축 완료!"
