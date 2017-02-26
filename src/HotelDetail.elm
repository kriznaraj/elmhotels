module HotelDetail exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (log)
import Models exposing (..)
import Api exposing (..)

backgroundImage : String -> Attribute Msg
backgroundImage url =
    style
        [ ( "backgroundImage", ("url(" ++ url ++ ")") )
        , ( "backgroundRepeat", "no-repeat" )
        ]

hotelDetail : Hotel -> Html Msg -> Html Msg
hotelDetail hotel user =
    div [ class "hotel-card" ]
        [ div []
            [ div [ class "hotel-image", (backgroundImage (hotel.image)) ] []
            , div [ class "hotel-overlay" ]
                [ h3 [ class "truncate" ] [ text hotel.name ]
                , div [ class "hotel-text" ]
                    [ p [ class "hotel-price" ] [ text ("Price: " ++ (toString hotel.price)) ]
                    , p [ class "hotel-rating" ] [ text ("Rating: " ++ (toString hotel.rating)) ]
                    , p [ class "hotel-stars" ] [ text ("Stars: " ++ (toString hotel.stars)) ]
                    , p [ class "hotel-stars" ] [ text ("Krishna") ]
                    ]
                ]
                , user
            ]
        ]

hotelDetail2 : HotelDetail ->  Html Msg
hotelDetail2 hotel =
    div []
        [ div []
            [ div [ class "hotel-image", (backgroundImage (Api.estabIdToImageUrl hotel.establishmentId)) ] []
            , div []
                [ 
                    div [ class "hotel-text" ]
                    [ h3 [ class "truncate" ] [ text hotel.name ]
                    , p [ class "hotel-price" ] [ text ("Price: " ++ (toString hotel.teaserPricePerNight)) ]
                    , p [ class "hotel-rating" ] [ text ("Rating: " ++ hotel.userRatingTitle) ]
                    , p [ class "hotel-stars" ] [ text ("Stars: " ++ (toString hotel.stars)) ]
                    , p [ class "hotel-rating" ] [ text ("Rating: " ++ hotel.location ++ ", " ++ hotel.provinceTitle ++ ", " ++ hotel.address) ]
                    , p [ class "hotel-stars" ] [ text ("User Rating: " ++ (toString hotel.userRating) ++ " of " ++ (toString hotel.userRatingCount)) ]
                    ]
                ]
            ]
        ]


userContent: Maybe User -> Html Msg
userContent user = 
    case user of
        Nothing ->
            div [][]
        Just u -> 
            div [ class "hotel-text" ]
                [ p [ class "hotel-price" ] [ text ("Name: " ++ (toString u.name)) ]
                , p [ class "hotel-price" ] [ text ("Email: " ++ (toString u.email)) ]
                , p [ class "hotel-rating" ] [ text ("Percent Excited: " ++ (toString u.percentExcited)) ]
                ]

lightBox : HotelDetail -> Html Msg
lightBox hotel =
    div [ onClick HideHotelDetail, class "modal" ]
        [ 
            div [ class "modal-content"]
            [ hotelDetail2 hotel
            ]
        ]
