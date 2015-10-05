module HotelsList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Debug exposing (log)
import Models exposing (..)

backgroundImage : String -> Attribute
backgroundImage url =
    style 
        [ 
            ("backgroundImage", ("url(" ++ url ++ ")")),
            ("backgroundRepeat", "no-repeat")
        ]

hotelCard : Hotel -> Html
hotelCard hotel =
    li [] [ 
        div [class "hotel-card"] [ 
            div [] [
                div [class "hotel-image", backgroundImage hotel.image] [ ],
                div [class "hotel-overlay"] [
                     h3 [class "truncate"] [text hotel.name],
                     div [class "hotel-text"] [
                        p [ class "hotel-price"] [text ("Price: " ++ (toString hotel.price))],
                        p [ class "hotel-rating"] [text ("Rating: " ++ (toString hotel.rating))],
                        p [ class "hotel-stars"] [text ("Stars: " ++ (toString hotel.stars))]
                    ]                   
                ]                
            ]
        ]
    ]

hotelList : HotelList -> Html
hotelList hotels =
    section [ class "hotel-list"] [ 
        ul [] (List.map hotelCard hotels)
    ]

