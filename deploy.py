#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Deploy the Egypt Explorer backend to PythonAnywhere.

This script:
  1. Reads the PythonAnywhere API token from the PYTHONANYWHERE_API_TOKEN
     environment variable (or prompts for it when it is missing).
  2. Pushes the current git branch to `origin` so PythonAnywhere can pull the
     updated backend files.
  3. Calls the PythonAnywhere API to reload the web app so the new code is
     served immediately.

Usage:
    python deploy.py                  # uses PYTHONANYWHERE_API_TOKEN or prompts
    set PYTHONANYWHERE_API_TOKEN=...  # Windows/cmd
    $env:PYTHONANYWHERE_API_TOKEN=... # PowerShell

Requires only the Python standard library (no pip installs needed).
"""

import os
import subprocess
import sys
import urllib.request

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
API_TOKEN_ENV = "PYTHONANYWHERE_API_TOKEN"
USERNAME = "Ammar5555"
DOMAIN = "ammar5555.pythonanywhere.com"
RELOAD_URL = (
    "https://www.pythonanywhere.com/api/v0/user/"
    f"{USERNAME}/webapps/{DOMAIN}/reload/"
)
DEFAULT_REMOTE = "origin"


def get_api_token():
    """Return the token from the environment, prompting for it if missing."""
    token = os.environ.get(API_TOKEN_ENV, "").strip()
    if token:
        return token
    # Prompt only on an interactive terminal; otherwise fail with a clear message.
    if sys.stdin.isatty():
        try:
            return input(f"Enter your PythonAnywhere API token [{API_TOKEN_ENV}]: ").strip()
        except EOFError:
            pass
    raise RuntimeError(
        f"Environment variable {API_TOKEN_ENV} is not set. "
        "Set it or pass it inline, e.g.: set " + API_TOKEN_ENV + "=your_token && python deploy.py"
    )


def git_push():
    """Push the active branch to origin."""
    branch = (
        subprocess.run(
            ["git", "branch", "--show-current"],
            check=True,
            capture_output=True,
            text=True,
        )
        .stdout.strip()
    )
    if not branch:
        branch = "main"
    print(f"Pushing active branch '{branch}' to remote '{DEFAULT_REMOTE}'...")
    result = subprocess.run(
        ["git", "push", DEFAULT_REMOTE, branch],
        check=False,
    )
    if result.returncode != 0:
        print("git push reported a non-zero exit code.", file=sys.stderr)
        # Do NOT exit here: the reload can still be attempted regardless.
    return branch


def reload_webapp(token):
    """Trigger a PythonAnywhere web app reload via the REST API."""
    request = urllib.request.Request(
        RELOAD_URL,
        data=b"",
        method="POST",
        headers={"Authorization": f"Token {token}"},
    )
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            body = response.read().decode("utf-8", "replace")
            print(f"Reload request accepted (HTTP {response.status}).")
            if body.strip():
                print("Response:", body.strip())
            return True
    except urllib.error.HTTPError as err:
        detail = err.read().decode("utf-8", "replace").strip()
        print(
            f"Reload failed: HTTP {err.code} {err.reason}",
            file=sys.stderr,
        )
        if detail:
            print("Body:", detail, file=sys.stderr)
        return False
    except urllib.error.URLError as err:
        print(f"Reload failed (network): {err.reason}", file=sys.stderr)
        return False


def main():
    print("=== Egypt Explorer backend deploy ===")
    token = get_api_token()
    git_push()
    ok = reload_webapp(token)
    print("=== Deploy finished ===")
    if not ok:
        print("Web app reload was NOT confirmed — check the output above.")
        sys.exit(1)
    print("Deployment and web app reload complete.")


if __name__ == "__main__":
    main()
