module Filters where

import Html exposing (..)
import Html.Attributes exposing (..)

filters = 
    section [ class "filters"] [ 
        div [] [
            label [] [ text "Hotel Name: " ],
            input [type' "text"] []
        ],
        hr [] [],
        div [] [
            label [] [ text "Stars: " ]
        ],
        hr [] [],
        div [] [
            label [] [ text "Minimum Rating: " ],
            input [type' "range"] []
        ],
        hr [] [],
        div [] [
            label [] [ text "Minimum Price: " ],
            input [type' "range"] []
        ],
        hr [][],
        button [] [ text "Search"]
    ] 
