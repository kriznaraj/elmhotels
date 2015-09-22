module Filters where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)
import Debug exposing (log)
import String

resetPageIndex : Criteria -> Criteria
resetPageIndex criteria =
    let paging = criteria.paging
    in
        { criteria | paging <- { paging | pageIndex <- 0 } }

addOrRemoveStar : Criteria -> Int -> Criteria
addOrRemoveStar criteria star =
    let filter = criteria.filter
        inList = List.member star filter.stars
    in
       if(inList) then
            { criteria | filter <- { filter | stars <- (List.filter (\s -> s /= star) filter.stars) } }
       else 
            { criteria | filter <- { filter | stars <- (star :: filter.stars) } }

stars : Int -> Criteria -> Address Criteria -> Html
stars num criteria address =
    div [class "stars"] [
                 input [
                    type' "checkbox",
                    checked (List.member num criteria.filter.stars),
                    onClick address (resetPageIndex (addOrRemoveStar criteria num))
                ] [],
                span [] [text ((toString num) ++ " Stars")]
    ]

replaceFilter : Criteria -> Filter -> Criteria
replaceFilter criteria filter =
    { criteria | filter <- filter }

filters : Criteria -> Address Criteria -> Html
filters criteria address = 
    let filter =
        criteria.filter
    in
        section [ class "filters"] [ 
            h3 [] [text "Filters"],
            div [] [
                input 
                    [ placeholder "Hotel Name"
                    , autofocus True
                    , type' "text"
                    , value criteria.filter.hotelName
                    , on "input" targetValue 
                        (\str -> Signal.message address (resetPageIndex (replaceFilter criteria {filter|hotelName <- str})))
                    ] []
            ],
            div [] [
                label [] [ text "Stars: " ],
                div [][
                    (stars 5 criteria address), 
                    (stars 4 criteria address), 
                    (stars 3 criteria address), 
                    (stars 2 criteria address), 
                    (stars 1 criteria address)
                ]
            ],
            div [class "clear"] [
                rangeInput "Minimum Rating" "0" "10" 
                    criteria.filter.minRating 
                    address 
                    criteria 
                    (\c str -> (replaceFilter criteria {filter|minRating <- (parseFloat str)}))
            ],
            rangeInput "Minimum Price" "0" "7000" 
                criteria.filter.minPrice 
                address 
                criteria 
                (\c str -> (replaceFilter criteria {filter|minPrice <- (parseFloat str)})),
            div [] [
                button [class "button",
                    onClick address (Criteria (Filter [] 0 "" 0) HotelName (Paging 20 0))] [ text "Clear Filters" ]
            ]
        ] 


rangeInput : String -> String -> String -> Float -> Address Criteria -> Criteria -> (Criteria -> String -> Criteria) -> Html
rangeInput name min max val address criteria updater =
    div [] [
        label [] [ text (name ++ ": ")],
        input 
            [ placeholder name
            , type' "range"
            , Html.Attributes.min min
            , Html.Attributes.max max
            , value (toString val)
            , on "input" targetValue 
                (\str -> Signal.message address (resetPageIndex (updater criteria str)))
            ] []
    ]
    

--return 0 if the string cannot be parsed
parseFloat : String -> Float
parseFloat str =
    case String.toFloat str of
        Err _ -> 0
        Ok x -> x

