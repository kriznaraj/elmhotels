module Filtering where

import Models exposing (..)
import String
import Debug exposing (log)

adjustPaging : Int -> Criteria -> Criteria
adjustPaging total criteria =
    let paging = criteria.paging
    in
        if(paging.pageIndex * paging.pageSize > total) then 
            {criteria | paging <- (Paging 20 0)}
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
        (Model page model.total criteria)

sort : Model -> Model
sort model =
    let sortFn = (\hotels -> 
        case model.criteria.sort of
           HotelName -> List.sortBy .name hotels
           Stars -> hotels
                        |> List.sortBy .stars
                        |> List.reverse
           Rating -> hotels
                        |> List.sortBy .rating
                        |> List.reverse
           Price -> List.sortBy .price hotels)
    in
       Model (sortFn model.hotels) model.total model.criteria

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
        Model hotels (List.length hotels) model.criteria

restrict2 : Model -> Model
restrict2 model =
    restrict (log "hotels: " model.hotels) model.criteria

restrict : HotelList -> Criteria -> Model
restrict hotels criteria =
    let model = Model hotels (List.length hotels) criteria
    in
        model
            |> filter 
            |> sort 
            |> page
