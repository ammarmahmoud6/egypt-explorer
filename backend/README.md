# Egypt Explorer — Flask Backend

Serves the original Python logic (`data.py`, `earthquake_logic.py`,
`simulation.py`) and the map geometry lifted from `Egypt_manually_drawn.py`
(`map_coordinates.py`) as a REST API for the Flutter app.

## Run locally

```bash
cd backend
pip install -r requirements.txt
python app.py            # http://localhost:5000
# or: gunicorn app:app --bind 0.0.0.0:5000
```

## Endpoints

| Method | Path | Query params | Returns |
|---|---|---|---|
| GET | `/api/cities` | – | `egypt_cities`, `cities_info` |
| GET | `/api/places` | – | `places`, `important_places` |
| GET | `/api/map-coordinates` | – | Egypt outline, Nile branches, Lake Nasser, important-city list |
| GET | `/api/earthquake` | `lon_c, lat_c, lon2, lat1, magnitude` | result of `one_call()` (magnitude/distance/time gap/attenuation) |
| GET | `/api/crowd/simulate` | – | all places with simulated crowd % |
| GET | `/api/crowd/visitors` | `capacity, crowd` | `{"visitors": n}` |
| GET | `/api/crowd/status` | `crowd` | `{"status": "Low"/"Medium"/"High"}` |

CORS is enabled on all routes (`flask-cors`) so Flutter web can call it.

## Deploy to Render (free tier)

1. Push this repo to GitHub.
2. Go to https://dashboard.render.com → **New +** → **Web Service**.
3. Connect your GitHub repo.
4. Set:
   - **Root Directory**: `backend`
   - **Runtime**: Python 3
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app:app --bind 0.0.0.0:$PORT`
   - **Instance Type**: Free
5. Click **Create Web Service**. Render gives you a URL like
   `https://<your-app>.onrender.com`.

(Alternatively, commit the included `render.yaml` at the repo root and use
Render's "Blueprint" flow — it reads the same settings automatically.)

## Point the Flutter app at it

The app defaults to the deployed backend at
`http://ammar5555.pythonanywhere.com`, so `flutter run -d chrome` works out of
the box.

To point it elsewhere (e.g. a local Flask server during development), use:

```bash
flutter run --dart-define=BACKEND_URL=http://localhost:5000
```
