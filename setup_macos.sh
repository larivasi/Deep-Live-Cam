#!/bin/bash
# Deep-Live-Cam Setup Script for macOS (Apple Silicon M1/M2/M3/M4)
# Run this script from the Deep-Live-Cam directory

set -e

echo "Deep-Live-Cam Setup for Apple Silicon"
echo "========================================="

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is for macOS only!"
    exit 1
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Python 3.11 if not present
if ! command -v python3.11 &> /dev/null; then
    echo "Installing Python 3.11..."
    brew install python@3.11
fi

# Install tkinter
echo "Installing tkinter..."
brew install python-tk@3.11 2>/dev/null || true

# Install ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "Installing ffmpeg..."
    brew install ffmpeg
fi

# Remove old virtual environment if exists
if [ -d "venv" ]; then
    echo "Removing old venv..."
    rm -rf venv
fi

# Create virtual environment
echo "Creating virtual environment..."
python3.11 -m venv venv
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install Python dependencies for macOS (NO CUDA!)
echo "Installing Python dependencies for macOS..."
echo "Step 1/8: Core packages..."
pip install "numpy>=1.23.5,<2" "typing-extensions>=4.8.0"

echo "Step 2/8: OpenCV..."
pip install opencv-python==4.10.0.84 cv2_enumerate_cameras==1.1.15

echo "Step 3/8: ONNX and InsightFace..."
pip install onnx==1.18.0 insightface==0.7.3

echo "Step 4/8: GUI packages..."
pip install psutil==5.9.8 tk==0.1.0 customtkinter==5.2.2 pillow==11.1.0

echo "Step 5/8: PyTorch for macOS (no CUDA)..."
pip install torch torchvision

echo "Step 6/8: ONNX Runtime for Apple Silicon..."
pip install onnxruntime-silicon==1.16.3

echo "Step 7/8: Additional packages..."
pip install opennsfw2==0.10.2 protobuf==4.25.1

echo "Step 8/8: BasicSR and GFPGAN..."
pip install git+https://github.com/xinntao/BasicSR.git@master
pip install git+https://github.com/TencentARC/GFPGAN.git@master

# Download models
echo ""
echo "Downloading AI models..."
mkdir -p models

if [ ! -f "models/GFPGANv1.4.pth" ]; then
    echo "   Downloading GFPGANv1.4.pth (~350MB)..."
    curl -L -o models/GFPGANv1.4.pth \
        "https://huggingface.co/hacksider/deep-live-cam/resolve/main/GFPGANv1.4.pth"
fi

if [ ! -f "models/inswapper_128_fp16.onnx" ]; then
    echo "   Downloading inswapper_128_fp16.onnx (~250MB)..."
    curl -L -o models/inswapper_128_fp16.onnx \
        "https://huggingface.co/hacksider/deep-live-cam/resolve/main/inswapper_128_fp16.onnx"
fi

echo ""
echo "========================================="
echo "Setup complete!"
echo "========================================="
echo ""
echo "To run Deep-Live-Cam:"
echo ""
echo "  source venv/bin/activate"
echo "  python run.py --execution-provider coreml"
echo ""
echo "Or simply run: ./run_macos.sh"
echo "========================================="
