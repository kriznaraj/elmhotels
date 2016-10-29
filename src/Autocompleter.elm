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
        | LoadResultsSucceeded DestinationList
        | LoadResultsFailed Http.Error

--we need to add a root Cmd as a third element in the tuple here so that we can trigger the hotel load
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        QueryChanged query -> 
            ({model | query = query }, getDestinations query)

        SelectDestination dest ->
            ({model | selected = dest, destinations = [], query = dest.title}, Cmd.none)

        LoadResultsSucceeded results ->
            ({model | destinations = results}, Cmd.none)

        LoadResultsFailed err ->
            let
                e = log "Autocompleter lookup failed: " err
            in
                (model, Cmd.none)

--VIEW

destination: Destination -> Html Msg
destination dest =
    li [ 
        onClick (SelectDestination dest)] [
        span [] [ text (dest.title ++ ", (" ++ (toString dest.establishmentCount) ++ " hotels)") ]
    ]

view : Model -> Html Msg
view model =
    section [ class "autocompleter" ] [
        h3 [] [ text "Destination" ],
        div [] [
            input
                [ placeholder "Search for a destination"
                , autofocus True
                , type' "text"
                , value model.query
                , onInput (\str -> QueryChanged str)
                ] []
        ],
        div [ class "results" ] [
            ul [] (List.map destination model.destinations)
        ]
    ]
    
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
