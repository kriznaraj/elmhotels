module Autocompleter.Cmds exposing (getDestinations)

import Task
import Http exposing (..)
import Autocompleter.Types exposing (..)
import Json.Decode as Json exposing ((:=))
import Destination exposing (Destination, DestinationList)


getDestinations : String -> Cmd Msg
getDestinations query =
    (get destinations ("https://m.travelrepublic.co.uk/api2/destination/v2/search?SearchTerm=" ++ query ++ "&MaxResults=15&CultureCode=en-gb&RestrictToFlightDestinations=false&v=1.0.6978"))
        |> Task.perform LoadResultsFailed LoadResultsSucceeded


destinations : Json.Decoder DestinationList
destinations =
    let
        dest =
            Json.object8 Destination
                ("CountryId" := Json.int)
                ("ProvinceId" := Json.int)
                ("LocationId" := Json.int)
                ("PlaceId" := Json.int)
                ("EstablishmentId" := Json.int)
                ("PolygonId" := Json.int)
                ("EstablishmentCount" := Json.int)
                ("Title" := Json.string)
    in
        "Destinations" := Json.list dest
