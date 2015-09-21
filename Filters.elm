module Filters where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)
import Debug exposing (log)

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
                    onClick address (addOrRemoveStar criteria num)
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
                        (\str -> Signal.message address (replaceFilter criteria {filter|hotelName <- str}))
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
                label [] [ text "Minimum Rating: " ],
                input [type' "range"] []
            ],
            div [] [
                label [] [ text "Minimum Price: " ],
                input [type' "range"] []
            ],
            div [] [
                button [class "button",
                    onClick address (Criteria (Filter [] 0 "" 0) HotelName (Paging 20 0))] [ text "Clear Filters" ]
            ]
        ] 
