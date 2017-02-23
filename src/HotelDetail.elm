module HotelDetail exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (log)
import Models exposing (..)

backgroundImage : String -> Attribute Msg
backgroundImage url =
    style
        [ ( "backgroundImage", ("url(" ++ url ++ ")") )
        , ( "backgroundRepeat", "no-repeat" )
        ]

hotelDetail : Hotel -> Html Msg
hotelDetail hotel =
    div [ class "hotel-card" ]
        [ div []
            [ div [ class "hotel-image", (backgroundImage hotel.image) ] []
            , div [ class "hotel-overlay" ]
                [ h3 [ class "truncate" ] [ text hotel.name ]
                , div [ class "hotel-text" ]
                    [ p [ class "hotel-price" ] [ text ("Price: " ++ (toString hotel.price)) ]
                    , p [ class "hotel-rating" ] [ text ("Rating: " ++ (toString hotel.rating)) ]
                    , p [ class "hotel-stars" ] [ text ("Stars: " ++ (toString hotel.stars)) ]
                    ]
                ]
            ]
        ]


lightBox : Hotel -> Html Msg
lightBox hotel =
    div [ class "modal" ]
        [ 
            span [ onClick HideHotelDetail, class "close cursor" ] [text "x"]
            , div [ class "modal-content"] [hotelDetail hotel]
        ]
