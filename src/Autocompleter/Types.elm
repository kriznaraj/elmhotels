module Autocompleter.Types exposing (..)

import Destination exposing (Destination, DestinationList)
import Http exposing (..)


type alias Model =
    { destinations : DestinationList
    , query : String
    , selected : Destination
    }


initialModel : Model
initialModel =
    Model [] "Tenerife, Spain" tenerife


emptyDestination =
    Destination 0 0 0 0 0 0 0 ""


tenerife =
    Destination 3522 54875 0 0 0 0 0 "Tenerife, Spain"



--UPDATE


type Msg
    = QueryChanged String
    | SelectDestination Destination
    | LoadResultsSucceeded DestinationList
    | LoadResultsFailed Http.Error
