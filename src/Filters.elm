module Filters where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Debug exposing (log)
import String

--MODEL
type alias Model = {
    stars : List Int,
    minRating : Float,
    hotelName : String,
    minPrice : Float
}

initialModel : Model
initialModel = Model [] 0 "" 0

addOrRemoveStar : Model -> Int -> Model
addOrRemoveStar filter star =
    let inList = List.member star filter.stars
    in
       if(inList) then
            { filter | stars = (List.filter (\s -> s /= star) filter.stars) }
       else 
            { filter | stars = (star :: filter.stars) }

stars : Int -> Model -> Address Model -> Html
stars num filter address =
    div [class "stars"] [
                 input [
                    type' "checkbox",
                    checked (List.member num filter.stars),
                    onClick address (addOrRemoveStar filter num)
                ] [],
                span [] [text ((toString num) ++ " Stars")]
    ]

view : Model -> Address Model -> Html
view filter address = 
    section [ class "filters"] [ 
        h3 [] [text "Filters"],
        div [] [
            input 
                [ placeholder "Hotel Name"
                , autofocus True
                , type' "text"
                , value filter.hotelName
                , on "input" targetValue 
                    (\str -> Signal.message address {filter|hotelName = str})
                ] []
        ],
        div [] [
            label [] [ text "Stars: " ],
            div [][
                (stars 5 filter address), 
                (stars 4 filter address), 
                (stars 3 filter address), 
                (stars 2 filter address), 
                (stars 1 filter address)
            ]
        ],
        div [class "clear"] [
            rangeInput "Minimum Rating" "0" "10" 
                filter.minRating 
                filter
                (\c str -> {filter|minRating = (parseFloat str)})
                address
        ],
        rangeInput "Minimum Price" "0" "7000" 
            filter.minPrice 
            filter
            (\c str -> {filter|minPrice = (parseFloat str)})
            address,
        div [] [
            button [class "button",
                onClick address (Model [] 0 "" 0)] [ text "Clear Filters" ]
        ]
    ] 


rangeInput : String -> String -> String -> Float -> Model -> (Model -> String -> Model) -> Address Model -> Html
rangeInput name min max val filter updater address =
    div [] [
        label [] [ text (name ++ ": ")],
        input 
            [ placeholder name
            , type' "range"
            , Html.Attributes.min min
            , Html.Attributes.max max
            , value (toString val)
            , on "input" targetValue 
                (\str -> Signal.message address (updater filter str))
            ] []
    ]
    

--return 0 if the string cannot be parsed
parseFloat : String -> Float
parseFloat str =
    case String.toFloat str of
        Err _ -> 0
        Ok x -> x

