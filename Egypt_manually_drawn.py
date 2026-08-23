from tkinter import *
from matplotlib.figure import Figure
from matplotlib.patches import Circle
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from earthquake_logic import *
from matplotlib.offsetbox import OffsetImage , AnnotationBbox
import matplotlib.image as mpimg
# ============================================
#  النافذة الرئيسية

root = Tk()
root.title("Egypt Biography")
root.geometry("900x900")

all_frames = {}
def show_frames(frame_name):
    if frame_name == 'earthquakes':
        draw_map()
    elif frame_name == 'tourism':
        draw_tourism()
    for name , frm in all_frames.items():
        frm.pack_forget()
    all_frames[frame_name].pack(fill = 'both', expand = True)
    all_frames[frame_name].update_idletasks()


# ============================================
#  welcome frame  &  its things
# ============================================
welcome_page = Frame(root, bd=4, pady = 25, padx= 25)
all_frames['welcome_page'] = welcome_page
bg_photo = PhotoImage(file='/Users/ahmed/Downloads/known.png')
bg_photo = bg_photo.zoom(3,4)
bg_label = Label(welcome_page, image=bg_photo)
bg_label.image = bg_photo
bg_label.place(x=1, y=0, relwidth=1, relheight=1)
bg_label.lower()

welcome = Label(welcome_page, text="welcome to Egypt Biography program", font = ('Arial', 32 , 'italic', 'bold'))
welcome.pack()
quakes_btn = Button(welcome_page, text= 'earthquakes', command= lambda: show_frames('earthquakes'),width=12, bg='green', fg = 'darkred', font= ('bold', 12))
quakes_btn.pack()
tourism_btn = Button(welcome_page,text= 'tourism', command = lambda: show_frames('tourism'), width = 12, bg='green', fg = 'darkred', font= ('bold', 12))
tourism_btn.pack()



# ============================================
#  tourism frame  &  its things
# ============================================
tourism = Frame(root, bd=4, pady=10, padx=10)
all_frames['tourism']= tourism 

canvas_frame = Frame(tourism)
canvas_frame.grid(row=0, column=1)
figb = Figure(figsize=(6, 5))
bx = figb.add_subplot(111)
canvas = FigureCanvasTkAgg(figb,canvas_frame)
canvas.get_tk_widget().grid(pady=10,padx=10)

selected_place_name = None

# ============================================
# egypt tourism places
from data import places, important_places
# ============================================

def image_marker(xy, image_path, x,y, zoom=0.05):
    img = mpimg.imread(image_path)
    imagebox = OffsetImage(img, zoom =zoom)
    ab = AnnotationBbox(imagebox, (x,y), frameon = False)
    xy.add_artist(ab)

def draw_tourism():
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
        (25.000, 22.000)   # Loop close back to South-West Corner
    ]
    egypt_lons = [point[0] for point in egypt_outline]
    egypt_lats = [point[1] for point in egypt_outline]
    bx.plot(egypt_lons, egypt_lats, color='black', linewidth=1)
    bx.fill(egypt_lons, egypt_lats, alpha=0.08, color='tan')

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
        (31.281, 30.119)   # 34. Delta Barrage Apex (Splitting Point)
        ]
    nile_rosetta = [
        (31.281, 30.119),  # 34. Delta Barrage Apex (Split)
        (31.011, 30.292),  # 35. Ashmoun Reach
        (30.934, 30.419),  # 36. El Qanatir Reach
        (30.881, 30.631),  # 37. Kom Hamada Meander
        (30.742, 30.825),  # 38. Kafr El Zayat Base
        (30.691, 30.952),  # 39. Desouk Sinuous Curve
        (30.512, 31.211),  # 40. Fuwwah Channels
        (30.418, 31.458)   # 41. Rosetta Mouth (Mediterranean Outlet)
        ]
    nile_damietta = [
        (31.281, 30.119),  
        (31.211, 30.342),  
        (31.201, 30.564),  
        (31.248, 30.718), 
        (31.292, 30.849),  
        (31.378, 31.042),  
        (31.512, 31.189),  
        (31.705, 31.341),  
        (31.814, 31.516)   
        ]
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
        (32.90, 24.09)
        ]
    for segment in [nile_main, nile_rosetta, nile_damietta]:
        seg_lons = [p[0] for p in segment]
        seg_lats = [p[1] for p in segment]
        bx.plot(seg_lons, seg_lats, color='steelblue', linewidth=1.5)
    
    lake_lons = [p[0] for p in lake_nasser]
    lake_lats = [p[1] for p in lake_nasser]
    bx.plot(lake_lons, lake_lats, color='dodgerblue', linewidth=2)
    bx.fill(lake_lons, lake_lats, alpha=0.3, color='dodgerblue') 

    for place, data in important_places.items():
        lat, lon = data['coords']
        bx.scatter(lon, lat)
        # image_marker(bx, data['image'], lon,lat, zoom = 0.03)
    canvas.draw()

# ============================================
# tourism places list
places_frame = Frame(tourism)
places_frame.grid(row=0, column=0)

# search bar on the cities list
search_p = Entry(places_frame, width = 19)
search_p.pack(anchor = 'w', side= TOP) 

places_list = Listbox(places_frame)
places_list.pack(side=LEFT)

scroll_places = Scrollbar(places_frame)
scroll_places.pack(side=RIGHT, fill = Y)

for place in places.keys() :
    places_list.insert(END, place)

places_list.config(yscrollcommand = scroll_places.set)

# ============================================
# function important to search bar 
def searchp(event):
    user_input = search_p.get()
    places_list.delete(0, END)
    for i in places.keys() :
        if user_input.title() in i :
            places_list.insert(END, i)

search_p.bind('<KeyRelease>', searchp)
# ============================================
gallery_photos = []
gallery_index = 0

overlay_label = Label(canvas_frame, bg="black")

def show_gallery(place_name):
    global gallery_index, gallery_photos
    gallery_index = 0
    
    data = places.get(place_name)
    if not data:
        return
    
    paths = [PhotoImage(file=p) for p in [data['image']]]
    gallery_photos = [PhotoImage(file=p) for p in paths]
    
    overlay_label.config(image=gallery_photos[0])
    overlay_label.image = gallery_photos[0]
    overlay_label.place(x=0, y=0, relwidth=1, relheight=1)
    overlay_label.lift()

def next_image(event=None):
    global gallery_index
    if not gallery_photos:
        return
    gallery_index = (gallery_index + 1) % len(gallery_photos)
    overlay_label.config(image=gallery_photos[gallery_index])
    overlay_label.image = gallery_photos[gallery_index]

overlay_label.bind("<ButtonRelease-1>", next_image)
# ============================================
# mouse selection to place in list
def place_mouse_selection(event):
    global selected_place_name

    select = places_list.curselection()       #curselection returns a tuple of the selection
    if select:
        selected_place_name = places_list.get(select[0])   #get returns the name of 'selected' 
        show_gallery(selected_place_name)
        draw_tourism()

# place selection from list box 
places_list.bind('<ButtonRelease-1>', place_mouse_selection)

tourism_back = Button(tourism, text='Back', command= lambda: show_frames('welcome_page'),font = ('Arial', 12 , 'italic', 'bold'))
tourism_back.grid()







# ============================================
#  earthquake frame  &  its things 
# ============================================
earthquake = Frame(root, bd=4, pady=10, padx=10)
all_frames['earthquakes'] = earthquake
big_frame = Frame(earthquake, bd=4, pady=5)
big_frame.pack(anchor='w')
frame = Frame(big_frame, border= 2,bg='lightyellow', )
frame.grid(row=0, column=0, pady=10,padx=10)

# global variables needed for clean code
emagnitude ={'cairo' : 5.8 ,
            'suez' : 5.6}
info = {'cairo': 'On October 12, 1992, at 3:09 PM local time, a 5.8 magnitude earthquake struck with an epicenter located near Dahshur (Giza), about 35 km south of downtown Cairo.Why it was so deadly: Despite its moderate size, it became Egypt\'s deadliest modern seismic event, claiming over 560 lives, injuring more than 12,000 people, and leaving half a million homeless.The Cause: The earthquake occurred at a focal centroid depth of around 22~23 km. The high level of destruction was primarily caused by the shallow depth, the vulnerability of old adobe houses in poor neighborhoods, poorly maintained inner-city high-rises, and the unique soft soil of the Nile Valley, which amplified the seismic waves.Historic Impact: It caused notable damage to landmark historic Islamic monuments and mosques in Old Cairo, and even dislodged a large stone block from the Great Pyramid of Giza.',
        'suez' : 'In the early morning hours of August 3, 2026, at approximately 3:00 AM local time, a 5.5 to 5.6 magnitude earthquake shook northern Egypt.The Location: The epicenter was located about 38 to 41 kilometers north-northeast of Suez (Latitude: 30.19° N, Longitude: 32.61° E). Because it struck while most people were asleep, the shaking caused a sudden wave of collective alarm and woke up residents across Cairo, Suez, Ismailia, Port Said, and Alexandria. It was even felt beyond Egypt\'s borders in Jordan, Israel, Palestine, and Lebanon.The Cause: The National Research Institute of Astronomy and Geophysics (NRIAG) reported that the tremor struck at a very shallow depth of 10 kilometers. It was triggered by localized crustal extension stretching along the northern Gulf of Suez and Red Sea rift fault lines.The Impact: Unlike 1992, no casualties or significant structural disasters were reported. Only minor structural incidents occurred, such as a collapsed balcony in Suez and a partial wall crack in Cairo. Modern building regulations and better reinforcement safety protocols implemented after 1992 successfully shielded the core populated zones from devastation.'}

selected_city_name = None
zoomy = None
zoomx = None
radio = StringVar(value="")

important_cities = [
    "Cairo", "Alexandria","Giza", "Suez", "Port Said", 
    "Asyut", "Luxor", "Aswan", "Hurghada", "Arish", "Mersa Matruh"
]

#cities coordinates 
from data import egypt_cities
from data import cities_info
# ============================================
# canvas (matplotlib inside tkinter)

figa = Figure(figsize=(6, 5))
ax = figa.add_subplot(111)

canvas = FigureCanvasTkAgg(figa,big_frame)
canvas.get_tk_widget().grid(row=0,column=1,pady = 10,padx=10)

# ============================================
# دالة رسم الخريطة 
# ============================================
def draw_map():
    global selected_city_name
    ax.clear() 

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
    (25.000, 22.000)   # Loop close back to South-West Corner
]
    egypt_lons = [point[0] for point in egypt_outline]
    egypt_lats = [point[1] for point in egypt_outline]
    ax.plot(egypt_lons, egypt_lats, color='black', linewidth=1)
    ax.fill(egypt_lons, egypt_lats, alpha=0.08, color='tan')

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
    (31.281, 30.119)   # 34. Delta Barrage Apex (Splitting Point)
    ]
    nile_rosetta = [
    (31.281, 30.119),  # 34. Delta Barrage Apex (Split)
    (31.011, 30.292),  # 35. Ashmoun Reach
    (30.934, 30.419),  # 36. El Qanatir Reach
    (30.881, 30.631),  # 37. Kom Hamada Meander
    (30.742, 30.825),  # 38. Kafr El Zayat Base
    (30.691, 30.952),  # 39. Desouk Sinuous Curve
    (30.512, 31.211),  # 40. Fuwwah Channels
    (30.418, 31.458)   # 41. Rosetta Mouth (Mediterranean Outlet)
    ]
    nile_damietta = [
    (31.281, 30.119),  
    (31.211, 30.342),  
    (31.201, 30.564),  
    (31.248, 30.718), 
    (31.292, 30.849),  
    (31.378, 31.042),  
    (31.512, 31.189),  
    (31.705, 31.341),  
    (31.814, 31.516)   
    ]
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
        (32.90, 24.09)
        ]
    for segment in [nile_main, nile_rosetta, nile_damietta]:
        seg_lons = [p[0] for p in segment]
        seg_lats = [p[1] for p in segment]
        ax.plot(seg_lons, seg_lats, color='steelblue', linewidth=1.5)
    lake_lons = [p[0] for p in lake_nasser]
    lake_lats = [p[1] for p in lake_nasser]
    ax.plot(lake_lons, lake_lats, color='dodgerblue', linewidth=2)
    ax.fill(lake_lons, lake_lats, alpha=0.3, color='dodgerblue')    
    # ============================================
    #drawing the big cities only 
    for cities, cities_coordinates in egypt_cities.items():
        if cities not in important_cities :
            continue 
        v_alignment = 0.26
        h_alignment = -0.15
        if cities in ['Kafr El Sheikh' ,'Suez']:
            v_alignment = 0.26
            h_alignment = -0.15
        if cities in ['Arish' ,'Alexandria']:
            v_alignment = -0.26
            h_alignment = -0.16
        if cities == 'Damietta':
            v_alignment = -0.26
        ax.scatter( cities_coordinates[0],  
                    cities_coordinates[1],
                    color ='red', zorder = 4)
        ax.text(cities_coordinates[0] + h_alignment,
                cities_coordinates[1] + v_alignment,
                cities,
                fontsize = 7, color ='black', style ='oblique', va = 'center')

    # ============================================
    # drawing the selected city from the list
    if selected_city_name in egypt_cities:
        city_coords = egypt_cities[selected_city_name]
        v_alignment = 0.26
        h_alignment = -0.15
        if selected_city_name in ['Kafr El Sheikh' ,'Suez']:
            v_alignment = 0.26
            h_alignment = -0.15
        if selected_city_name in ['Arish' ,'Alexandria']:
            v_alignment = -0.26
            h_alignment = -0.16
        if selected_city_name == 'Damietta':
            v_alignment = -0.26
        ax.scatter( city_coords[0],
                    city_coords[1], 
                    color='blue', zorder=5)
        ax.text(city_coords[0] + h_alignment,
                city_coords[1] + v_alignment, 
                selected_city_name,
                fontsize=7, color='blue', style='oblique', va='center')
    # zoom in to the selected city
    if zoomx is not None and zoomy is not None:
        ax.set_xlim(zoomx)
        ax.set_ylim(zoomy)
        
    # drawing the big red circle 
    if radio.get() == 'cairo':
        red_circle = Circle((egypt_cities['Cairo']),radius=1.55, color='red', alpha = 0.25)
        ax.add_patch(red_circle)
        
    elif radio.get() == 'suez':
        red_circle = Circle((egypt_cities['Suez']),radius=1.55, color='red', alpha = 0.25)
        ax.add_patch(red_circle)
    else :
        pass

    ax.set_xlabel("خطوط الطول")
    ax.set_ylabel("خطوط العرض")
    canvas.draw() 





# ============================================
#earthquake choosing

l = Label(frame, text='Select an Option', font=("Arial", 10, "bold"))
earthquake_info = Label(earthquake ,font=('Arial',14))

l.pack(pady=10)
def show_data():
    global selected_city_name,zoomx,zoomy       # i added them for future if i wanted to zoom out after choosing another earthquake    
    if radio.get() == 'cairo':
        l.config(text='you selected :' + radio.get(),fg = 'lightyellow', bg = 'green')
        earthquake_info.config(text='I was near to surface so i killed many civilians 🥀')
        earthquake_info.pack(anchor='w')
        draw_map()
        update_info()
    elif radio.get() == 'suez':
        l.config(text='you selected :' + radio.get(),fg = 'lightyellow', bg = 'green')
        earthquake_info.config(text= 'I was deep in earth that i didn\'t kill anyone')
        earthquake_info.pack(anchor='w')
        draw_map()
        update_info()
    else :
        l.config(text= 'Select an Option',font=("Arial", 10, "bold"))
        earthquake_info.config(text= 'welcome to my program')
        earthquake_info.pack(anchor='w')
        selected_city_name = None
        zoomy = None
        zoomx = None
        draw_map()
        

# two radio buttons for earthquake selection 
radio = StringVar()      
btn1 = Radiobutton(frame, text='Cairo 1992', variable=radio, value='cairo', command=show_data, bg='green', fg='lightyellow')
btn1.pack()

btn2 = Radiobutton(frame, text='Suez 2026', variable=radio, value='suez', command=show_data , bg='green', fg='lightyellow')
btn2.pack(pady=10)

# ============================================
# button to reset radio selection
def clear():
    global selected_city_name,zoomx,zoomy
    radio.set("")

    l.config(text= 'Select an Option',font=("Arial", 10, "bold"))
    l.pack()
    earthquake_info.config(text= ' ')
    earthquake_info.pack(anchor='w')
    city_info.config(text='Select a city to read its profile', font=('Arial', 15, 'italic'), wraplength=400, justify='left')
    city_info.pack(anchor='w')
    selected_city_name = None
    zoomy = None
    zoomx = None
    draw_map()
    update_info()

reset_btn = Button(earthquake, text ="Reset", command=clear, bg='lightyellow', fg='darkgreen', width = 13, font = ('Arial', 12 , 'italic', 'bold'))
reset_btn.pack(anchor='center')
# back button 
quakes_back = Button(earthquake, text='Back', command=lambda: show_frames('welcome_page'),fg='darkgreen', bg='lightyellow', width = 13, font = ('Arial', 12 , 'italic', 'bold'))
quakes_back.pack()

# ============================================
# info about the city in general and in the earthquake
city_info = Label(earthquake, text='Select a city to read its profile', font=('Arial', 15, 'italic'), wraplength=800, justify='left')
city_info.pack(anchor='w',padx = 7 ,pady = 10)
def update_info():
    if selected_city_name in cities_info and radio.get() not in ['cairo', 'suez']:
        city_info.config(text=cities_info[selected_city_name], font=('Arial',15,'italic'), wraplength=800, justify='left') #paragaph about the city
        city_info.pack(anchor='w')
    elif selected_city_name in cities_info and radio.get() in ['cairo', 'suez']:
        analysis = one_call(egypt_cities[radio.get().title()][0],egypt_cities[radio.get().title()][1],egypt_cities[selected_city_name][0],egypt_cities[selected_city_name][1],emagnitude[radio.get()])
        city_info.config(text=f"""important info about the city in the earhquake:
        magnitude at the earthquake center {analysis['magnitude']}
        distance between city and center: {analysis['distance']} km
        time between earth shake and the destroying wave: {analysis['time gap']} seconds
        its magnitude when it reached the city: {analysis['attenuation']}""", font=('Arial',15,'italic'), wraplength=800, justify='left')#############################################
        city_info.pack(anchor='w')
    elif selected_city_name not in cities_info and radio.get() in ['cairo', 'suez']:
        city_info.config(text=f"{info[radio.get()]}", font=('Arial',15,'italic'), wraplength=800, justify='left')
        city_info.pack(anchor='w')
    else:
        city_info.config(text = ' ')

# ============================================
# mouse selection to city in list
def city_mouse_selection(event):
    global selected_city_name, zoomx, zoomy

    selected = cities_list.curselection()       #curselection returns a tuple of the selection
    if selected:
        selected_city_name = cities_list.get(selected[0])   #get returns the name of 'selected' 

        zoomx= (egypt_cities[selected_city_name][0]-3, egypt_cities[selected_city_name][0]+3)
        zoomy= (egypt_cities[selected_city_name][1]-3, egypt_cities[selected_city_name][1]+3)
        draw_map()
        update_info()
    

# ============================================
# function important to search bar 
def search(event):
    user_input = search_bar.get()
    cities_list.delete(0, END)
    for i in egypt_cities.keys() :
        if user_input.title() in i :
            cities_list.insert(END, i)

# search bar on the cities list
search_bar = Entry(frame, width = 19)
search_bar.pack(anchor = 'w', )
search_bar.bind('<KeyRelease>', search)

# ============================================
#cities list 
list_frame = Frame(frame)
list_frame.pack()

cities_list = Listbox(list_frame)
cities_list.pack(side=LEFT)

scroll_cities = Scrollbar(list_frame)
scroll_cities.pack(side=RIGHT, fill = Y)

for city in egypt_cities.keys() :
    cities_list.insert(END, city)

cities_list.config(yscrollcommand = scroll_cities.set)

# ============================================
# city selection from list box 
cities_list.bind('<ButtonRelease-1>', city_mouse_selection)

# ============================================
# ============================================

show_frames('welcome_page')
root.mainloop()