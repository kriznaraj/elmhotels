module SortBar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)

--MODEL
type Model = 
    Stars 
    | Rating 
    | HotelName 
    | Price 

initialModel : Model
initialModel = HotelName

sortButton : Model -> Model -> String -> Address Model -> Html
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


view : Model -> Address Model -> Html
view sort address = 
    section [ class "sort-bar"] [ 
        sortButton sort HotelName "Name" address,
        sortButton sort Stars "Stars" address,
        sortButton sort Rating "Rating" address,
        sortButton sort Price "Price" address 
    ]
