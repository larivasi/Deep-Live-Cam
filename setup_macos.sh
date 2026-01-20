#!/bin/bash
# Deep-Live-Cam Setup Script for macOS (Apple Silicon M1/M2/M3/M4)
# Run this script from the Deep-Live-Cam directory

set -e

echo "🚀 Deep-Live-Cam Setup for Apple Silicon"
echo "========================================="

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is for macOS only!"
    exit 1
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Python 3.11 if not present
if ! command -v python3.11 &> /dev/null; then
    echo "🐍 Installing Python 3.11..."
    brew install python@3.11
fi

# Install tkinter
echo "🖼️ Installing tkinter..."
brew install python-tk@3.11

# Install ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo "🎬 Installing ffmpeg..."
    brew install ffmpeg
fi

# Create virtual environment
echo "📁 Creating virtual environment..."
if [ -d "venv" ]; then
    echo "   Removing old venv..."
    rm -rf venv
fi
python3.11 -m venv venv
source venv/bin/activate

# Upgrade pip
echo "⬆️ Upgrading pip..."
pip install --upgrade pip

# Install requirements
echo "📚 Installing Python dependencies..."
pip install -r requirements.txt

# Install CoreML support for Apple Silicon
echo "🍎 Installing CoreML support for Apple Silicon..."
pip uninstall -y onnxruntime onnxruntime-silicon 2>/dev/null || true
pip install onnxruntime-silicon==1.13.1

# Download models
echo "🤖 Downloading AI models..."
mkdir -p models

if [ ! -f "models/GFPGANv1.4.pth" ]; then
    echo "   Downloading GFPGANv1.4.pth..."
    curl -L -o models/GFPGANv1.4.pth \
        "https://huggingface.co/hacksider/deep-live-cam/resolve/main/GFPGANv1.4.pth"
fi

if [ ! -f "models/inswapper_128_fp16.onnx" ]; then
    echo "   Downloading inswapper_128_fp16.onnx..."
    curl -L -o models/inswapper_128_fp16.onnx \
        "https://huggingface.co/hacksider/deep-live-cam/resolve/main/inswapper_128_fp16.onnx"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "========================================="
echo "To run Deep-Live-Cam:"
echo ""
echo "  1. Activate the virtual environment:"
echo "     source venv/bin/activate"
echo ""
echo "  2. Run with CoreML acceleration:"
echo "     python run.py --execution-provider coreml"
echo ""
echo "  Or simply run:"
echo "     ./run_macos.sh"
echo "========================================="
