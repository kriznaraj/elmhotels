module Filters (signal, filters) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)
import Debug exposing (log)
import String
import Pager exposing (address)

mailbox : Signal.Mailbox Filter
mailbox = 
    Signal.mailbox (Filter [] 0 "" 0)

signal : Signal Filter
signal = 
    mailbox.signal

resetPageIndex : Filter -> Filter
resetPageIndex filter =
    let q = Signal.message Pager.address (Paging 20 0)
    in filter

addOrRemoveStar : Filter -> Int -> Filter
addOrRemoveStar filter star =
    let inList = List.member star filter.stars
    in
       if(inList) then
            { filter | stars <- (List.filter (\s -> s /= star) filter.stars) }
       else 
            { filter | stars <- (star :: filter.stars) }

stars : Int -> Filter -> Html
stars num filter =
    div [class "stars"] [
                 input [
                    type' "checkbox",
                    checked (List.member num filter.stars),
                    onClick mailbox.address (resetPageIndex (addOrRemoveStar filter num))
                ] [],
                span [] [text ((toString num) ++ " Stars")]
    ]

filters : Filter -> Html
filters filter = 
    section [ class "filters"] [ 
        h3 [] [text "Filters"],
        div [] [
            input 
                [ placeholder "Hotel Name"
                , autofocus True
                , type' "text"
                , value filter.hotelName
                , on "input" targetValue 
                    (\str -> Signal.message mailbox.address (resetPageIndex {filter|hotelName <- str}))
                ] []
        ],
        div [] [
            label [] [ text "Stars: " ],
            div [][
                (stars 5 filter), 
                (stars 4 filter), 
                (stars 3 filter), 
                (stars 2 filter), 
                (stars 1 filter)
            ]
        ],
        div [class "clear"] [
            rangeInput "Minimum Rating" "0" "10" 
                filter.minRating 
                filter
                (\c str -> {filter|minRating <- (parseFloat str)})
        ],
        rangeInput "Minimum Price" "0" "7000" 
            filter.minPrice 
            filter
            (\c str -> {filter|minPrice <- (parseFloat str)}),
        div [] [
            button [class "button",
                onClick mailbox.address (Filter [] 0 "" 0)] [ text "Clear Filters" ]
        ]
    ] 


rangeInput : String -> String -> String -> Float -> Filter -> (Filter -> String -> Filter) -> Html
rangeInput name min max val filter updater =
    div [] [
        label [] [ text (name ++ ": ")],
        input 
            [ placeholder name
            , type' "range"
            , Html.Attributes.min min
            , Html.Attributes.max max
            , value (toString val)
            , on "input" targetValue 
                (\str -> Signal.message mailbox.address (updater filter str))
            ] []
    ]
    

--return 0 if the string cannot be parsed
parseFloat : String -> Float
parseFloat str =
    case String.toFloat str of
        Err _ -> 0
        Ok x -> x

