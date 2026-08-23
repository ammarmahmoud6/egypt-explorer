/// Image-to-place mapping.
///
/// This file maps each tourist place name to a list of asset paths.
///
/// ## Image sources
///
/// 1. **`assets/images/Egypt_Tourism_Images/`** — organized into one folder
///    per place (folder names use underscores in place of spaces/apostrophes,
///    e.g. `Pompeys_Pillar` → "Pompey's Pillar"). Only folders containing real
///    photos (descriptive filenames) are used here. Folders containing only
///    placeholder `1.png`–`5.png` files are ignored (they are not real photos).
///
/// 2. **`assets/images/`** — unlabeled WhatsApp dump, matched to places in
///    `image_place_mapping.md` at the project root.
///
/// ## Merge logic
///
/// For each place: take all images from its `Egypt_Tourism_Images/` folder
/// first, then fill remaining slots (up to 4 total) with matched images from
/// `image_place_mapping.md`. If more than 4 are available across both sources,
/// keep the first 4 and drop the rest.
///
/// ## Licensing / attribution notes (from `Egypt_Tourism_Images/sources.txt`)
///
/// The real photos in `Egypt_Tourism_Images/` were sourced from Wikimedia
/// Commons (Category: Tourism in Egypt):
/// https://commons.wikimedia.org/wiki/Category:Tourism_in_Egypt
///
/// Wikimedia Commons states that file licenses are specified on each file's
/// description page. Check the individual file page/license and attribution
/// requirements before using any image in the college project.
///
/// The WhatsApp-dump photos in `assets/images/` are unlabeled; matches were
/// made by visual inspection and are recorded in `image_place_mapping.md`.
/// Matches flagged "⚠️ uncertain" in that file should be human-verified.
library;

/// Maps a place name to a list of asset image paths (max 4 per place).
const Map<String, List<String>> placeImages = {
  // ============================================
  // Cairo and Giza
  // ============================================

  // Pyramids of Giza — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Pyramids of Giza': [
    'assets/images/Egypt_Tourism_Images/Pyramids_of_Giza/All_Gizah_Pyramids.jpg',
    'assets/images/Egypt_Tourism_Images/Pyramids_of_Giza/All_pyramids_of_Giza_panorama_2.jpg',
    'assets/images/Egypt_Tourism_Images/Pyramids_of_Giza/Giza_Pyramids_Egypt_Camels_Desert_Landscape_Photo_by_Ludovic_Delot_Bravo.jpg',
    'assets/images/Egypt_Tourism_Images/Pyramids_of_Giza/Giza,_Pyramids,_Pictures,_F._Bonfils,_photo_7_of_27_-_Archivio_fotografico_Museo_Egizio,_Turin_INV01_010.jpg',
  ],

  // Khan El Khalili — 4 WhatsApp photos (image_place_mapping.md).
  'Khan El Khalili': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM.jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (12).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (13).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.51 AM (1).jpeg',
  ],

  // Egyptian Museum — 1 WhatsApp photo (image_place_mapping.md).
  'Egyptian Museum': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (10).jpeg',
  ],

  // Citadel of Cairo — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  // NOTE: The 5th photo in this folder has Arabic characters in its filename
  // (Flickr_-_HuTect_ShOts_-_..._قلعة_صلاح_الدين_الأيوبي_ومسجد_محمد_علي_...jpg)
  // which Windows cannot bundle into the build output, so it is intentionally
  // not referenced here. The original file is left untouched on disk.
  'Citadel of Cairo': [
    'assets/images/Egypt_Tourism_Images/Citadel_of_Cairo/Cairo_Citadel_2026.jpg',
    'assets/images/Egypt_Tourism_Images/Citadel_of_Cairo/Scenes_from_Cairo_Citadel_(59407).jpg',
    'assets/images/Egypt_Tourism_Images/Citadel_of_Cairo/Scenes_from_Cairo_Citadel_(84895).jpg',
    'assets/images/Egypt_Tourism_Images/Citadel_of_Cairo/Scenes_from_Cairo_Citadel_7.jpg',
  ],

  // Al-Azhar Mosque — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Al-Azhar Mosque': [
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Mosque/Al-Azhar_Mosque_(8590203917).jpg',
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Mosque/Al-Azhar_Mosque_(R_Prazeres_2019)_DSCF4364.jpg',
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Mosque/Al-Azhar_roof_view_DSCF5477.jpg',
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Mosque/AlAzhar_Mosque.jpg',
  ],

  // Cairo Tower — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Cairo Tower': [
    'assets/images/Egypt_Tourism_Images/Cairo_Tower/Cairo_Tower_at_night_(187m._high)_(14613470840).jpg',
    'assets/images/Egypt_Tourism_Images/Cairo_Tower/Cairo_Tower_Egypt.jpg',
    'assets/images/Egypt_Tourism_Images/Cairo_Tower/Cairo,_Egypt_(1990284866).jpg',
    'assets/images/Egypt_Tourism_Images/Cairo_Tower/Cairo,_Tower_of_Cairo,_Egypt,_Oct_2004.jpg',
  ],

  // Al-Azhar Park — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Al-Azhar Park': [
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Park/Al-Azhar-Park_2016-03-28e.jpg',
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Park/Al-Azhar-Park_2016-03-28k.jpg',
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Park/Azhar_park_-_panoramio_(1).jpg',
    'assets/images/Egypt_Tourism_Images/Al_Azhar_Park/Azhar_Park.jpg',
  ],

  // Coptic Museum — 3 real photos from Wikimedia Commons
  // (Category:Coptic Museum in Cairo; see SOURCES.txt in folder).
  'Coptic Museum': [
    'assets/images_by_place/Coptic_Museum/01_Ancient Nubian Christian funerary stele dating to around the 6th to 8th century_Coptic Museum.jpg',
    'assets/images_by_place/Coptic_Museum/02_Cairo Coptic Museum.jpg',
    'assets/images_by_place/Coptic_Museum/03_CairoCoptMuseum.jpg',
  ],

  // Hanging Church — 3 real photos from Wikimedia Commons
  // (Category:Hanging Church; see SOURCES.txt in folder).
  'Hanging Church': [
    'assets/images_by_place/Hanging_Church/01__Die H_ngende Kirche in Kairo... 01.jpg',
    'assets/images_by_place/Hanging_Church/02__Die H_ngende Kirche in Kairo... 02.jpg',
    'assets/images_by_place/Hanging_Church/03__Die H_ngende Kirche in Kairo... 03.jpg',
  ],

  // Abdeen Palace — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Abdeen Palace': [
    'assets/images/Egypt_Tourism_Images/Abdeen_Palace/Abdeen_Palace_Cairo_(52886181378).jpg',
    'assets/images/Egypt_Tourism_Images/Abdeen_Palace/Abdeen_Palace_Cairo_(52891275732).jpg',
    'assets/images/Egypt_Tourism_Images/Abdeen_Palace/Abdeen_Palace_Cairo_(52892014274).jpg',
    'assets/images/Egypt_Tourism_Images/Abdeen_Palace/Abdeen_Palace.jpg',
  ],

  // Manial Palace — 4 WhatsApp photos (image_place_mapping.md).
  'Manial Palace': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.46 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.46 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (2).jpeg',
  ],

  // Baron Palace — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Baron Palace': [
    'assets/images/Egypt_Tourism_Images/Baron_Palace/Baron_Empain_Palace_Interior_79.jpg',
    'assets/images/Egypt_Tourism_Images/Baron_Palace/Baron_Empain_Palace_Interior_87.jpg',
    'assets/images/Egypt_Tourism_Images/Baron_Palace/Baron_Empain_Palace_Interior_88.jpg',
    'assets/images/Egypt_Tourism_Images/Baron_Palace/Baron_Empain_Palace_Interior_89.jpg',
  ],

  // National Museum of Egyptian Civilization — 4 WhatsApp photos (image_place_mapping.md).
  'National Museum of Egyptian Civilization': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (10).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (11).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (12).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (13).jpeg',
  ],

  // Museum of Islamic Art — 3 WhatsApp photos (image_place_mapping.md).
  'Museum of Islamic Art': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (3).jpeg',
  ],

  // ============================================
  // Alexandria
  // ============================================

  // Bibliotheca Alexandrina — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  // NOTE: `Bibliotheca_Alexandrina_(Alexandrie_bibliothèque).jpg` has an
  // accented character in its filename which Windows cannot bundle into the
  // build output, so it is intentionally not referenced here.
  'Bibliotheca Alexandrina': [
    'assets/images/Egypt_Tourism_Images/Bibliotheca_Alexandrina/Bibliotheca_Alexandrina_(2007-05-028).jpg',
    'assets/images/Egypt_Tourism_Images/Bibliotheca_Alexandrina/Bibliotheca_Alexandrina_06.jpg',
    'assets/images/Egypt_Tourism_Images/Bibliotheca_Alexandrina/Bibliotheca_Alexandrina_34.jpg',
    'assets/images/Egypt_Tourism_Images/Bibliotheca_Alexandrina/Coast_of_Alexandria,_A_view_From_Bibliotheca_Alexandrina,_Egypt.jpg',
  ],

  // Qaitbay Citadel — 3 WhatsApp photos (image_place_mapping.md).
  'Qaitbay Citadel': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (6).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (7).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (8).jpeg',
  ],

  // Montaza Palace — 3 WhatsApp photos (image_place_mapping.md).
  'Montaza Palace': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (5).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (6).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (8).jpeg',
  ],

  // Royal Jewelry Museum — 3 real photos from Wikimedia Commons
  // (Category:Royal Jewelry Museum; see SOURCES.txt in folder).
  'Royal Jewelry Museum': [
    'assets/images_by_place/Royal_Jewelry_Museum/01_Beautiful girl in a beautiful color dress at the Royal Jewelry Museum in Alexandria.jpg',
    'assets/images_by_place/Royal_Jewelry_Museum/02_Jewelery museum 10.jpg',
    'assets/images_by_place/Royal_Jewelry_Museum/03_Jewelery museum 12.jpg',
  ],

  // Catacombs of Kom El Shoqafa — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Catacombs of Kom El Shoqafa': [
    'assets/images/Egypt_Tourism_Images/Catacombs_of_Kom_El_Shoqafa/113KOM_EL_SHOQAFA_CATACOMBS.jpg',
    'assets/images/Egypt_Tourism_Images/Catacombs_of_Kom_El_Shoqafa/Catacombs_of_Kom_al_Shugafa_4.jpg',
    'assets/images/Egypt_Tourism_Images/Catacombs_of_Kom_El_Shoqafa/Catacombs_of_Kom_El_Shoqafa,_Alexandria,_Egypt.jpg',
    'assets/images/Egypt_Tourism_Images/Catacombs_of_Kom_El_Shoqafa/The_Tomb_from_Tigrane_Pasha_Street,_Catacombs_of_Kom_El_Shoqafa,_Alexandria,_Egypt.jpg',
  ],

  // Pompey's Pillar — 3 WhatsApp photos (image_place_mapping.md).
  "Pompey's Pillar": [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (10).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (11).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (9).jpeg',
  ],

  // Roman Amphitheatre — 4 WhatsApp photos (image_place_mapping.md).
  'Roman Amphitheatre': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.46 AM (5).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.46 AM (6).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM.jpeg',
  ],

  // Alexandria National Museum — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Alexandria National Museum': [
    'assets/images/Egypt_Tourism_Images/Alexandria_National_Museum/Alexandria_National_Museum10.jpg',
    'assets/images/Egypt_Tourism_Images/Alexandria_National_Museum/EWUG_visit_to_Alexandria_National_Museum,_April_2025_-_007.jpg',
    'assets/images/Egypt_Tourism_Images/Alexandria_National_Museum/EWUG_visit_to_Alexandria_National_Museum,_April_2025_-_034.jpg',
    'assets/images/Egypt_Tourism_Images/Alexandria_National_Museum/EWUG_visit_to_Alexandria_National_Museum,_April_2025_-_052.jpg',
  ],

  // Stanley Bridge — 4 WhatsApp photos (image_place_mapping.md).
  'Stanley Bridge': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.41 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.41 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.41 AM (3).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.41 AM.jpeg',
  ],

  // Alexandria Corniche — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Alexandria Corniche': [
    'assets/images/Egypt_Tourism_Images/Alexandria_Corniche/Alexandria_Corniche_,_photo_by_Hatem_Moushir_26.jpg',
    'assets/images/Egypt_Tourism_Images/Alexandria_Corniche/Alexandria_Corniche_(cropped).jpeg',
    'assets/images/Egypt_Tourism_Images/Alexandria_Corniche/Corniche_of_Alexandria.jpg',
    'assets/images/Egypt_Tourism_Images/Alexandria_Corniche/CornicheAlexandria.jpg',
  ],

  // ============================================
  // Luxor
  // ============================================

  // Luxor Temple — 4 WhatsApp photos (image_place_mapping.md).
  'Luxor Temple': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.40 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (4).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (5).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (7).jpeg',
  ],

  // Karnak Temple — 4 WhatsApp photos (image_place_mapping.md).
  'Karnak Temple': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.40 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.40 AM.jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (10).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (9).jpeg',
  ],

  // Valley of the Kings — 3 WhatsApp photos (image_place_mapping.md).
  'Valley of the Kings': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.37 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.37 AM.jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.39 AM (1).jpeg',
  ],

  // Valley of the Queens — 2 real photos from Wikimedia Commons
  // (Category:Valley of the Queens; see SOURCES.txt in folder).
  'Valley of the Queens': [
    'assets/images_by_place/Valley_of_the_Queens/01_1904 wurde das Grab von Titi im Tal der K_niginnen entdeckt. 01.jpg',
    'assets/images_by_place/Valley_of_the_Queens/02_A Kir_lyn_k V_lgye 2.jpg',
  ],

  // Colossi of Memnon — 3 real photos from Wikimedia Commons
  // (Category:Colossi of Memnon; see SOURCES.txt in folder).
  'Colossi of Memnon': [
    'assets/images_by_place/Colossi_of_Memnon/01_Karte grabst_tten theben west.png',
    'assets/images_by_place/Colossi_of_Memnon/02_2005-03-30 Urlaub Aegypten (134).jpg',
    'assets/images_by_place/Colossi_of_Memnon/03_21 Meter waren die Memnonskolosse urspr_nglich hoch. 01.jpg',
  ],

  // Hatshepsut Temple — 3 WhatsApp photos (image_place_mapping.md).
  'Hatshepsut Temple': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.38 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.38 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.38 AM.jpeg',
  ],

  // Luxor Museum — 2 WhatsApp photos (image_place_mapping.md).
  'Luxor Museum': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (11).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM (8).jpeg',
  ],

  // Medinet Habu — 3 WhatsApp photos (image_place_mapping.md).
  'Medinet Habu': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.49 AM (11).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.50 AM.jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.51 AM (2).jpeg',
  ],

  // Salah El-Din Citadel — 2 real photos from Wikimedia Commons
  // (Category:Cairo Citadel; see SOURCES.txt in folder).
  // NOTE: The first downloaded file has Arabic characters in its filename
  // which Windows cannot bundle into the build output, so it is not referenced.
  'Salah El-Din Citadel': [
    'assets/images_by_place/Salah_El-Din_Citadel/02_Kairo4.JPG',
    'assets/images_by_place/Salah_El-Din_Citadel/03_GD-EG-Citadelle du Caire-map.png',
  ],

  // ============================================
  // Aswan
  // ============================================

  // Philae Temple — 4 WhatsApp photos (image_place_mapping.md).
  'Philae Temple': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (12).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM.jpeg',
  ],

  // Nubian Museum — 1 WhatsApp photo (image_place_mapping.md).
  'Nubian Museum': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (7).jpeg',
  ],

  // Unfinished Obelisk — 1 WhatsApp photo (image_place_mapping.md).
  'Unfinished Obelisk': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.39 AM.jpeg',
  ],

  // Elephantine Island — 1 WhatsApp photo (image_place_mapping.md).
  // ⚠️ UNCERTAIN match — flagged in image_place_mapping.md; should be human-verified.
  'Elephantine Island': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (8).jpeg',
  ],

  // Aswan High Dam — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Aswan High Dam': [
    'assets/images/Egypt_Tourism_Images/Aswan_High_Dam/Aswan_High_Dam_(2007-05-706).jpg',
    'assets/images/Egypt_Tourism_Images/Aswan_High_Dam/Aswan_High_Dam_panorama_looking_downstream.jpg',
    'assets/images/Egypt_Tourism_Images/Aswan_High_Dam/Aswan_High_Dam-1.jpg',
    'assets/images/Egypt_Tourism_Images/Aswan_High_Dam/By_ovedc_-_Aswan_High_Dam_-_09.jpg',
  ],

  // Nubian Village — 4 WhatsApp photos (image_place_mapping.md).
  'Nubian Village': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (3).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (4).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (5).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (6).jpeg',
  ],

  // ============================================
  // Other Egyptian Tourist Attractions
  // ============================================

  // Abu Simbel Temples — real photos from Egypt_Tourism_Images (Wikimedia Commons).
  // NOTE: Only the 2 ASCII-safe filenames are used; the 3 `Templo_de_Ramsés_*`
  // files contain an accented character which Windows cannot bundle into the
  // build output, so they are intentionally not referenced here.
  'Abu Simbel Temples': [
    'assets/images/Egypt_Tourism_Images/Abu_Simbel_Temples/Templo_de_Nefertari,_Abu_Simbel,_Egipto,_2022-04-02,_DD_140-142_HDR.jpg',
    'assets/images/Egypt_Tourism_Images/Abu_Simbel_Temples/Templo_de_Nefertari,_Abu_Simbel,_Egipto,_2022-04-02,_DD_153.jpg',
  ],

  // Dendera Temple — 1 real photo from Wikimedia Commons
  // (Category:Temple of Hathor in Dendera; see SOURCES.txt in folder).
  'Dendera Temple': [
    'assets/images_by_place/Dendera_Temple/01_Hathor column dendera.png',
  ],

  // Abydos Temple — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Abydos Temple': [
    'assets/images/Egypt_Tourism_Images/Abydos_Temple/960px-GD-EG-Abydos001.jpeg',
    'assets/images/Egypt_Tourism_Images/Abydos_Temple/960px-Osireion_at_Abydos.jpg',
    'assets/images/Egypt_Tourism_Images/Abydos_Temple/Abydos,_Temple_of_Seti_I,_19th_century_pictures,_1870-1888,_photo_2_of_19_-_Archivio_fotografico_Museo_Egizio,_Turin_INV31_010.jpg',
    'assets/images/Egypt_Tourism_Images/Abydos_Temple/Temple_of_Seti_I,_Columns,_Abydos,_Egypt.jpg',
  ],

  // Siwa Oasis — 2 WhatsApp photos (image_place_mapping.md).
  'Siwa Oasis': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.43 AM (5).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.44 AM.jpeg',
  ],

  // Cleopatra's Spring — 3 real photos from Wikimedia Commons
  // (Commons search "Cleopatra bath Siwa"; see SOURCES.txt in folder).
  "Cleopatra's Spring": [
    'assets/images_by_place/Cleopatra_Spring/01_Cleopatra_s Pool - Spring of Juba.jpg',
    'assets/images_by_place/Cleopatra_Spring/02_Siwa Oasis_ Cleopatra_s Bath_ Egypt.jpg',
    'assets/images_by_place/Cleopatra_Spring/04_Cleopatra spring of water in Siwa.jpg',
  ],

  // White Desert — 3 real photos from Wikimedia Commons
  // (Commons search "White Desert Farafra"; see SOURCES.txt in folder).
  'White Desert': [
    'assets/images_by_place/White_Desert/01_White Desert_ Rock formations in desert landscape_ Egypt.jpg',
    'assets/images_by_place/White_Desert/02_White Desert_ Al-Farafra-Al-Bahariya road through the desert_ Egypt.jpg',
    'assets/images_by_place/White_Desert/03_White Desert_ Farafra depression_ Egypt.jpg',
  ],

  // Black Desert — 4 real photos from Egypt_Tourism_Images (Wikimedia Commons).
  'Black Desert': [
    'assets/images/Egypt_Tourism_Images/Black_Desert/Black_Desert_in_Bahariya_Oasis.jpg',
    'assets/images/Egypt_Tourism_Images/Black_Desert/Black_Desert,_Egypt_03.jpg',
    'assets/images/Egypt_Tourism_Images/Black_Desert/Black_Desert,_Egypt_10.jpg',
    'assets/images/Egypt_Tourism_Images/Black_Desert/Black-desert-egypt_cropped.jpg',
  ],

  // Wadi El Hitan — 3 real photos from Wikimedia Commons
  // (Category:Wadi El-Hitan; see SOURCES.txt in folder).
  'Wadi El Hitan': [
    'assets/images_by_place/Wadi_El_Hitan/01_Plaque in Wadi El Hitan_ Egypt.jpg',
    'assets/images_by_place/Wadi_El_Hitan/02_Canyon in valley of whales.jpg',
    'assets/images_by_place/Wadi_El_Hitan/03_Cetacea skeleton at Wadi El-Hitan_ Egypt_ 2005.jpg',
  ],

  // Ras Mohammed National Park — 3 WhatsApp photos (image_place_mapping.md).
  'Ras Mohammed National Park': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (3).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (5).jpeg',
  ],

  // Naama Bay — 2 WhatsApp photos (image_place_mapping.md).
  'Naama Bay': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (14).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (16).jpeg',
  ],

  // St. Catherine Monastery — 4 WhatsApp photos (image_place_mapping.md).
  'St. Catherine Monastery': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.43 AM (1).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.43 AM (2).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.43 AM (3).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.43 AM (4).jpeg',
  ],

  // Dahab Blue Hole — 3 real photos from Wikimedia Commons
  // (Category:Blue Hole (Red Sea); see SOURCES.txt in folder).
  'Dahab Blue Hole': [
    'assets/images_by_place/Dahab_Blue_Hole/01_Blue hole 1.jpg',
    'assets/images_by_place/Dahab_Blue_Hole/02_Blue hole 2.jpg',
    'assets/images_by_place/Dahab_Blue_Hole/03_Blue Hole 2005.JPG',
  ],

  // El Alamein Military Museum — 3 real photos from Wikimedia Commons
  // (Commons search "El Alamein museum"; see SOURCES.txt in folder).
  'El Alamein Military Museum': [
    'assets/images_by_place/El_Alamein_Military_Museum/04_Cemetery at El Alamein - Flickr - heatheronhertravels.jpg',
    'assets/images_by_place/El_Alamein_Military_Museum/06_Museum at El Alamein - Flickr - heatheronhertravels.jpg',
    'assets/images_by_place/El_Alamein_Military_Museum/08_Cemetery at El Alamein - Flickr - heatheronhertravels (2).jpg',
  ],

  // Hurghada Marina — skipped, still placeholder (no usable free photos found
  // on Wikimedia Commons after bounded retries).

  // Giftun Island — 2 WhatsApp photos (image_place_mapping.md).
  'Giftun Island': [
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.47 AM (4).jpeg',
    'assets/images/WhatsApp Image 2026-08-23 at 11.14.48 AM (15).jpeg',
  ],
};
