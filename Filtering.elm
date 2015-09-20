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
    case criteria.sort of
       HotelName -> List.sortBy .name hotels
       Stars -> List.sortBy .stars hotels
       Rating -> List.sortBy .rating hotels
       Price -> List.sortBy .price hotels

nameMatches : String -> Hotel -> Bool
nameMatches query hotel =
    let queryLower = (String.toLower query)
        nameLower = (String.toLower hotel.name)
    in
        (String.contains queryLower nameLower)

filter : Criteria -> HotelList -> HotelList
filter criteria hotels =
    List.filter (nameMatches criteria.filter.hotelName) hotels

restrict : HotelList -> Criteria -> Model
restrict hotels criteria =
    hotels
        |> filter criteria
        |> sort criteria
        |> page criteria
