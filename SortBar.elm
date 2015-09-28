module SortBar (signal, sortBar) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Models exposing (..)

mailbox : Signal.Mailbox Sort
mailbox =
    Signal.mailbox HotelName

signal : Signal Sort
signal =
    mailbox.signal
    
sortButton : Sort -> Sort -> String -> Html
sortButton currentSort sort label =
    let cls = if currentSort == sort then 
                 "button sort-bar-button sort-selected" 
              else 
                 "button sort-bar-button"
    in
        div 
            [ class cls,
              onClick mailbox.address sort ] 
            [ text label ]


sortBar : Sort -> Html
sortBar sort = 
    section [ class "sort-bar"] [ 
        sortButton sort HotelName "Name" ,
        sortButton sort Stars "Stars" ,
        sortButton sort Rating "Rating" ,
        sortButton sort Price "Price" 
    ]
