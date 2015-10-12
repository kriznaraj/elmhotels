module TrpTest where

import Task exposing (..)
import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import StartApp as StartApp
import Signal exposing (Address)
import Api exposing (getHotels)
import Models exposing (..)
import Header
import SortBar 
import Pager
import Filters
import HotelsList
import Autocompleter 
import Filtering exposing (..)
import Debug exposing(log)

--MODEL
initialModel : Model
initialModel =
    Model [] 0 (Criteria Filters.initialModel SortBar.initialModel Pager.initialModel) Autocompleter.initialModel

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

            AutocompleterUpdate action ->
                let (m, e) = Autocompleter.update action model.autocompleter
                in
                    case action of
                        Autocompleter.SelectDestination dest -> 
                            ({model | autocompleter <- m, hotels <- []}, 
                            Effects.batch [
                                Effects.task (getHotels dest),
                                Effects.map AutocompleterUpdate e
                            ])
                        
                        _ -> ({model | autocompleter <- m}, Effects.map AutocompleterUpdate e)


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
                (Autocompleter.view (Signal.forwardTo address AutocompleterUpdate) model.autocompleter),
                (Filters.view filtered.criteria.filter (Signal.forwardTo address FilterChange))
            ],
            section [ class "content" ] [
                (SortBar.view filtered.criteria.sort (Signal.forwardTo address SortChange)),
                (Pager.view filtered.total filtered.criteria.paging (Signal.forwardTo address PageChange)),
                (HotelsList.hotelList filtered.hotels)
            ], 
            section [class "footer"] [
                h3 [] [text "My beautiful footer section"]]
            ]

--WIRING
app =
    StartApp.start
       {init = (initialModel, Effects.task (getHotels initialModel.autocompleter.selected)),
        view = view,
        update = update,
        inputs = [] }

main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

