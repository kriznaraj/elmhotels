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
       Stars -> hotels
                    |> List.sortBy .stars
                    |> List.reverse
       Rating -> hotels
                    |> List.sortBy .rating
                    |> List.reverse
       Price -> List.sortBy .price hotels

nameMatches : String -> Hotel -> Bool
nameMatches query hotel =
    let queryLower = (String.toLower query)
        nameLower = (String.toLower hotel.name)
    in
        (String.contains queryLower nameLower)

starsMatch : (List Int) -> Hotel -> Bool
starsMatch starsFilter hotel =
    case starsFilter of
        hd::tl -> List.member hotel.stars starsFilter
        [] -> True

priceLessThan : Float -> Hotel -> Bool
priceLessThan min hotel =
    hotel.price >= min

ratingAtLeast : Float -> Hotel -> Bool
ratingAtLeast min hotel =
    hotel.rating >= min

filter : Criteria -> HotelList -> HotelList
filter criteria hotels =
    let filterFn = (\h -> 
        (ratingAtLeast criteria.filter.minRating h) &&
        (priceLessThan criteria.filter.minPrice h) &&
        (starsMatch criteria.filter.stars h) &&
        (nameMatches criteria.filter.hotelName h))
    in
       log("stars" ++ (toString criteria.filter.stars))
        List.filter filterFn hotels

restrict : HotelList -> Criteria -> Model
restrict hotels criteria =
    hotels
        |> filter criteria
        |> sort criteria
        |> page criteria
