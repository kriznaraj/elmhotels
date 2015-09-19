module TrpTest where

import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
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
    thumbnail : String,
    image : String,
    stars : Int,
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

query : Signal.Mailbox Criteria
query = 
    Signal.mailbox (Criteria (Filter [] 0 "" 0) (HotelName Asc) (Paging 10 0))

results : Signal.Mailbox (Result Http.Error (List Hotel))
results = 
    Signal.mailbox (Ok [])

port requests : Signal (Task x ())
port requests =
    Signal.map getHotels query.signal
      |> Signal.map (\task -> Task.toResult task `andThen` Signal.send results.address)

getHotels : Criteria -> Task Http.Error (List Hotel)
getHotels query =
    Http.get hotels ("hotels.json")

hotels : Json.Decoder (List Hotel)
hotels = 
    let hotel =
        Json.object6 Hotel
           ("Name" := Json.string)
           ("ThumbnailUrl" := Json.string)
           ("ImageUrl" := Json.string)
           ("Stars" := Json.int)
           ("UserRating" := Json.int)
           ("MinCost" := Json.float)
    in
       "Establishments" := Json.list hotel

