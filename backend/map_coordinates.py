# -*- coding: utf-8 -*-
"""Raw map coordinate data, lifted verbatim from `draw_map()` in
`Egypt_manually_drawn.py`.

These are the exact literal (lon, lat) tuples used by the original
Tkinter/matplotlib desktop GUI to draw Egypt. No values are recomputed or
approximated — they are copied 1:1 into plain Python data structures so the
Flask backend can serve them as JSON for the Flutter app's map painter.
"""

# Egypt border outline (from draw_map() in Egypt_manually_drawn.py)
egypt_outline = [
    (25.000, 22.000),  # SW Corner (Libya/Sudan tripoint)
    (28.000, 22.000),
    (31.250, 22.000),  # Lake Nasser cross
    (33.000, 22.000),
    (34.200, 22.000),
    (36.892, 22.000),  # SE Corner (Halayeb Triangle coast)
    (36.550, 22.400),  # Foul Bay western recess
    (35.500, 23.500),  # Berenice / Ras Banas peninsula head
    (35.150, 24.100),  # Marsa Alam coast
    (34.280, 26.100),  # El Qoseir waterfront
    (33.900, 27.200),  # Hurghada / El Gouna region
    (33.680, 27.800),  # Gemsa Bay recess
    (33.100, 28.500),  # Ras Gharib
    (32.650, 29.350),  # Ain Sokhna coast
    (32.550, 29.930),  # Port of Suez (Gulf of Suez Apex / Canal Entrance)
    (32.680, 29.800),  # Ayoun Musa
    (32.950, 29.100),  # Abu Zenima
    (33.150, 28.600),  # El Tor coastal plain
    (34.280, 27.760),  # Ras Muhammad (Sinai Peninsula Southern Tip)
    (34.400, 28.000),  # Sharm El Sheikh metropolis area
    (34.510, 28.500),  # Dahab coast
    (34.650, 29.050),  # Nuweiba harbor port
    (34.903, 29.530),  # Taba (Gulf of Aqaba Apex / Palestine Border Point)
    (34.260, 31.280),  # Rafah (Mediterranean coast entry point)
    (33.700, 31.100),  # El Arish
    (32.300, 31.250),  # Port Said (Suez Canal Northern exit)
    (31.814, 31.516),  # Damietta Mouth (Nile Connection)
    (30.418, 31.458),  # Rosetta Mouth (Nile Connection)
    (29.900, 31.200),  # Alexandria Metropolis
    (28.900, 31.100),  # El Alamein
    (27.200, 30.900),  # Marsa Matruh
    (25.150, 31.600),  # Sallum Gulf
    (25.000, 31.650),  # NW Corner (Border point with Libya)
    (25.000, 29.000),  # Siwa Oasis track
    (25.000, 26.000),
    (25.000, 22.000),  # Loop close back to South-West Corner
]

# Nile main channel (from draw_map())
nile_main = [
    (32.878, 23.972),  # 01. Aswan High Dam (Lake Nasser exit)
    (32.899, 24.088),  # 02. Aswan City Center
    (32.943, 24.469),  # 03. Kom Ombo East Bend
    (32.845, 24.978),  # 04. Edfu Turn
    (32.554, 25.292),  # 05. Esna Barrage Channel
    (32.561, 25.590),  # 06. South Luxor Approaching
    (32.639, 25.687),  # 07. Luxor (East Bank curve)
    (32.748, 25.823),  # 08. Shenhur East Ward Loop
    (32.723, 25.996),  # 09. Qus Channel
    (32.802, 26.115),  # 10. Hijazah S-Bend Apex
    (32.715, 26.164),  # 11. Qena (Maximum Eastern deflection point)
    (32.428, 26.134),  # 12. Dishna West Pathway
    (32.093, 26.119),  # 13. Nag Hammadi Barrage Loop
    (32.012, 26.231),  # 14. Abu Tis Turn
    (31.890, 26.368),  # 15. El Balyana
    (31.810, 26.471),  # 16. Girga Snake Curve
    (31.695, 26.557),  # 17. Sohag City Segment
    (31.503, 26.711),  # 18. Tahta Island Apex
    (31.411, 26.902),  # 19. Tima Straight
    (31.183, 27.181),  # 20. Asyut Barrage Entry
    (30.932, 27.388),  # 21. Manfalut Sharp Loop
    (30.865, 27.495),  # 22. El Qusiya
    (30.841, 27.794),  # 23. Mallawi Channel
    (30.751, 28.109),  # 24. Minya East-West Swell
    (30.778, 28.361),  # 25. Samalut Cliffs
    (30.845, 28.522),  # 26. Matai Segment
    (30.849, 28.653),  # 27. Bani Mazar
    (30.861, 28.814),  # 28. Maghagha
    (31.098, 29.074),  # 29. Beni Suef Great Loop
    (31.205, 29.341),  # 30. Wasta Corridor
    (31.255, 29.612),  # 31. El Ayat Valley
    (31.298, 29.845),  # 32. Helwan Industrial Channel
    (31.233, 30.052),  # 33. Downtown Cairo (Zamalek/Roda Islands)
    (31.281, 30.119),  # 34. Delta Barrage Apex (Splitting Point)
]

# Nile Rosetta branch (from draw_map())
nile_rosetta = [
    (31.281, 30.119),  # 34. Delta Barrage Apex (Split)
    (31.011, 30.292),  # 35. Ashmoun Reach
    (30.934, 30.419),  # 36. El Qanatir Reach
    (30.881, 30.631),  # 37. Kom Hamada Meander
    (30.742, 30.825),  # 38. Kafr El Zayat Base
    (30.691, 30.952),  # 39. Desouk Sinuous Curve
    (30.512, 31.211),  # 40. Fuwwah Channels
    (30.418, 31.458),  # 41. Rosetta Mouth (Mediterranean Outlet)
]

# Nile Damietta branch (from draw_map())
nile_damietta = [
    (31.281, 30.119),
    (31.211, 30.342),
    (31.201, 30.564),
    (31.248, 30.718),
    (31.292, 30.849),
    (31.378, 31.042),
    (31.512, 31.189),
    (31.705, 31.341),
    (31.814, 31.516),
]

# Lake Nasser polygon (from draw_map())
lake_nasser = [
    (32.90, 24.09),
    (32.75, 23.50),
    (32.60, 23.00),
    (32.50, 22.50),
    (31.90, 22.10),
    (31.80, 22.50),
    (31.95, 22.90),
    (32.40, 23.40),
    (32.57, 23.75),
    (32.90, 24.09),
]

# Important-city marker points: the cities drawn as red dots on the map,
# keyed by name -> (lon, lat). Values come from data.py `egypt_cities`
# filtered by the `important_cities` list in Egypt_manually_drawn.py.
important_cities = [
    "Cairo", "Alexandria", "Giza", "Suez", "Port Said",
    "Asyut", "Luxor", "Aswan", "Hurghada", "Arish", "Mersa Matruh",
]