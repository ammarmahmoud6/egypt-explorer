# -*- coding: utf-8 -*-
"""Flask REST backend for the Egypt Explorer Flutter app.

Thin wrapper around the original project's Python logic:
- data.py            -> tourist places / cities data
- earthquake_logic.py-> earthquake math (one_call)
- simulation.py      -> crowd simulation
- map_coordinates.py -> map geometry lifted from Egypt_manually_drawn.py

No logic is reimplemented here; endpoints just call the existing functions
and serialize the results as JSON.
"""

from flask import Flask, jsonify, request
from flask_cors import CORS

from data import places, important_places, egypt_cities, cities_info, earthquake_events
from earthquake_logic import one_call
from simulation import simulate_crowd, calculate_visitors, get_crowd_status
import map_coordinates

app = Flask(__name__)
CORS(app)  # allow cross-origin requests from Flutter web


@app.route("/")
def home():
    """Simple browsable HTML page listing all endpoints as clickable links."""
    endpoints = [
        ("/api/cities", "Cities & city info"),
        ("/api/places", "Tourist places"),
        ("/api/map-coordinates", "Map geometry (outline, Nile, lakes)"),
        (
            "/api/earthquake?lon_c=31.2&lat_c=30.0&lon2=32.5&lat1=29.9&magnitude=5.8",
            "Earthquake stats (example params filled in)",
        ),
        ("/api/crowd/simulate", "Crowd simulation over all places"),
        ("/api/crowd/visitors?capacity=500&crowd=60", "Visitors calculator (capacity=500, crowd=60)"),
        ("/api/crowd/status?crowd=60", "Crowd status for crowd=60"),
        ("/api/earthquake-events", "Earthquake event definitions (Cairo 1992 / Suez 2026)"),
    ]
    links = "".join(
        f'<li><a href="{href}">{href}</a> — {label}</li>' for href, label in endpoints
    )
    return f"""<!DOCTYPE html>
<html>
<head><title>Egypt Explorer Backend</title></head>
<body style="font-family: sans-serif; margin: 2rem;">
  <h1>Egypt Explorer Backend — running ✅</h1>
  <h2>Endpoints:</h2>
  <ul>{links}</ul>
</body>
</html>"""


def _as_json_pairs(points):
    """Convert a list of (lon, lat) tuples into JSON-friendly lists."""
    return [[p[0], p[1]] for p in points]


@app.route("/api/cities")
def api_cities():
    return jsonify({
        "egypt_cities": {name: list(coords) for name, coords in egypt_cities.items()},
        "cities_info": cities_info,
    })


@app.route("/api/places")
def api_places():
    return jsonify({
        "places": places,
        "important_places": {
            name: {"coords": list(data["coords"]), "image": data["image"]}
            for name, data in important_places.items()
        },
    })


@app.route("/api/earthquake-events")
def api_earthquake_events():
    return jsonify({"events": earthquake_events})


@app.route("/api/map-coordinates")
def api_map_coordinates():
    return jsonify({
        "egypt_outline": _as_json_pairs(map_coordinates.egypt_outline),
        "nile_main": _as_json_pairs(map_coordinates.nile_main),
        "nile_rosetta": _as_json_pairs(map_coordinates.nile_rosetta),
        "nile_damietta": _as_json_pairs(map_coordinates.nile_damietta),
        "lake_nasser": _as_json_pairs(map_coordinates.lake_nasser),
        "important_cities": map_coordinates.important_cities,
    })


@app.route("/api/earthquake")
def api_earthquake():
    try:
        lon_c = float(request.args["lon_c"])
        lat_c = float(request.args["lat_c"])
        lon2 = float(request.args["lon2"])
        lat1 = float(request.args["lat1"])
        magnitude = float(request.args["magnitude"])
    except (KeyError, ValueError):
        return jsonify({"error": "query params lon_c, lat_c, lon2, lat1, magnitude are required numbers"}), 400
    result = one_call(lon_c, lat_c, lon2, lat1, magnitude)
    return jsonify(result)


@app.route("/api/crowd/simulate")
def api_crowd_simulate():
    # Simulate on a fresh copy so the module-level `places` dict is not mutated.
    updated = simulate_crowd({name: dict(data) for name, data in places.items()})
    return jsonify(updated)


@app.route("/api/crowd/visitors")
def api_crowd_visitors():
    try:
        capacity = int(float(request.args["capacity"]))
        crowd = int(float(request.args["crowd"]))
    except (KeyError, ValueError):
        return jsonify({"error": "query params capacity and crowd are required numbers"}), 400
    return jsonify({"visitors": calculate_visitors(capacity, crowd)})


@app.route("/api/crowd/status")
def api_crowd_status():
    try:
        crowd = int(float(request.args["crowd"]))
    except (KeyError, ValueError):
        return jsonify({"error": "query param crowd is a required number"}), 400
    return jsonify({"status": get_crowd_status(crowd)})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)