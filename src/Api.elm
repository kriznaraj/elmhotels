module Api exposing (..)

import Json.Decode as Json exposing (field)
import Json.Encode exposing (Value, encode, int, object, string)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
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


-- getHotels : Destination -> Cmd Msg
-- getHotels dest =
--     Http.send HotelsLoad <|
--         Http.post "api/hotels" (body dest) hotelsDecoder


getHotels : Destination -> Cmd Msg
getHotels dest =
    Http.send HotelsLoad <|
        Http.post "api/hotels" (body dest) hotelsDecoder
        --Http.get "data/hotels.json" hotelsDecoder

hotelsDecoder : Json.Decoder HotelList
hotelsDecoder =
    let
        hotel =
            Json.map7 Hotel
                (field "EstablishmentId" Json.int)
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

-- hotelsDecoder : Json.Decoder HotelList
-- hotelsDecoder =
--     let
--         hotel =
--             decode Hotel
--                 |> required "EstablishmentId" Json.int
--                 |> required "Name" Json.string
--                 |> required "ThumbnailUrl" Json.string
--                 |> required "ImageUrl" Json.string
--                 |> required "Stars" Json.int
--                 |> required "UserRating" Json.float
--                 |> required "MinCost" Json.float
--     in
--         field "Establishments" (Json.list hotel)

estabIdToImageUrl : Int -> String
estabIdToImageUrl estabId =
    foldl (\c str -> (append str ("/" ++ (fromChar c)))) "" (toString estabId)
        |> imageUrl

imageUrl : String -> String
imageUrl estabPart =
    "https://d23wf1heedwns1.cloudfront.net/ei" ++ estabPart ++ "/0_260_260.jpg"

userDecoder : Json.Decoder User
userDecoder =
  decode User
    |> required "id" Json.int
    |> required "email" (Json.nullable Json.string) -- `null` decodes to `Nothing`
    |> optional "name" Json.string "(fallback if name is `null` or not present)"
    |> hardcoded 1.0

hotelDetailDecoder: Json.Decoder HotelDetail
hotelDetailDecoder =
    decode HotelDetail
        |> required "EstablishmentType" Json.string
        |> required "Location" Json.string
        |> required "ProvinceTitle" Json.string
        |> required "Address" Json.string
        |> required "Name" Json.string
        |> required "EstablishmentId" Json.int
        |> required "Stars" Json.int
        |> required "Summary" Json.string
        |> required "UserRating" Json.float
        |> required "UserRatingTitle" Json.string
        |> required "UserRatingCount" Json.int
        |> required "TeaserPricePerNight" Json.float

getUser : Int -> Cmd Msg
getUser hotel =
    let
        req =
            Http.get "data/user.json" userDecoder
    in
        Http.send ShowUser req


getHotelDetail : Int -> Cmd Msg
getHotelDetail estabId =
    let
        req =
            Http.get ("/api/hotel?estabId="++(toString estabId)) hotelDetailDecoder
    in
        Http.send ShowDetail req
