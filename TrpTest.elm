module TrpTest where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (toUpper, repeat, trimRight, reverse)
import StartApp.Simple as StartApp
import Signal exposing (Address)
import Header
import SortBar
import Pager
import Filters
import HotelsList

--MODEL
type Star = One | Two | Three | Four | Five

type alias Hotel = {
    name : String,
    image : String,
    stars : Star,
    rating : Int,
    price : Float
}

type alias Paging = {
    pageSize : Int,
    pageIndex : Int
}

type Direction = Asc | Desc

type Sort = 
    Stars Direction 
    | Rating Direction
    | HotelName Direction
    | Price Direction

type alias Filter = {
    stars : List Star,
    minRating : Int,
    hotelName : String,
    minPrice : Float
}

type alias Criteria = {
    filter : Filter,
    sort : Sort,
    paging : Paging
}

type alias Model = { 
    criteria : Criteria, 
    hotels : List Hotel
}

initialModel : Model   
initialModel = { criteria = Criteria (Filter [] 0 "" 0) (HotelName Asc) (Paging 10 0),
    hotels = [] }

--UPDATE
type Action = NoOp

update: Action -> Model -> Model
update action model = model

--VIEW

view: Address Action -> Model -> Html
view address model = 
    div [] [
        section [ class "header" ] [
            Header.header
        ],
        section [ class "sidebar" ] [ 
            Filters.filters,
            SortBar.sortBar
        ],
        section [ class "content" ] [
            Pager.pager,
            (HotelsList.hotelList address model),
            Pager.pager
        ], 
        section [class "footer"] [ h3 [] [text "This is the footer"]]]

main : Signal Html
main = 
    StartApp.start { model = initialModel, view =  view, update = update }
