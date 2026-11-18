#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/../../../scripts/caching.sh"
exec axshell-core screentime track
