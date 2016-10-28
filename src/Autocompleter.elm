module Autocompleter exposing(..)

import Http exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (length)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Debug exposing (log)
import Destination exposing (Destination, DestinationList)

--MODEL
type alias Model = {
    destinations : DestinationList,
    query : String,
    selected : Destination }

initialModel : Model
initialModel = Model [] "Tenerife, Spain" tenerife

emptyDestination = Destination 0 0 0 0 0 0 0 ""

tenerife = Destination 3522 54875 0 0 0 0 0 "Tenerife, Spain"

--UPDATE
type Msg = QueryChanged String
        | SelectDestination Destination
        | LoadResults DestinationList

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        QueryChanged query -> 
            ({model | query = query }, Cmd.task (getDestinations query))

        SelectDestination dest ->
            ({model | selected = dest, destinations = [], query = dest.title}, Cmd.none)

        LoadResults results -> 
            ({model | destinations = results}, Cmd.none)

--VIEW

destination: Destination -> Html
destination dest =
    li [ 
        onClick (SelectDestination dest)] [
        span [] [ text (dest.title ++ ", (" ++ (toString dest.establishmentCount) ++ " hotels)") ]
    ]

view : Address Msg -> Model -> Html
view address model =
    section [ class "autocompleter" ] [
        h3 [] [ text "Destination" ],
        div [] [
            input
                [ placeholder "Search for a destination"
                , autofocus True
                , type' "text"
                , value model.query
                , on "input" targetValue
                        (\str -> QueryChanged str )
                ] []
        ],
        div [ class "results" ] [
            ul [] (List.map (destination address) model.destinations)
        ]
    ]
    
getDestinations : String -> Task Never Msg
getDestinations query =
    let req = Task.map (\dests -> LoadResults dests) (get destinations ("https://m.travelrepublic.co.uk/api2/destination/v2/search?SearchTerm=" ++ query ++ "&MaxResults=15&CultureCode=en-gb&RestrictToFlightDestinations=false&v=1.0.6978"))
    in
        Task.onError req (\err -> Task.succeed (LoadResults []))

destinations : Json.Decoder DestinationList
destinations =
    let dest =
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
