@hcxpApp.config ($translateProvider) ->

  # ENGLISH
  $translateProvider.translations "en",
    ADD_BAND_MODAL_TITLE: "Add Band"
    ADD_BAND_MODAL_SEARCH_FOR_BANDS: "Search for a band..."
    ADD_BAND_MODAL_NOTHING_FOUND: "No bands found"
    ADD_BAND_MODAL_NOTHING_FOUND_DESC: "Looks like the band you\'ve been searching for is not in our database. Perhaps it\'s a good idea to"
    ADD_BAND_MODAL_NOTHING_FOUND_CREATE_IT_BTN: 'create it &rarr;'

    ADD_BAND_MODAL_CANCEL_BTN: 'Cancel'
    ADD_BAND_MODAL_NEW_BAND_BTN: 'New Band'

    NEW_BAND_MODAL_TITLE: "Creating new band"
    NEW_BAND_MODAL_NAME: "Name"
    NEW_BAND_MODAL_LOCATION: "Location"
    NEW_BAND_MODAL_LOCATION_PLACEHOLDER: "City, Country"
    NEW_BAND_MODAL_CANCEL_BTN: "Cancel"
    NEW_BAND_MODAL_SAVE_BTN: "Save"

    SET_VENUE_MODAL_TITLE: "Set Venue"
    SET_VENUE_MODAL_SEARCH_PLACEHOLDER: "Search for a venue..."
    SET_VENUE_MODAL_RECENT_TITLE: "Venues you have recently used:"
    SET_VENUE_MODAL_CANCEL_BTN: "Cancel"
    SET_VENUE_MODAL_NEW_VENUE_BTN: "New Venue"

    NEW_VENUE_MODAL_TITLE: "Creating new Venue"
    NEW_VENUE_MODAL_NAME: "Name"
    NEW_VENUE_MODAL_ADDRESS: "Address"
    NEW_VENUE_MODAL_ADDRESS_PLACEHOLDER: "Street, City, Country"
    NEW_VENUE_MODAL_CANCEL_BTN: "Cancel"
    NEW_VENUE_MODAL_SAVE_BTN: "Save"

  # POLISH
  $translateProvider.translations "pl",
    ADD_BAND_MODAL_TITLE: "Dodaj zespół"
    ADD_BAND_MODAL_SEARCH_FOR_BANDS: "Szukaj zespołu..."
    ADD_BAND_MODAL_NOTHING_FOUND: "Brak wyników"
    ADD_BAND_MODAL_NOTHING_FOUND_DESC: "Wygląda na to, że zespół, którego szukano, nie znajduje się w naszej bazie. Jesteśmy przekonani, że dobrym pomysłem było by"
    ADD_BAND_MODAL_NOTHING_FOUND_CREATE_IT_BTN: 'dodanie go &rarr;'

    ADD_BAND_MODAL_CANCEL_BTN: 'Anuluj'
    ADD_BAND_MODAL_NEW_BAND_BTN: 'Nowy zespół'

    NEW_BAND_MODAL_TITLE: "Tworzenie nowego zespołu"
    NEW_BAND_MODAL_NAME: "Nazwa"
    NEW_BAND_MODAL_LOCATION: "Lokalizacja"
    NEW_BAND_MODAL_LOCATION_PLACEHOLDER: "Miasto, Państwo"
    NEW_BAND_MODAL_CANCEL_BTN: "Anuluj"
    NEW_BAND_MODAL_SAVE_BTN: "Zapisz"

    SET_VENUE_MODAL_TITLE: "Wybierz miejsce"
    SET_VENUE_MODAL_SEARCH_PLACEHOLDER: "Szukaj miejsca..."
    SET_VENUE_MODAL_RECENT_TITLE: "Ostatnio wybierane przez Ciebie miejsca:"
    SET_VENUE_MODAL_CANCEL_BTN: "Anuluj"
    SET_VENUE_MODAL_NEW_VENUE_BTN: "Nowe miejsce"

    NEW_VENUE_MODAL_TITLE: "Tworzenie nowego miejsca"
    NEW_VENUE_MODAL_NAME: "Nazwa"
    NEW_VENUE_MODAL_ADDRESS: "Adres"
    NEW_VENUE_MODAL_ADDRESS_PLACEHOLDER: "Ulica, Miasto, Państwo"
    NEW_VENUE_MODAL_CANCEL_BTN: "Anuluj"
    NEW_VENUE_MODAL_SAVE_BTN: "Zapisz"

  $translateProvider.preferredLanguage lang
  return
