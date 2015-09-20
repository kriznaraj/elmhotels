module HotelsList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Debug exposing (log)
import Models exposing (..)

hotelCard : Hotel -> Html
hotelCard hotel =
    li [] [ text hotel.name ]

hotelList : HotelList -> Html
hotelList hotels =
    section [ class "hotel-list"] [ 
        ul [] (List.map hotelCard hotels)
    ]

