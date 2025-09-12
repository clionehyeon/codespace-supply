#!/usr/bin/env bash
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

echo "🔧 기본 환경 구축 완료"

echo "🔧 Vulkan SDK + GLFW 환경 구축 시작"

echo "📦 ==> Vulkan SDK  설치..."

# Vulkan SDK 설치 경로
INSTALL_DIR="$HOME/vulkan-sdk"

echo "[*] 최신 Vulkan SDK 버전 확인 중..."
# 최신 버전 tar.gz 다운로드 URL 가져오기
URL=$(curl -s https://vulkan.lunarg.com/sdk/home | grep -oP 'https://sdk.lunarg.com/sdk/download/[^"]+linux.tar.gz' | head -n 1)

if [ -z "$URL" ]; then
    echo "[-] Vulkan SDK 다운로드 URL을 가져오지 못했습니다."
    exit 1
fi

# 파일명 추출
FILENAME=$(basename "$URL")

echo "[*] Vulkan SDK 다운로드: $URL"
wget -q --show-progress "$URL" -O "/tmp/$FILENAME"

echo "[*] 압축 해제 중..."
tar -xvf "/tmp/$FILENAME" -C /tmp

# SDK 디렉토리명 (예: 1.3.290.0)
SDK_DIR=$(tar -tf "/tmp/$FILENAME" | head -1 | cut -f1 -d"/")

# 설치 디렉토리 준비
mkdir -p "$INSTALL_DIR"
mv "/tmp/$SDK_DIR" "$INSTALL_DIR/"

# 최신 버전 심볼릭 링크 생성
ln -sfn "$INSTALL_DIR/$SDK_DIR" "$INSTALL_DIR/latest"

# 환경변수 설정 (~/.bashrc에 추가)
if ! grep -q "VULKAN_SDK" "$HOME/.bashrc"; then
    echo "[*] 환경 변수 추가 (~/.bashrc)"
    cat <<EOF >> "$HOME/.bashrc"

# Vulkan SDK
export VULKAN_SDK=\$HOME/vulkan-sdk/latest/x86_64
export PATH=\$VULKAN_SDK/bin:\$PATH
export LD_LIBRARY_PATH=\$VULKAN_SDK/lib:\$LD_LIBRARY_PATH
export VK_ICD_FILENAMES=\$VULKAN_SDK/etc/vulkan/icd.d/nvidia_icd.json:\$VULKAN_SDK/etc/vulkan/icd.d/intel_icd.json
export VK_LAYER_PATH=\$VULKAN_SDK/etc/vulkan/explicit_layer.d
EOF
fi

echo "[*] Vulkan SDK $SDK_DIR 설치 완료!"
echo "    적용하려면 다음을 실행하세요:"
echo "    source ~/.bashrc"

echo "📦 ==> Vulkan SDK 설치 완료"

echo "📦 ==> GLFW 설치..."
sudo apt -y install libglfw3 libglfw3-dev
echo "📦 ==> GLFW 설치완료"

echo "📦 ==> GLM 설치..."
sudo apt install libglm-dev
echo "📦 ==> GLM 설치완료"

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
echo "📦 ==> noVCN, Xtigervcn 설치 완료"

echo "🔧 VCN 환경 구축 완료"

echo "✅ Vulkan, GLFW 환경 구축 완료!"
