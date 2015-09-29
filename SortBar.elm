module SortBar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)

sortButton : Sort -> Sort -> String -> Address Sort -> Html
sortButton currentSort sort label address =
    let cls = if currentSort == sort then 
                 "button sort-bar-button sort-selected" 
              else 
                 "button sort-bar-button"
    in
        div 
            [ class cls,
              onClick address sort ] 
            [ text label ]


sortBar : Sort -> Address Sort -> Html
sortBar sort address = 
    section [ class "sort-bar"] [ 
        sortButton sort HotelName "Name" address,
        sortButton sort Stars "Stars" address,
        sortButton sort Rating "Rating" address,
        sortButton sort Price "Price" address 
    ]
