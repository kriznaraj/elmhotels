module Filters exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (log)
import String
import Models exposing (..)


addOrRemoveStar : Filter -> Int -> Filter
addOrRemoveStar filter star =
    let
        inList =
            List.member star filter.stars
    in
        if (inList) then
            { filter | stars = (List.filter (\s -> s /= star) filter.stars) }
        else
            { filter | stars = (star :: filter.stars) }


stars : Int -> Filter -> Html Msg
stars num filter =
    div [ class "stars" ]
        [ input
            [ type_ "checkbox"
            , checked (List.member num filter.stars)
            , onClick (FilterChange (addOrRemoveStar filter num))
            ]
            []
        , span [] [ text ((toString num) ++ " Stars") ]
        ]


view : Filter -> Html Msg
view filter =
    section [ class "filters" ]
        [ h3 [] [ text "Filters" ]
        , div []
            [ input
                [ placeholder "Hotel Name"
                , autofocus True
                , type_ "text"
                , value filter.hotelName
                , onInput (\str -> (FilterChange { filter | hotelName = str }))
                ]
                []
            ]
        , div []
            [ label [] [ text "Stars: " ]
            , div []
                [ (stars 5 filter)
                , (stars 4 filter)
                , (stars 3 filter)
                , (stars 2 filter)
                , (stars 1 filter)
                ]
            ]
        , div [ class "clear" ]
            [ rangeInput "Minimum Rating"
                "0"
                "10"
                filter.minRating
                filter
                (\c str -> { filter | minRating = (parseFloat str) })
            ]
        , rangeInput "Minimum Price"
            "0"
            "7000"
            filter.minPrice
            filter
            (\c str -> { filter | minPrice = (parseFloat str) })
        , div []
            [ button
                [ class "button"
                , onClick (FilterChange (Filter [] 0 "" 0))
                ]
                [ text "Clear Filters" ]
            ]
        ]


rangeInput : String -> String -> String -> Float -> Filter -> (Filter -> String -> Filter) -> Html Msg
rangeInput name min max val filter updater =
    div []
        [ label [] [ text (name ++ ": ") ]
        , input
            [ placeholder name
            , type_ "range"
            , Html.Attributes.min min
            , Html.Attributes.max max
            , value (toString val)
            , onInput (\str -> (FilterChange (updater filter str)))
            ]
            []
        ]


parseFloat : String -> Float
parseFloat str =
    Result.withDefault 0 (String.toFloat str)
