module SortBar exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

--MODEL
type Model = 
    Stars 
    | Rating 
    | HotelName 
    | Price 

initialModel : Model
initialModel = HotelName

sortButton : Model -> Model -> String -> Html
sortButton currentSort sort label address =
    let cls = if currentSort == sort then 
                 "button sort-bar-button sort-selected" 
              else 
                 "button sort-bar-button"
    in
        div 
            [ class cls,
              onClick sort ]
            [ text label ]


view : Model -> Html
view sort =
    section [ class "sort-bar"] [ 
        sortButton sort HotelName "Name" ,
        sortButton sort Stars "Stars" ,
        sortButton sort Rating "Rating" ,
        sortButton sort Price "Price"
    ]
