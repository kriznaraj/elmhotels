module Api exposing (..)

import Json.Decode as Json exposing (field)
import Json.Encode exposing (Value, encode, int, object, string)
import Task exposing (..)
import Http exposing (..)
import String exposing (append, fromChar, foldl)
import Destination exposing (Destination, DestinationList)
import Models exposing (..)


body : Destination -> Body
body dest =
    object
        [ ("CultureCode", string "en-gb")
        , ("DomainId", int 1)
        , ("TradingGroupId", int 1)
        , ("CurrencyCode", string "GBP")
        , ("Paging", paging)
        , ("SortCriterion", int 1)
        , ("Destination", encodeDestination dest) ]
        |> jsonBody

paging: Value
paging =
    object
        [ ("PageIndex", int 0)
        , ("PageSize", int 1000)
        ]

encodeDestination : Destination -> Value
encodeDestination dest =
    object
        [ ("CountryId", int dest.countryId)
        , ("ProvinceId", int dest.provinceId)
        , ("LocationId", int dest.locationId)
        , ("PlaceId", int dest.placeId)
        , ("EstablishmentId", int dest.establishmentId)
        , ("PolygonId", int dest.polygonId)
        , ("PageStrand", int 1)
        ]


getHotels : Destination -> Cmd Msg
getHotels dest =
    Http.send HotelsLoad <|
        Http.post "api/hotels" (body dest) hotelsDecoder


hotelsDecoder : Json.Decoder HotelList
hotelsDecoder =
    let
        hotel =
            Json.map6 Hotel
                ((field "Name" Json.string)
                    |> Json.maybe
                    |> Json.map (Maybe.withDefault "No Name")
                )
                (Json.succeed "")
                (Json.map estabIdToImageUrl (field "EstablishmentId" Json.int))
                (field "Stars" Json.int)
                (field "UserRating" Json.float)
                (field "TeaserPricePerNight" Json.float)
    in
        field "Establishments" (Json.list hotel)


estabIdToImageUrl : Int -> String
estabIdToImageUrl estabId =
    foldl (\c str -> (append str ("/" ++ (fromChar c)))) "" (toString estabId)
        |> imageUrl


imageUrl : String -> String
imageUrl estabPart =
    "https://d23wf1heedwns1.cloudfront.net/ei" ++ estabPart ++ "/0_260_260.jpg"
