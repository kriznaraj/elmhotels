module Models where

type Action =
    NoOp
    | LoadData HotelList
    | PageChange Paging
    | FilterChange Filter
    | SortChange Sort

type alias Hotel = {
    name : String,
    thumbnail : String,
    image : String,
    stars : Int,
    rating : Float,
    price : Float
}

type alias Paging = {
    pageSize : Int,
    pageIndex : Int
}

type Direction = Asc | Desc

type Sort = 
    Stars 
    | Rating 
    | HotelName 
    | Price 

type alias Filter = {
    stars : List Int,
    minRating : Float,
    hotelName : String,
    minPrice : Float
}

type alias Criteria = {
    filter : Filter,
    sort : Sort,
    paging : Paging
}

type alias HotelList = (List Hotel)

type alias Model = {
    hotels : HotelList,
    total : Int,
    criteria : Criteria
}
