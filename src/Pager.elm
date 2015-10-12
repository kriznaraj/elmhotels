module Pager where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address)
import Debug exposing (log, watch)

type alias Model = {
    pageSize : Int,
    pageIndex : Int
}

initialModel : Model
initialModel = Model 20 0

view : Int -> Model -> Address Model -> Html
view total paging address =
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
               onClick address { paging | pageIndex <- (pageIndex - 1) }] [text "Previous"],
           span [class "total-pages"] [ text ("Page " ++ (toString (watch "pageNum" pageNum)) ++ " of " ++ (toString pageCount)) ],    
           button [class "button next",
                disabled lastPage, 
               onClick address { paging | pageIndex <- (pageIndex + 1) }] [text "Next"]]
