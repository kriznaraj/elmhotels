module Pager where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Signal exposing (Address)

replacePageIndex : Criteria -> Int -> Criteria
replacePageIndex criteria index =
    let paging = criteria.paging
    in
        { criteria | paging <- { paging | pageIndex <- index} }

pager : Criteria -> Address Criteria -> Html
pager criteria address =
    section [ class "pager"] [ 
       div [class "button prev",
           onClick address (replacePageIndex criteria (criteria.paging.pageIndex - 1))] [text "Previous"],
       div [class "button next",
           onClick address (replacePageIndex criteria (criteria.paging.pageIndex + 1))] [text "Next"]]
