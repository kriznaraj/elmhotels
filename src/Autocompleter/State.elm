module Autocompleter.State exposing (update)

import Autocompleter.Types exposing (..)
import Autocompleter.Cmds exposing (..)
import Api exposing (getHotels)
import Models
import Debug exposing (log)
import String


update : Msg -> Model -> ( Model, Cmd Msg, Cmd Models.Msg )
update msg model =
    case msg of
        QueryChanged query ->
            let
                fx =
                    if String.length query > 2 then
                        getDestinations query
                    else
                        Cmd.none
            in
                ( { model | query = query }, fx, Cmd.none )

        SelectDestination dest ->
            ( { model | selected = dest, destinations = [], query = dest.title }, Cmd.none, (getHotels dest) )

        LoadResultsSucceeded results ->
            ( { model | destinations = results }, Cmd.none, Cmd.none )

        LoadResultsFailed err ->
            let
                e =
                    log "Autocompleter lookup failed: " err
            in
                ( model, Cmd.none, Cmd.none )
