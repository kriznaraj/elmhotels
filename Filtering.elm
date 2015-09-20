module Filtering where

import Models exposing (..)
import String
import Debug exposing (log)

page : Criteria -> HotelList -> Model
page criteria hotels =
    let paging = criteria.paging
        page = hotels
        |> List.drop (paging.pageIndex * paging.pageSize)
        |> List.take paging.pageSize
    in
        log (toString (List.length page)) Model page criteria

sort : Criteria -> HotelList -> HotelList
sort criteria hotels =
    hotels

nameMatches : String -> Hotel -> Bool
nameMatches query hotel =
    (String.contains query hotel.name)

filter : Criteria -> HotelList -> HotelList
filter criteria hotels =
    List.filter (nameMatches criteria.filter.hotelName) hotels

restrict : HotelList -> Criteria -> Model
restrict hotels criteria =
    hotels
        |> filter criteria
        |> sort criteria
        |> page criteria
