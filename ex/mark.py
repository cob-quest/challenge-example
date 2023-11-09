#!/usr/bin/env python3

import os

total_marks = 0

# q1 
if os.path.exists("/home/workshop/q1"):
    try:
        with open("/home/workshop/q1", "r") as f:
            contents = f.read()
            if contents.strip() == "/etc/homework/.hidden.txt":
                total_marks += 1
    except Exception:
        pass

# q2
if "YOUR_NAME" in os.environ:
    total_marks += 1


# q3
if os.path.exists("/home/workshop/q3"):
    try:
        with open("/home/workshop/q3", "r") as f:
            contents = f.read()
            if contents.strip() == "6":
                total_marks += 1
    except Exception:
        pass

# q4
if os.path.exists("/home/workshop/q4"):
    try:
        with open("/home/workshop/q4", "r") as f:
            contents = f.read()
            if contents.strip() == "60":
                total_marks += 1
    except Exception:
        pass

print(total_marks)
