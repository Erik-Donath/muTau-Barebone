#!/usr/bin/env bash
set -euo pipefail

# Run from muTau-PlatformIO root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

echo ">>> Updating base submodule to latest remote..."
git submodule update --init --remote base

echo ">>> Updating submodules inside base (including litex)..."
cd base
git submodule update --init --recursive

echo ">>> Done."
