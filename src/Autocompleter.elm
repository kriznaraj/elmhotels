module Autocompleter where

import Http exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import String exposing (length)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Effects exposing (..)
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
type Action = QueryChanged String
        | SelectDestination Destination
        | LoadResults DestinationList

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        QueryChanged query -> 
            ({model | query = query }, Effects.task (getDestinations query))

        SelectDestination dest ->
            ({model | selected = dest, destinations = [], query = dest.title}, Effects.none)

        LoadResults results -> 
            ({model | destinations = results}, Effects.none)

--VIEW

destination: Address Action -> Destination -> Html
destination address dest =
    li [ 
        onClick address (SelectDestination dest)] [
        span [] [ text (dest.title ++ ", (" ++ (toString dest.establishmentCount) ++ " hotels)") ]
    ]

view : Address Action -> Model -> Html
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
                        (\str -> 
                               Signal.message address (QueryChanged str) )
                ] []
        ],
        div [ class "results" ] [
            ul [] (List.map (destination address) model.destinations)
        ]
    ]
    
getDestinations : String -> Task Never Action
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
