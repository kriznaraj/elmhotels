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

view: Model -> Html
view model = 
    div [] [
        section [ class "header" ] [
            Header.header
        ],
        section [ class "sidebar" ] [ 
            (Filters.filters model.criteria query.address),
            SortBar.sortBar
        ],
        section [ class "content" ] [
            Pager.pager,
            (HotelsList.hotelList model.hotels),
            Pager.pager
        ], 
        section [class "footer"] [ h3 [] [text "This is the footer"]]]

main =
    Signal.map view restrictedResults

restrictedResults : Signal Model
restrictedResults =
    Signal.map2 restrict results.signal query.signal
     
query : Signal.Mailbox Criteria
query = 
    Signal.mailbox (Criteria (Filter [] 0 "" 0) (HotelName Asc) (Paging 25 0))

results : Signal.Mailbox HotelList
results = 
    Signal.mailbox []

--if we have any sort of error just return no results
unwrapHotels : (Result Http.Error HotelList) -> (Task x ())
unwrapHotels result =
    case result of
        Err e -> 
            log (toString e) Signal.send results.address []
        Ok hotels -> 
            Signal.send results.address hotels

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

