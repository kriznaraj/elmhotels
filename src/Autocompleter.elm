module Autocompleter where

import Http exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import StartApp as StartApp
import Debug exposing (log)
import String
import Models exposing(..)
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Effects exposing (..)

--VIEW
autocompleter : Address Action -> Model -> Html
autocompleter address model =
    section [ class "autocompleter" ] [
        h3 [] [ text "Destination" ],
        div [] [
            input
                [ placeholder "Search for a destination"
                , autofocus True
                , type' "text"
                , value model.destinationQuery
                , on "input" targetValue
                        (\str -> Signal.message address (DestinationQueryChanged str))
                ] []
        ],
        div [ class "results" ] [
            text "this is where the results are going to go"
        ]
    ]
    
getDestinations : String -> Task Never Action
getDestinations query =
    let req = Task.map (\dests -> LoadDestinations dests) (get destinations ("api/destinations?SearchTerm=" ++ query ++ "&MaxResults=15&CultureCode=en-gb&RestrictToFlightDestinations=false&v=1.0.6978"))
    in
        Task.onError req (\err -> Task.succeed (LoadDestinations []))

destinations : Json.Decoder DestinationList
destinations =
    let dest =
        Json.object8 Destination
           ("CountryId" := Json.int)
           ("ProvinceId" := Json.int)
           ("LocationId" := Json.int)
           ("PlaceId" := Json.int)
           ("EstablishmentId" := Json.int)
           ("PloygonId" := Json.int)
           ("EstablishmentCount" := Json.int)
           ("Title" := Json.string)
    in
       "Destinations" := Json.list dest
