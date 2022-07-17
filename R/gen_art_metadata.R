gen_art_metadata <- function() {
  # create data
  art_dict <- tibble::tribble(
    ~variable, ~type, ~description, ~example,
    "department", "character", "Indicates the MET's curatorial department responsible for the artwork", "Egyptian Art",
    "object_number", "character", "Identifying string for each artwork", "2009.300.2841",
    "is_highlight", "logical", "When 'TRUE', indicates a popular and important artwork in the collection", "TRUE | FALSE",
    "is_timeline_work", "logical", "Whether the object is on the Timeline of Art History website", "TRUE | FALSE",
    "is_public_domain", "logical", "When 'TRUE', indicates an artwork in the Public Domain", "TRUE | FALSE",
    "object_id", "numeric", "Identifying number for each artwork (unique)", "437133",
    "gallery_number", "numeric", "Gallery number (where available)", "131",
    "accession_year", "numeric", "Year the artwork was acquired", "1921",
    "object_name", "character", "Describes the physical type of the object", "Painting",
    "title", "character", "Title, identifying phrase, or name given to a work of art", "Wheat Field with Cypresses",
    "culture", "character", "Information about the culture, or people from which the object was created (where available)", "British",
    "period", "character", "time or time period when an object was created (where available)", "Middle Bronze Age",
    "dynasty", "character", "Dynasty (a succession of rulers of the same line or family) under which an object was created (where available)", "Kingdom of Benin",
    "reign", "character", "Reign of a monarch or ruler under which an object was created (where available)", "Louis XVI",
    "portfolio", "character", "A set of works created as a group or published as a series (where available)", "Birds of America",
    "constituent_id", "numeric", "Indentifying number for constituent associated with the object (where available)", "161708",
    "artist_role", "character", "Role of the artist related to the type of artwork or object that was created (where available)", "Designer for Dress",
    "artist_prefix", "character", "Describes the extent of creation or describes an attribution qualifier to the information given in the artist_role field (where available)", "Possibly by",
    "artist_display_name", "character", "Artist name in the correct order for display (where available)", "Vincent van Gogh",
    "artist_display_bio", "character", "Nationality and life dates of an artist, also includes birth and death city when known (where available)", "Dutch, Zundert 1853–1890 Auvers-sur-Oise",
    "artist_suffix", "character", "Used to record complex information that qualifies the role of a constituent, e.g. extent of participation by the Constituent (verso only, and followers) (where available)", "verso only",
    "artist_alpha_sort", "character", "Used to sort artist names alphabetically. Last Name, First Name, Middle Name, Suffix, and Honorific fields, in that order (where available)", "Gogh, Vincent van",
    "artist_nationality", "character", "National, geopolitical, cultural, or ethnic origins or affiliation of the creator or institution that made the artwork (where available)", "Spanish",
    "artist_begin_date", "character", "Year the artist was born (where available)", "1840",
    "artist_end_date", "character", "Year the artist died (where available)", "1926",
    "artist_gender", "character", "Gender of the artist (where available)", "female",
    "artist_ulan_url", "character", "Union List of Artist Names (ULAN) URL for the artist (where available)", "https://vocab.getty.edu/page/ulan/500003169",
    "artist_wikidata_url", "character", "Wikidata URL for the artist (where available)", "https://www.wikidata.org/wiki/Q694774",
    "object_date", "character", "Year, a span of years, or a phrase that describes the specific or approximate date when an artwork was designed or created (where available)", "1865-67",
    "object_begin_date", "numeric", "Machine readable date indicating the year the artwork was started to be created (where available)", "1867",
    "object_end_date", "numeric", "Machine readable date indicating the year the artwork was completed (may be the same year or different year than the object_begin_date)", "1888",
    "medium", "character", "Refers to the materials that were used to create the artwork", "Oil on canvas",
    "dimensions", "character", "Size of the artwork or object (where available)", "16 x 20 in. (40.6 x 50.8 cm)",
    "credit_line", "character", "Text acknowledging the source or origin of the artwork and the year the object was acquired by the museum", "Robert Lehman Collection, 1975",
    "geography_type", "character", "Qualifying information that describes the relationship of the place catalogued in the geography fields to the object that is being catalogued (where available)", "Made in",
    "city", "character", "City where the artwork was created (where available)", "New York",
    "state", "character", "State or province where the artwork was created, may sometimes overlap with county (where available)", "Derbyshire",
    "county", "character", "County where the artwork was created, may sometimes overlap with state (where available)", "Orange County",
    "country", "character", "Country where the artwork was created or found (where available)", "China",
    "region", "character", "Geographic location more specific than country, but more specific than subregion, where the artwork was created or found (frequently missing)", "Midwest",
    "subregion", "character", "Geographic location more specific than Region, but less specific than locale, where the artwork was created or found (frequently missing)", "Valley of the Kings",
    "locale", "character", "Geographic location more specific than subregion, but more specific than locus, where the artwork was found (frequently missing)", "Tomb of Perneb",
    "locus", "character", "Geographic location that is less specific than locale, but more specific than excavation, where the artwork was found (frequently missing)", "Pit 477",
    "excavation", "character", "The name of an excavation; the excavation field usually includes dates of excavation (where available)", "Carnarvon excavations, 1912",
    "river", "character", "River is a natural watercourse, usually freshwater, flowing toward an ocean, a lake, a sea or another river related to the origins of an artwork (frequently missing)", "Nile River",
    "classification", "character", "General term describing the artwork type (where available)", "Ceramics",
    "rights_and_reproduction", "character", "Credit line for artworks still under copyright (where available)", "© 2018 Estate of Pablo Picasso / Artists Rights Society (ARS), New York",
    "link_resource", "character", "URL to object page on https://metmuseum.org", "https://www.metmuseum.org/art/collection/search/547802",
    "object_wikidata_url", "character", "Wikidata URL for the object (where available)", "https://www.wikidata.org/wiki/Q432253",
    "metadata_date", "character", "Data metadata was last updated (where available)", "2018-10-17T10:24:43.197Z",
    "repository", "character", "Organization where object resides", "Metropolitan Museum of Art, New York, NY",
    "tags", "character", "An array of subject keyword tags associated with the object, separated by '|' (where available)", "Dresses|Flowers",
    "tags_aat_url", "character", "Art & Architecture Thesaurus (AAT) URL for the object (where available)", "http://vocab.getty.edu/page/aat/300056508",
    "tags_wikidata_url", "character", "Wikidata URL for the object tag(s) (where available)", "https://www.wikidata.org/wiki/Q162150",
    "image_url", "character", "URL to object image", "https://images.metmuseum.org/CRDImages/ci/original/60.87.51_CP4.jpg",
    "image_file", "character", "File name of object image found in image_url", "60.87.51_CP4.jpg"
  ) %>%
    dplyr::arrange(variable)
  
  
  crop_dict <- tibble::tribble(
    ~variable, ~type, ~description, ~example,
    "image_file", "character", "File name of object image found in image_url", "60.87.51_CP4.jpg",
    "image_gs_path", "character", "URL to object image stored in Google Storage", "gs://shinyworkshop-images-bucket/raw_img/11.215.266.jpg",
    "x", "numeric", "X value of crop bounding box coordinate. If missing, assumes value is 0", "290",
    "y", "numeric", "Y value of crop bounding box coordinate. If missing, assumes value is 0", "1280",
    "confidence", "numeric", "Confidence score of bounding box. Values range between 0 (no confidence) to 1 (high confidence).", "0.314",
    "importanceFraction", "numeric", "Importance fraction of the bounding box region with respect to orginal image. Values between 0-1.", "1"
  ) %>%
    dplyr::arrange(variable)
  
  image_annotation_dict <- tibble::tribble(
    ~variable, ~type, ~description, ~example,
    "image_file", "character", "File name of object image found in image_url", "60.87.51_CP4.jpg",
    "image_gs_path", "character", "URL to object image stored in Google Storage", "gs://shinyworkshop-images-bucket/raw_img/11.215.266.jpg",
    "red", "numeric", "Integer of the red color intensity. Value between 0-255", "123",
    "green", "numeric", "Integer of the green color intensity. Value between 0-255", "158",
    "blue", "numeric", "Integer of the blue color intensity. Value between 0-255", "85",
    "pixelFraction", "numeric", "Fraction of pixels occupied by the color values. Value between 0-1", "0.0155",
    "hexcode", "character", "color hex code corresponding to the RGB intensity from the red, green, and blue values", "#7B7B56",
    "color_name", "character", "string of color name in R's built-in color palette, if available", "red"
  ) %>%
    dplyr::arrange(variable)
  
  label_annotation_dict <- tibble::tribble(
    ~variable, ~type, ~description, ~example,
    "image_file", "character", "File name of object image found in image_url", "60.87.51_CP4.jpg",
    "image_gs_path", "character", "URL to object image stored in Google Storage", "gs://shinyworkshop-images-bucket/raw_img/11.215.266.jpg",
    "mid", "character", "Machine-generated identifier (MID) corresponding to the entity's Google Knowledge Graph entry", "/m/0h8n22v",
    "description", "character", "Label description", "Serveware",
    "score", "numeric", "Confidence score for label. Values range between 0 (no confidence) to 1 (high confidence).", "0.868",
    "topicality", "numeric", "The relevancy of the image content annotation (ICA) label to the image. It measures how important/central a label is to the overall context of a page. Values range from 0-1.", "0.823"
  ) %>%
    dplyr::arrange(variable)
  
  object_annotation_dict <- tibble::tribble(
    ~variable, ~type, ~description, ~example,
    "image_file", "character", "File name of object image found in image_url", "60.87.51_CP4.jpg",
    "image_gs_path", "character", "URL to object image stored in Google Storage", "gs://shinyworkshop-images-bucket/raw_img/11.215.266.jpg",
    "mid", "character", "Machine-generated identifier (MID) corresponding to the object's Google Knowledge Graph entry", "/m/0h8n22v",
    "name", "character", "Name of object as determined by the Vision API", "Mirror",
    "x", "numeric", "X value (normalized) of object coordinate.", "0.28",
    "y", "numeric", "Y value (normalized) of object coordinate.", "0.0653",
    "score", "numeric", "Confidence score for object. Values range between 0 (no confidence) to 1 (high confidence).", "0.632"
  ) %>%
    dplyr::arrange(variable)
  
  # assemble entire contents as list
  dict_list <- list(
    art_dict = art_dict,
    crop_dict = crop_dict,
    image_annotation_dict = image_annotation_dict,
    label_annotation_dict = label_annotation_dict,
    object_annotation_dict = object_annotation_dict
  )
  
  return(dict_list)
}