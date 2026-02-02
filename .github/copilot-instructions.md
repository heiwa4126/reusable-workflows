# whoruv Project Rules

## Project Overview

- This is a Python package that displays Python version, executable path, and script path when run with Astral's uv
- Package name: whoruv
- Target Python version: >=3.10
- Build system: uv_build
- License: MIT
- Command line interface with argparse for --help and --version options

## Code Style

- Use dataclasses for structured data
- Keep functions minimal and focused
- Follow Python naming conventions
- Use type hints where appropriate
- Use argparse for command line interface
- Main entry point in __main__.py with argument parsing

## Testing

- Test files should be named `*_test.py`
- Use pytest for testing
- Test both functionality and data structure validation

## Dependencies

- Minimal dependencies - use standard library when possible
- Development dependencies include: mypy, pytest, ruff, poethepoet

## File Structure

- Source code in `src/whoruv/`
- Tests alongside source files with `_test.py` suffix
- Exclude test files from wheel distribution
