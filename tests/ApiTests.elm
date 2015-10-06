import String

import ElmTest.Test exposing (test, Test, suite)
import ElmTest.Assertion exposing (assert, assertEqual)
import ElmTest.Runner.Element exposing (runDisplay)
import Api exposing (..)
import Json.Decode as Json
import Models exposing (..)


hotelJson : String
hotelJson =
    """{ "Establishments" : [ { "Name" : "Test Hotel", "ThumbnailUrl" : "url", "ImageUrl" : "url", "Stars" : 4, "UserRating" : 4.5, "MinCost" : 100.55 } ] }"""

parseResult : Result String HotelList -> String
parseResult result =
    case result of
        Ok _ -> "PASS"
        Err e -> e

hotelsDecoderWorks : Test
hotelsDecoderWorks =
    test "hotels decoder works"
        (assertEqual "PASS" (parseResult (Json.decodeString hotels hotelJson)))

imageUrlIsCorrect : Test
imageUrlIsCorrect =
    test "imageUrl gives correct result" (assertEqual (imageUrl "/12345")
        "https://d23wf1heedwns1.cloudfront.net/ei/12345/0_260_260.jpg")

estabToImageUrlCorrect : Test
estabToImageUrlCorrect =
    test "estabToImageUrl gives correct results"
        (assertEqual (estabIdToImageUrl 12345)
         "https://d23wf1heedwns1.cloudfront.net/ei/1/2/3/4/5/0_260_260.jpg")

tests : Test
tests = suite "Some tests on the api layer"
        [ imageUrlIsCorrect
        , estabToImageUrlCorrect
        , hotelsDecoderWorks
        ]

--main : Element
main = runDisplay tests