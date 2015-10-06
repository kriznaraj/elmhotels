module Api where

import Json.Decode as Json exposing ((:=))
import Models exposing (..)
import Task exposing (..)
import Effects exposing (..)
import Http exposing (..)
import String exposing (append, fromChar, foldl)

body : Body
body =
    string("""{"CultureCode":"en-gb","DomainId":1,"TradingGroupId":1,"CurrencyCode":"GBP","Paging":{"PageIndex":0,"PageSize":1000},"FilterCriteria":{"AirportCode":null,"Stars":[],"PropertyType":[],"BoardTypeCode":[],"FacilityCodes":[],"PriceRange":null,"RatingRange":null,"EstabGroupIds":[],"EstabGroupName":null,"FilterByEstabGroup":false,"ChildDestinations":[]},"SortCriterion":1,"Destination":{"PageStrand":1,"CountryId":3522,"ProvinceId":54875,"LocationId":0,"PlaceId":0,"EstablishmentId":0,"PolygonId":0}}""")

hotelsPost : Request
hotelsPost =
    {   verb = "POST",
        headers = [ ("Content-type", "application/json") ],
        url = "api/hotels",
        body = body }

parseResponse : Task RawError Response -> Task Never Action
parseResponse response =
    let res = Task.map (\hl -> LoadData hl) (fromJson hotels2 response)
    in
        Task.onError res (\err -> Task.succeed (LoadData []))

getHotels : Task Never Action
getHotels =
    (parseResponse (send defaultSettings hotelsPost))

getHotelsStatic : Task Never Action
getHotelsStatic =
    let req = Task.map (\hl -> LoadData hl) (get hotels ("data/hotels.json"))
    in
        Task.onError req (\err -> Task.succeed (LoadData []))

hotels : Json.Decoder HotelList
hotels =
    let hotel =
        Json.object6 Hotel
           ("Name" := Json.string)
           ("ThumbnailUrl" := Json.string)
           ("ImageUrl" := Json.string)
           ("Stars" := Json.int)
           ("UserRating" := Json.float)
           ("MinCost" := Json.float)
    in
       "Establishments" := Json.list hotel

hotels2 : Json.Decoder HotelList
hotels2 =
    let hotel =
        Json.object6 Hotel
           ("Name" := Json.string)
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
    "https://d23wf1heedwns1.cloudfront.net/ei/" ++ estabPart ++ "/0_260_260.jpg"
