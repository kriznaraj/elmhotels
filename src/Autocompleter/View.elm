module Autocompleter.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (length)
import Destination exposing (Destination, DestinationList)
import Autocompleter.Types exposing (..)
import Autocompleter.Cmds exposing (..)


destination : Destination -> Html Msg
destination dest =
    li
        [ onClick (SelectDestination dest)
        ]
        [ span [] [ text (dest.title ++ ", (" ++ (toString dest.establishmentCount) ++ " hotels)") ]
        ]


view : Model -> Html Msg
view model =
    section [ class "autocompleter" ]
        [ h3 [] [ text "Destination" ]
        , div []
            [ input
                [ placeholder "Search for a destination"
                , autofocus True
                , type_ "text"
                , value model.query
                , onInput (\str -> QueryChanged str)
                ]
                []
            ]
        , div [ class "results" ]
            [ ul [] (List.map destination model.destinations)
            ]
        ]
