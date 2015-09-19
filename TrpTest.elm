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

type alias Model = (List Hotel)

initialModel : Model   
initialModel = []

--UPDATE
type Action = NoOp

update: Action -> Model -> Model
update action model = model

--VIEW

view: Model -> Html
view hotels = 
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
            (HotelsList.hotelList hotels),
            Pager.pager
        ], 
        section [class "footer"] [ h3 [] [text "This is the footer"]]]

-- main : Signal Html
-- main = 
--     StartApp.start { model = initialModel, view =  view, update = update }

main =
    Signal.map view restrictedResults

page : Paging -> Model -> Model
page paging hotels =
    hotels

sort : Sort -> Model -> Model
sort sortOrder hotels =
    hotels

filter : Filter -> Model -> Model
filter filterCriteria hotels =
    hotels

restrict : Model -> Criteria -> Model
restrict hotels criteria =
    hotels
        |> filter criteria.filter
        |> sort criteria.sort
        |> page criteria.paging

restrictedResults : Signal Model
restrictedResults =
    Signal.map2 restrict results.signal query.signal
     
query : Signal.Mailbox Criteria
query = 
    Signal.mailbox (Criteria (Filter [] 0 "" 0) (HotelName Asc) (Paging 10 0))

results : Signal.Mailbox Model
results = 
    Signal.mailbox []

--if we have any sort of error just return no results
unwrapHotels : (Result Http.Error Model) -> (Task x ())
unwrapHotels result =
    case result of
        Err _ -> Signal.send results.address []
        Ok hotels -> Signal.send results.address hotels

port requests : (Task x ())
port requests =
     Task.toResult getHotels 
         `andThen` unwrapHotels

getHotels : Task Http.Error Model
getHotels =
    Http.get hotels ("hotels.json")

hotels : Json.Decoder Model
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

