module Destination exposing (..)


type alias Destination =
    { countryId : Int
    , provinceId : Int
    , locationId : Int
    , placeId : Int
    , establishmentId : Int
    , polygonId : Int
    , establishmentCount : Int
    , title : String
    }


type alias DestinationList =
    List Destination
