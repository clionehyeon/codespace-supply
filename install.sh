set -e

echo "==> 시스템 패키지 업데이트..."
sudo apt update && sudo apt upgrade -y

echo "==> 필수 개발 도구 설치..."
sudo apt install -y build-essential cmake git libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libgl1-mesa-dev libxi-dev

echo "==> Vulkan SDK 관련 패키지 설치..."
wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-noble.list http://packages.lunarg.com/vulkan/lunarg-vulkan-noble.list
sudo apt update
sudo apt install vulkan-sdk

echo "==> GLFW 설치..."
sudo apt install libglfw3 libglfw-dev

echo "Vulkan과 GLFW 환경 구축 완료!"
