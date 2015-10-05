module Api where

import Json.Decode as Json exposing ((:=))
import Models exposing (..)
import Task exposing (..)
import Effects exposing (..)
import Http

getHotels : Task Never Action
getHotels =
    let req = Task.map (\hl -> LoadData hl) (Http.get hotels ("data/hotels.json"))
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
