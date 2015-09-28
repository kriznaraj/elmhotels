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
import Debug exposing (log)
import Models exposing (..)
import Filtering exposing (..)
import Time
import Debug exposing (watch)

type Action = 
    NoOp 
    | LoadData HotelList
    | PageChange Paging
    | FilterChange Filter
    | SortChange Sort

updateCriteria : Model -> Criteria -> Model
updateCriteria model criteria =
    { model | criteria <- criteria }

update : Action -> Model -> Model
update action model =
    let criteria = model.criteria
    in
        case action of
            NoOp -> model
            PageChange paging -> updateCriteria model { criteria | paging <- paging }
            FilterChange filter -> updateCriteria model { criteria | filter <- filter }
            SortChange sort -> updateCriteria model { criteria | sort <- sort }
            LoadData hotels -> {model | hotels <- hotels}

view: Model -> Html
view model = 
    let filtered = restrict2 model
    in
        div [] [
            section [ class "header" ] [
                Header.header
            ],
            section [ class "sidebar" ] [ 
                (Filters.filters model.criteria.filter)
            ],
            section [ class "content" ] [
                (SortBar.sortBar model.criteria.sort (Signal.forwardTo actions.address SortChange)),
                (Pager.pager filtered.total model.criteria.paging (Signal.forwardTo actions.address PageChange)),
                (HotelsList.hotelList filtered.hotels)
            ], 
            section [class "footer"] [ h3 [] [text "My beautiful footer section"]]]

initialModel : Model
initialModel =
    Model [] 0 (Criteria (Filter [] 0 "" 0) HotelName (Paging 20 0))

model : Signal Model
model =
    Signal.foldp update initialModel actions.signal

actions : Signal.Mailbox Action
actions = 
    Signal.mailbox NoOp

main =
    Signal.map view model
-- main =
--     Signal.map view restrictedResults

-- criteria : Signal Criteria
-- criteria =
--     Signal.map3 
--         (\pager sort filters -> Criteria filters sort pager) 
--         Pager.signal
--         SortBar.signal 
--         Filters.signal

-- restrictedResults : Signal Model
-- restrictedResults =
--     Signal.map2 restrict results.signal criteria
     
-- results : Signal.Mailbox HotelList
-- results = 
--     Signal.mailbox []

--if we have any sort of error just return no results
unwrapHotels : (Result Http.Error HotelList) -> (Task x ())
unwrapHotels result =
    case result of
        Err e -> 
            -- log (toString e) Signal.send results.address []
            log (toString e) Signal.send actions.address (LoadData [])
            
        Ok hotels -> 
            -- Signal.send results.address hotels
            Signal.send actions.address (LoadData hotels)

port requests : (Task x ())
port requests =
     Task.toResult getHotels 
         `andThen` unwrapHotels

getHotels : Task Http.Error HotelList
getHotels =
    Http.get hotels ("hotels.json")

hotels : Json.Decoder HotelList
hotels = 
    let hotel =
        Json.object6 Hotel
           ("Name" := Json.string)
           ("ThumbnailUrl" := Json.string)
           ("ImageUrl" := Json.string)
           ("Stars" := Json.int)
           ("UserRating" := Json.float)
           ("MinCost" := Json.float)
    in
       "Establishments" := Json.list hotel

