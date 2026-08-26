# -*- coding: utf-8 -*-
"""Visited-places state & persistence for the Egypt Explorer backend.

This module owns everything about the "visited" list:
- where it is stored on disk
- how it is loaded from / saved to that file
- the in-memory list shared by the API handlers
- the toggle helper used by the POST /api/visited endpoint

Keeping this logic here (instead of inside app.py) leaves app.py focused purely
on wiring up Flask API routes and serializing responses as JSON.
"""

import os

# The list of "visited" place names is stored in a local text file so it
# survives backend restarts. The file lives next to this script.
VISITED_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "visited.txt")


def load_visited_from_file():
    
    if not os.path.exists(VISITED_FILE):
        open(VISITED_FILE, "w", encoding="utf-8").close()
        return []
    visited = []
    with open(VISITED_FILE, "r", encoding="utf-8") as f:
        for line in f:
            name = line.strip()
            if name and name not in visited:
                visited.append(name)
    return visited


def save_visited_to_file(visited_list):
    """Overwrite visited.txt with the given list of visited places, one per line."""
    with open(VISITED_FILE, "w", encoding="utf-8") as f:
        for name in visited_list:
            f.write(name + "\n")


visited_places = load_visited_from_file()


def toggle_visited(name):
    
    if name in visited_places:
        visited_places.remove(name)
        status = "removed"
    else:
        visited_places.append(name)
        status = "added"

    # Persist immediately so the change survives a restart.
    save_visited_to_file(visited_places)

    return status