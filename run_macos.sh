#!/bin/bash
# Run Deep-Live-Cam on macOS with CoreML acceleration

cd "$(dirname "$0")"

# Activate virtual environment
source venv/bin/activate

# Run with CoreML for Apple Silicon
python run.py --execution-provider coreml
