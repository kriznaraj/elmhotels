module SortBar where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)

replaceSort : Criteria -> Sort -> Criteria
replaceSort criteria sort =
    { criteria | sort <- sort }
    
sortButton : Criteria -> Sort -> String -> Address Criteria -> Html
sortButton criteria sort label address =
    let cls = if criteria.sort == sort then 
                 "button sort-bar-button sort-selected" 
              else 
                 "button sort-bar-button"
    in
        div 
            [ class cls,
              onClick address (replaceSort criteria sort) ] 
            [ text label ]


sortBar : Criteria -> Address Criteria -> Html
sortBar criteria address = 
    section [ class "sort-bar"] [ 
        sortButton criteria HotelName "Name" address,
        sortButton criteria Stars "Stars" address,
        sortButton criteria Rating "Rating" address,
        sortButton criteria Price "Price" address
    ]
