module SortBar exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)

--MODEL

sortButton : SortOrder -> SortOrder -> String -> Html Msg
sortButton currentSort sort label =
    let cls = if currentSort == sort then 
                 "button sort-bar-button sort-selected" 
              else 
                 "button sort-bar-button"
    in
        div 
            [ class cls,
              onClick (SortChange sort) ]
            [ text label ]


view : SortOrder -> Html Msg
view sort =
    section [ class "sort-bar"] [ 
        sortButton sort HotelName "Name" ,
        sortButton sort Stars "Stars" ,
        sortButton sort Rating "Rating" ,
        sortButton sort Price "Price"
    ]
