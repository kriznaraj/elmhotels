module Filtering exposing (..)

import Models exposing (..)
import SortBar
import Pager
import String
import Debug exposing (log)


adjustPaging : Int -> Criteria -> Criteria
adjustPaging total criteria =
    let
        paging =
            criteria.paging
    in
        if (paging.pageIndex * paging.pageSize > total) then
            { criteria | paging = initialPager }
        else
            criteria


page : Model -> Model
page model =
    let
        criteria =
            adjustPaging model.total model.criteria

        paging =
            criteria.paging

        page =
            model.hotels
                |> List.drop (paging.pageIndex * paging.pageSize)
                |> List.take paging.pageSize
    in
        { model | hotels = page, criteria = criteria }


sort : Model -> Model
sort model =
    let
        sortFn =
            case model.criteria.sort of
                HotelName ->
                    List.sortBy .name

                Stars ->
                        List.reverse << List.sortBy .stars

                Rating ->
                        List.reverse << List.sortBy .rating

                Price ->
                    List.sortBy .price

    in
        { model | hotels = (sortFn model.hotels) }


nameMatches : String -> Hotel -> Bool
nameMatches query {name} =
    let
        queryLower =
            (String.toLower query)

        nameLower =
            (String.toLower name)
    in
        (String.contains queryLower nameLower)


starsMatch : List Int -> Hotel -> Bool
starsMatch starsFilter hotel =
    case starsFilter of
        hd :: tl ->
            List.member hotel.stars starsFilter

        [] ->
            True


priceLessThan : Float -> Hotel -> Bool
priceLessThan min hotel =
    hotel.price >= min


ratingAtLeast : Float -> Hotel -> Bool
ratingAtLeast min hotel =
    hotel.rating >= min


filter : Model -> Model
filter ({criteria, hotels} as model) =
    let
        filter = criteria.filter

        fns =
            [ ratingAtLeast filter.minRating
            , priceLessThan filter.minPrice
            , starsMatch filter.stars
            , nameMatches filter.hotelName ]

        hotelMatches =
            (\h ->
                List.foldl (\fn matches ->
                    matches && fn h) True fns )

        hotels =
            List.filter hotelMatches model.hotels
    in
        { model | hotels = hotels, total = (List.length hotels) }


restrict : Model -> Model
restrict ({hotels, criteria} as model) =
    { model | total = (List.length hotels) }
        |> filter
        |> sort
        |> page
