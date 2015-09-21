module Filters where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)

replaceFilter : Criteria -> Filter -> Criteria
replaceFilter criteria filter =
    { criteria | filter <- filter }

filters : Criteria -> Address Criteria -> Html
filters criteria address = 
    let filter =
        criteria.filter
    in
        section [ class "filters"] [ 
            div [] [
                label [] [ text "Hotel Name: " ],
                input 
                    [ placeholder "Hotel Name"
                    , type' "text"
                    , value criteria.filter.hotelName
                    , on "input" targetValue 
                        (\str -> Signal.message address (replaceFilter criteria {filter|hotelName <- str}))
                    ] []
            ],
            div [] [
                label [] [ text "Stars: " ],
                div [][text "some list of stars"]
            ],
            div [] [
                label [] [ text "Minimum Rating: " ],
                input [type' "range"] []
            ],
            div [] [
                label [] [ text "Minimum Price: " ],
                input [type' "range"] []
            ]
        ] 
