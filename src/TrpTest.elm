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
import Autocompleter.View as ACV
import Autocompleter.Types as ACT
import Autocompleter.State as ACS
import Filtering exposing (..)
import Debug exposing(log)

init: (Model, Cmd Msg)
init =
    let
        m = initialModel
    in
        (m, (getHotels m.autocompleter.selected))


initialModel : Model
initialModel =
    Model [] 0 (Criteria initialFilter initialSortOrder initialPager) ACT.initialModel

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

            AutocompleterUpdate sub ->
                let
                    (updated, localFx, rootFx) = ACS.update sub model.autocompleter
                in
                    ({model | autocompleter = updated}, Cmd.batch
                        [ Cmd.map AutocompleterUpdate localFx
                        , rootFx ])

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
                [ Html.map AutocompleterUpdate (ACV.view model.autocompleter)
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



