module Models where

type Star = One | Two | Three | Four | Five

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
    Stars Direction 
    | Rating Direction
    | HotelName Direction
    | Price Direction

type alias Filter = {
    stars : List Star,
    minRating : Int,
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
    criteria : Criteria
}
