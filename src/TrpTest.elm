module TrpTest exposing(..)

import Task exposing (..)
import Html exposing (..)
import Html.App as Html exposing (map)
import Html.Attributes exposing (..)
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

init: (Model, Cmd Msg)
init =
    (initialModel, Cmd.none)

initialModel : Model
initialModel =
    Model [] 0 (Criteria initialFilter initialSortOrder initialPager) Autocompleter.initialModel

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let criteria = model.criteria
        updateCriteria = (\model criteria -> { model | criteria = criteria })
    in
        case msg of
            NoOp ->
                (model, Cmd.none)

            PageChange paging ->
                (updateCriteria model { criteria | paging = paging }, Cmd.none)

            FilterChange filter ->
                (updateCriteria model { criteria | filter = filter }, Cmd.none)

            SortChange sort ->
                (updateCriteria model { criteria | sort = sort }, Cmd.none)

            HotelsLoadSucceeded hotels ->
                ({model | hotels = hotels}, Cmd.none)

            HotelsLoadFailed err ->
                let
                    e = log "hotels failed to load: " err
                in
                    (model, Cmd.none)

            AutocompleterUpdate msg ->
                let (m, e) = Autocompleter.update msg model.autocompleter
                in
                    case msg of
                        Autocompleter.SelectDestination dest -> 
                            ({model | autocompleter = m, hotels = []}, 
                            Cmd.batch [
                                getHotels dest,
                                Cmd.map AutocompleterUpdate e
                            ])
                        
                        _ -> ({model | autocompleter = m}, Cmd.map AutocompleterUpdate e)


--VIEW
view: Model -> Html Msg
view model =
    let filtered = restrict model
    in
        div [] [
            section [ class "header" ] [
                Header.header
            ],
            section [ class "sidebar" ]
                [ Html.map AutocompleterUpdate (Autocompleter.view model.autocompleter)
                , Filters.view filtered.criteria.filter
                ],
            section [ class "content" ]
                [ SortBar.view filtered.criteria.sort
                , Pager.view filtered.total filtered.criteria.paging
                , (HotelsList.hotelList filtered.hotels)
            ], 
            section [class "footer"] [
                h3 [] [text "My beautiful footer section"]]
            ]

main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



