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
        pageNum = pageIndex + 1
        hotelCount = toFloat (model.total)
        pageCount = (ceiling (hotelCount / pageSize))
        pageSize = toFloat paging.pageSize
        firstPage = pageIndex == 0
        lastPage = pageNum == log "pages:" pageCount
    in
        section [ class "pager"] [ 
           button [class "button prev",
                disabled firstPage,
               onClick address (replacePageIndex criteria (pageIndex - 1))] [text "Previous"],
           span [class "total-pages"] [ text ("Page " ++ (toString pageNum) ++ " of " ++ (toString pageCount)) ],    
           button [class "button next",
                disabled lastPage, 
               onClick address (replacePageIndex criteria (pageIndex + 1))] [text "Next"]]
