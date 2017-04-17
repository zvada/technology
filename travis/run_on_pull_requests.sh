#!/bin/bash

echo "Verifying mkdocs build"
PYTHONPATH=src/ mkdocs build -v
