module TrpTest where

import Task exposing (..)
import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import StartApp as StartApp
import Signal exposing (Address)
import Api exposing (getHotels)
import Header
import SortBar 
import Pager
import Filters
import HotelsList
import Autocompleter exposing (..)
import Models exposing (..)
import Filtering exposing (..)

--MODEL
initialModel : Model
initialModel =
    Model [] 0 (Criteria (Filter [] 0 "" 0) HotelName (Paging 20 0)) [] "" (Destination 0 0 0 0 0 0 0 "")

--UPDATE
update : Action -> Model -> (Model, Effects Action)
update action model =
    let criteria = model.criteria
        updateCriteria = (\model criteria -> { model | criteria <- criteria })
    in
        case action of
            NoOp ->
                (model, Effects.none)

            PageChange paging ->
                (updateCriteria model { criteria | paging <- paging }, Effects.none)

            FilterChange filter ->
                (updateCriteria model { criteria | filter <- filter }, Effects.none)

            SortChange sort ->
                (updateCriteria model { criteria | sort <- sort }, Effects.none)

            LoadData hotels ->
                ({model | hotels <- hotels}, Effects.none)

            LoadDestinations destinations -> 
                ({model | destinations <- destinations}, Effects.none)

            DestinationQueryChanged query -> 
                ({model | destinationQuery <- query}, Effects.task (getDestinations query))

            SelectDestination dest -> 
                ({model | selectedDestination <- dest}, Effects.task (getHotels dest))

--VIEW
view: Address Action -> Model -> Html
view address model =
    let filtered = restrict model
    in
        div [] [
            section [ class "header" ] [
                Header.header
            ],
            section [ class "sidebar" ] [ 
                --Autocompleter.view,
                (Filters.filters filtered.criteria.filter (Signal.forwardTo address FilterChange))
            ],
            section [ class "content" ] [
                (SortBar.sortBar filtered.criteria.sort (Signal.forwardTo address SortChange)),
                (Pager.pager filtered.total filtered.criteria.paging (Signal.forwardTo address PageChange)),
                (HotelsList.hotelList filtered.hotels)
            ], 
            section [class "footer"] [
                h3 [] [text "My beautiful footer section"]]
            ]

--WIRING
app =
    StartApp.start
       {init = (initialModel, Effects.task (getHotels initialModel.selectedDestination)),
        view = view,
        update = update,
        inputs = [] }

main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

