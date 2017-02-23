module TryElm exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


main =
  beginnerProgram { model = model, view = view, update = update }


view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString (sum model.numbers)) ]
    , input [ placeholder "Text to add", onInput TextChange ] []
    , div [] [ text (toString model.names) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick ShowName ] [ text "AddName" ]
    ]

type alias Model  ={
 numbers: IntList,
 names: List String,
 name: String
}

model: Model
model = {numbers = Empty, names = EmptyList, name = ""}

type Msg = Increment | Decrement | ShowName | TextChange String


type IntList = Empty | Node Int IntList

type List a = EmptyList | Nodea a (List a)



sum : IntList -> Int
sum numbers =
  case numbers of
    Empty ->
      0

    Node n remainingNumbers ->
      n + sum remainingNumbers

addName: String -> List String -> List String
addName name names = Nodea name names

update msg model =
  case msg of
    Increment ->
      {model | numbers = Node 1 model.numbers}

    Decrement ->
      {model | numbers = Node -1 model.numbers}
      
    ShowName -> 
     {model | names = addName model.name model.names}
      
    TextChange name -> 
     {model | name = name}