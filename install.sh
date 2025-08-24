set -e

echo "==> 시스템 패키지 업데이트..."
sudo apt update && sudo apt upgrade -y

echo "==> 필수 개발 도구 설치..."
sudo apt install -y build-essential cmake git libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libgl1-mesa-dev libxi-dev

echo "==> Vulkan 관련 패키지 설치..."
sudo apt install -y vulkan-tools vulkan-validationlayers-dev libvulkan-dev

echo "==> GLFW 설치..."
git clone https://github.com/glfw/glfw.git
cd glfw
cmake -S . -B build
cmake --build build
sudo cmake --install build
cd ..
rm -rf glfw

echo "Vulkan과 GLFW 환경 구축 완료!"
