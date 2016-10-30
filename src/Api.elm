module Api exposing(..)

import Json.Decode as Json exposing ((:=))
import Json.Encode exposing (encode)
import Task exposing (..)
import Http exposing (..)
import String exposing (append, fromChar, foldl)
import Destination exposing (Destination, DestinationList)
import Models exposing (..)

body : Destination -> Body
body dest =
    let destJson = destinationToJson dest
    in 
        string("""{"CultureCode":"en-gb","DomainId":1,"TradingGroupId":1,"CurrencyCode":"GBP","Paging":{"PageIndex":0,"PageSize":1000},"FilterCriteria":{"AirportCode":null,"Stars":[],"PropertyType":[],"BoardTypeCode":[],"FacilityCodes":[],"PriceRange":null,"RatingRange":null,"EstabGroupIds":[],"EstabGroupName":null,"FilterByEstabGroup":false,"ChildDestinations":[]},"SortCriterion":1,"Destination":""" ++ destJson ++ "}")   

hotelsPost : Destination -> Request
hotelsPost dest =
    {   verb = "POST",
        headers = [ ("Content-type", "application/json") ],
        url = "api/hotels",
        body = (body dest) }

destinationToJson : Destination -> String
destinationToJson dest = 
    """{ "CountryId" : """ ++ (toString dest.countryId) ++
    """, "ProvinceId" : """ ++ (toString dest.provinceId) ++
    """, "LocationId" : """ ++ (toString dest.locationId) ++
    """, "PlaceId" : """ ++ (toString dest.placeId) ++
    """, "EstablishmentId" : """ ++ (toString dest.establishmentId) ++
    """, "PolygonId" : """ ++ (toString dest.polygonId) ++
    """, "PageStrand" : 1}"""


getHotels : Destination -> Cmd Msg
getHotels dest =
    let
        config =
            hotelsPost dest
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson hotelsDecoder
            |> Task.perform HotelsLoadFailed HotelsLoadSucceeded


hotelsDecoder : Json.Decoder HotelList
hotelsDecoder =
    let
        hotel =
            Json.object6 Hotel
                (("Name" := Json.string)
                    |> Json.maybe
                    |> Json.map (Maybe.withDefault "No Name"))
               (Json.succeed "")
               (Json.map estabIdToImageUrl ("EstablishmentId" := Json.int))
               ("Stars" := Json.int)
               ("UserRating" := Json.float)
               ("TeaserPricePerNight" := Json.float)
    in
       "Establishments" := Json.list hotel

estabIdToImageUrl : Int -> String
estabIdToImageUrl estabId =
    foldl (\c str -> (append str ("/" ++ (fromChar c)))) "" (toString estabId)
        |> imageUrl

imageUrl : String -> String
imageUrl estabPart =
    "https://d23wf1heedwns1.cloudfront.net/ei" ++ estabPart ++ "/0_260_260.jpg"
