set -e

echo "ℹ️ 기본 환경 구축 시작"

echo "📦 ==> 시스템 패키지 업데이트..."
sudo apt update && sudo apt upgrade -y
echo "📦 ==> 시스템 패키지 업데이트 완료"

echo "📦 ==> 필수 개발 도구 설치..."
sudo apt install -y build-essential cmake git libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libgl1-mesa-dev libxi-dev libxxf86vm-dev
sudo apt install -y ninja-build
sudo apt install -y clang
echo "📦 ==> 필수 개발 도구 설치 완료"

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
echo "📦 ==> noVCN, Xtigervcn 설치 완료"

echo "✅ Vulkan, GLFW 환경 구축 완료!"
