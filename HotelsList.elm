module HotelsList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Debug exposing (log)
import Models exposing (..)

hotelList : Model -> Html
hotelList hotels =
    section [ class "hotel-list"] [ 
        ul [] (List.map (\hotel -> li [] [ text hotel.name ]) hotels)
    ]

