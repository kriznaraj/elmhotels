module Pager exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (log)
import Models exposing (..)


view : Int -> Pager -> Html Msg
view total paging =
    let pageIndex = paging.pageIndex
        pageNum = pageIndex + 1
        hotelCount = toFloat (total)
        pageSize = toFloat paging.pageSize
        pageCount = (ceiling (hotelCount / pageSize))
        firstPage = pageIndex == 0
        lastPage = pageNum == pageCount
    in
        section [ class "pager"] [ 
           button
              [ class "button prev"
              , disabled firstPage
              , onClick (PageChange { paging | pageIndex = (pageIndex - 1) })
              ] [text "Previous"],
           span
              [ class "total-pages"]
              [ text ("Page " ++ (toString pageNum) ++ " of " ++ (toString pageCount)) ],
           button
              [ class "button next"
              , disabled lastPage
              , onClick (PageChange { paging | pageIndex = (pageIndex + 1) })
              ] [text "Next"]]
