module Models exposing(..)

import Filters
import SortBar
import Pager
import Autocompleter
import HotelsList

type Msg =
    NoOp
    | LoadData HotelsList.HotelList
    | PageChange Pager.Model
    | FilterChange Filters.Model
    | SortChange SortBar.Model
    | AutocompleterUpdate Autocompleter.Msg

type alias Criteria =
    { filter : Filters.Model
    , sort : SortBar.Model
    , paging : Pager.Model
    }

type alias Model =
    { hotels : HotelsList.HotelList
    , total : Int
    , criteria : Criteria
    , autocompleter : Autocompleter.Model
    }
