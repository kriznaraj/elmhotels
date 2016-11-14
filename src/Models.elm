module Models exposing (..)

import Autocompleter.Types as AC
import Http


type alias Filter =
    { stars : List Int
    , minRating : Float
    , hotelName : String
    , minPrice : Float
    }


initialFilter : Filter
initialFilter =
    Filter [] 0 "" 0


type alias Pager =
    { pageSize : Int
    , pageIndex : Int
    }


initialPager : Pager
initialPager =
    Pager 20 0


type SortOrder
    = Stars
    | Rating
    | HotelName
    | Price


initialSortOrder : SortOrder
initialSortOrder =
    HotelName


type alias Hotel =
    { name : String
    , thumbnail : String
    , image : String
    , stars : Int
    , rating : Float
    , price : Float
    }


type alias HotelList =
    List Hotel


type Msg
    = NoOp
    | HotelsLoad (Result Http.Error HotelList)
    | PageChange Pager
    | FilterChange Filter
    | SortChange SortOrder
    | AutocompleterUpdate AC.Msg


type alias Criteria =
    { filter : Filter
    , sort : SortOrder
    , paging : Pager
    }


type alias Model =
    { hotels : HotelList
    , total : Int
    , criteria : Criteria
    , autocompleter : AC.Model
    }
