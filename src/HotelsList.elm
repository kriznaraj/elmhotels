module HotelsList exposing (..)
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


hotelCard : Hotel -> Html Msg
hotelCard hotel =
    li []
        [ div [ onClick (ShowHotelDetail hotel), class "hotel-card" ]
            [ div []
                [ div [ class "hotel-image", (backgroundImage hotel.image) ] []
                , div [ class "hotel-overlay" ]
                    [ h3 [ class "truncate" ] [ text hotel.name ]
                    , div [ class "hotel-text" ]
                        [ p [ class "hotel-price" ] [ text ("Price: " ++ (toString hotel.price)) ]
                        , p [ class "hotel-rating" ] [ text ("Id: " ++ (toString hotel.estabId)) ]
                        , p [ class "hotel-rating" ] [ text ("Rating: " ++ (toString hotel.rating)) ]
                        , p [ class "hotel-stars" ] [ text ("Stars: " ++ (toString hotel.stars)) ]
                        ]
                    ]
                ]
            ]
        ]


hotelList : HotelList -> Html Msg
hotelList hotels =
    section [ class "hotel-list" ]
        [ if ((List.length hotels) == 0) then
            h3 [] [ text "Loading hotels ..." ]
          else
            ul [] (List.map hotelCard hotels)
        ]
