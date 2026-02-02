#!/usr/bin/env bash
set -euo pipefail

actionlint -verbose
find -name action.yml -o -name action.yaml | xargs -r action-validator -v
