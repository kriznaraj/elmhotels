module Pager where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Signal exposing (Address)
import Debug exposing (log)

-- this needs to be enhanced because I need to know the total number of pages so that
-- I can enable and disable the pager buttons correctly 
replacePageIndex : Criteria -> Int -> Criteria
replacePageIndex criteria index =
    let paging = criteria.paging
    in
        { criteria | paging <- { paging | pageIndex <- index} }

pager : Model -> Address Criteria -> Html
pager model address =
    let criteria = model.criteria
        paging = model.criteria.paging
        pageIndex = paging.pageIndex
        hotelCount = List.length model.hotels
        firstPage = pageIndex == 0
        lastPage = pageIndex == (hotelCount // paging.pageSize)
    in
        section [ class "pager"] [ 
           div [class "button prev",
               onClick address (replacePageIndex criteria (pageIndex - 1))] [text "Previous"],
           div [class "button next",
               onClick address (replacePageIndex criteria (pageIndex + 1))] [text "Next"]]
