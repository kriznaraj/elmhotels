module Pager(signal, pager) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Signal exposing (Address)
import Debug exposing (log, watch)

mailbox : Signal.Mailbox Paging
mailbox = 
    Signal.mailbox (Paging 20 0)

signal : Signal Paging
signal =
    mailbox.signal

pager : Int -> Paging -> Html
pager total paging =
    let pageIndex = paging.pageIndex
        pageNum = pageIndex + 1
        hotelCount = toFloat (total)
        pageSize = toFloat paging.pageSize
        pageCount = (ceiling (hotelCount / pageSize))
        firstPage = pageIndex == 0
        lastPage = pageNum == pageCount
    in
        section [ class "pager"] [ 
           button [class "button prev",
                disabled firstPage,
               onClick mailbox.address { paging | pageIndex <- (pageIndex - 1) }] [text "Previous"],
           span [class "total-pages"] [ text ("Page " ++ (toString (watch "pageNum" pageNum)) ++ " of " ++ (toString pageCount)) ],    
           button [class "button next",
                disabled lastPage, 
               onClick mailbox.address { paging | pageIndex <- (pageIndex + 1) }] [text "Next"]]
