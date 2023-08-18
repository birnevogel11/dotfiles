#!/usr/bin/env python3

import json
from pathlib import Path
import subprocess

LAZY_COMMIT_SHA_MACOS_14 = "c778b7aa04c484e1536ba219e71f2fd0f05302aa"


def main() -> None:
    path = Path("lazy-lock.json")
    if not path.is_file():
        print(f"{path} is not found. Skip to patch")

    content = json.loads(path.read_text())
    if content["lazy.nvim"]["commit"] == LAZY_COMMIT_SHA_MACOS_14:
        print(f"{path} is already patched with {LAZY_COMMIT_SHA_MACOS_14}")
        return

    content["lazy.nvim"]["commit"] = LAZY_COMMIT_SHA_MACOS_14

    print(f"Path {path}")
    path.write_text(json.dumps(content,indent=2), encoding="utf8")

    print("Run `Lazy restore`")
    subprocess.run(['nvim', '--headless', '+Lazy restore', '+qa'],check=True)


if __name__ == "__main__":
    main()
