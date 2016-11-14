module Autocompleter.Cmds exposing (getDestinations)

import Task
import Http exposing (..)
import Autocompleter.Types exposing (..)
import Json.Decode as Json exposing (field)
import Destination exposing (Destination, DestinationList)


getDestinations : String -> Cmd Msg
getDestinations query =
    send LoadResults <|
        (get ("https://m.travelrepublic.co.uk/api2/destination/v2/search?SearchTerm=" ++ query ++ "&MaxResults=15&CultureCode=en-gb&RestrictToFlightDestinations=false&v=1.0.6978") destinations)


destinations : Json.Decoder DestinationList
destinations =
    let
        dest =
            Json.map8 Destination
                (field "CountryId" Json.int)
                (field "ProvinceId" Json.int)
                (field "LocationId" Json.int)
                (field "PlaceId" Json.int)
                (field "EstablishmentId" Json.int)
                (field "PolygonId" Json.int)
                (field "EstablishmentCount" Json.int)
                (field "Title" Json.string)
    in
        field "Destinations" (Json.list dest)
