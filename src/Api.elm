module Api where

import Json.Decode as Json exposing ((:=))
import Models exposing (..)
import Task exposing (..)
import Effects exposing (..)
import Http exposing (..)

body : Body
body =
    string("""{"CultureCode":"en-gb","DomainId":1,"TradingGroupId":1,"CurrencyCode":"GBP","Paging":{"PageIndex":0,"PageSize":10000},"FilterCriteria":{"AirportCode":null,"Stars":[],"PropertyType":[],"BoardTypeCode":[],"FacilityCodes":[],"PriceRange":null,"RatingRange":null,"EstabGroupIds":[],"EstabGroupName":null,"FilterByEstabGroup":false,"ChildDestinations":[]},"SortCriterion":1,"Destination":{"CountryId":0,"ProvinceId":0,"LocationId":0,"PlaceId":0,"EstablishmentId":0,"PolygonId":3125,}}""")

getHotelsLive : Task Never Action
getHotelsLive =
    let req = Task.map (\hl -> LoadData hl) (post hotels2 "api/hotels" body)
    in
        Task.onError req (\err -> Task.succeed (LoadData []))

getHotels : Task Never Action
getHotels =
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


--this is not going to decode properly because the image url does not exist
--in the real feed
hotels2 : Json.Decoder HotelList
hotels2 =
    let hotel =
        Json.object6 Hotel
           ("Name" := Json.string)
           ("ThumbnailUrl" := Json.string)
           ("ImageUrl" := Json.string)
           ("Stars" := Json.int)
           ("UserRating" := Json.float)
           ("TeaserPricePerNight" := Json.float)
    in
       "Establishments" := Json.list hotel
