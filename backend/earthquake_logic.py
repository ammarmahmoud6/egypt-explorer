import math

def haversine_distance(lat_c, lon_c, lat1, lon2):
    #here distance is calculated considering the earth as a sphere
    R = 6371  # Radius of the Earth in kilometers
    lat_c_rad = math.radians(lat_c)
    lat1_rad = math.radians(lat1)
    delta_lat = lat1_rad - lat_c_rad
    delta_lon = math.radians(lon2 - lon_c)
    a = math.sin(delta_lat / 2) ** 2 + math.cos(lat_c_rad) * math.cos(lat1_rad) * math.sin(delta_lon / 2) **2
    c = 2 * math.asin(math.sqrt(a))
    distance = R * c
    return round(distance,2) 

def waves_time(distance, wave_speed):
    # Calculate the time it takes for seismic waves to travel a given distance
    if isinstance(distance, (int, float)) and isinstance(wave_speed, (int, float)) and wave_speed > 0:
        time = distance / wave_speed
    else :
        print("invalid input")
        return None
    return round(time,2)

def attenuation(distance, magnitude):
    if isinstance(distance, (int, float)) and isinstance(magnitude, (int, float)):
        try:
            i = magnitude - (math.log10(distance))
        except ValueError:
            print("Distance accepted as 0 despite the logarithm.")
            return magnitude
    else:
        print("Invalid input: distance and magnitude must be numbers.")
        return None
    return round(i,2)

def waves_time_gap(distance, p_speed = 6.5, s_speed = 3.5):
    # Calculate the time gap between two seismic waves traveling at different speeds
    ts = waves_time(distance, s_speed)
    tp = waves_time(distance, p_speed)
    if ts is None or tp is None:
        return None
    return round(ts - tp,2)

def one_call(lon_c, lat_c, lon2, lat1, magnitude):
    distance = haversine_distance(lat_c, lon_c, lat1, lon2)
    time_gap = waves_time_gap(distance)
    attenuation_value = attenuation(distance, magnitude)
    return {'magnitude': magnitude,
            'distance': distance,
            'time gap': time_gap,
            "attenuation" : attenuation_value}


