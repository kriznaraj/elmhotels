module HotelsList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Debug exposing (log)

hotelList hotels =
    section [ class "hotel-list"] [ text (toString (List.length hotels))]
