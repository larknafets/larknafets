#!/usr/bin/env python3
"""Wraps long lines inside code fences at word borders, indented under the value."""
import re, sys, textwrap

width = int(sys.argv[1])
fenced = False
for line in sys.stdin.read().splitlines():
    if line.startswith("```"):
        fenced = not fenced
    elif fenced and len(line) > width:
        # value column: after the dot leader ("Key ..... "), "Status: " or a commit hash, else a small hanging indent
        m = re.match(r"(.*?\s\.+\s|\s+\w+: |[0-9a-f]{7,40} )", line)
        indent = len(m.group(1)) if m else len(line) - len(line.lstrip()) + 2
        line = "\n".join(textwrap.wrap(line, width, subsequent_indent=" " * min(indent, width // 2),
                                       break_long_words=False, break_on_hyphens=False))
    print(line)
