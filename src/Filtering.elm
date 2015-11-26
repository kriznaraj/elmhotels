module Filtering where

import Models exposing (..)
import SortBar
import Pager
import HotelsList exposing (HotelList, Hotel)
import String
import Debug exposing (log)

adjustPaging : Int -> Criteria -> Criteria
adjustPaging total criteria =
    let paging = criteria.paging
    in
        if(paging.pageIndex * paging.pageSize > total) then 
            {criteria | paging = Pager.initialModel}
        else
            criteria

page : Model -> Model
page model =
    let 
        criteria = adjustPaging model.total model.criteria
        paging = criteria.paging
        page = model.hotels
            |> List.drop (paging.pageIndex * paging.pageSize)
            |> List.take paging.pageSize
    in
       {model | hotels = page, criteria = criteria }

sort : Model -> Model
sort model =
    let sortFn = (\hotels -> 
        case model.criteria.sort of
           SortBar.HotelName -> List.sortBy .name hotels
           SortBar.Stars -> hotels
                        |> List.sortBy .stars
                        |> List.reverse
           SortBar.Rating -> hotels
                        |> List.sortBy .rating
                        |> List.reverse
           SortBar.Price -> List.sortBy .price hotels)
        hotels = (sortFn model.hotels)
    in
       {model | hotels = hotels}

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

filter : Model -> Model
filter model =
    let filterFn = (\h -> 
        (ratingAtLeast model.criteria.filter.minRating h) &&
        (priceLessThan model.criteria.filter.minPrice h) &&
        (starsMatch model.criteria.filter.stars h) &&
        (nameMatches model.criteria.filter.hotelName h))
        hotels = List.filter filterFn model.hotels
    in
       {model | hotels = hotels, total = (List.length hotels)}

restrict : Model -> Model
restrict model =
    let hotels = model.hotels
        criteria = model.criteria
        newModel = {model|total = (List.length hotels)}
    in
       newModel
        |> filter
        |> sort
        |> page
