module SortBar where

import Html exposing (..)
import Html.Attributes exposing (..)

sortBar =
    section [ class "sort-bar"] [ 
        div [] [
            label [] [ text "Sort by: " ],
            select [] [
                option [] [text "Hotel Name"],
                option [] [text "Stars"],
                option [] [text "Rating"],
                option [selected True] [text "Price"]
            ]
        ],
        div [] [
            label [] [ text "Direction: " ],
            select [] [
                option [selected True] [text "Ascending"],
                option [] [text "Descending"]
            ]
        ]
    ] 
