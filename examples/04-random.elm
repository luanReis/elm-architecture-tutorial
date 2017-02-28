import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import List exposing (..)
import Random



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { firstDieFace : Int
  , secondDieFace : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | FirstDieNewFace Int
  | SecondDieNewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate FirstDieNewFace (Random.int 1 6))

    FirstDieNewFace newFace ->
      ({model | firstDieFace = newFace }, Random.generate SecondDieNewFace (Random.int 1 6))

    SecondDieNewFace newFace ->
      ({model | secondDieFace = newFace }, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ dieFaceSvg model.firstDieFace
    , dieFaceSvg model.secondDieFace
    , button [ onClick Roll ] [ Html.text "Roll" ]
    ]


dieFaceSvg : Int -> Html Msg
dieFaceSvg dieFace =
  svg [ width "100", height "100" ]
      ( List.append [ rect [ fill "white"
                          , strokeWidth "3"
                          , stroke "grey"
                          , x "1"
                          , y "1"
                          , width "97"
                          , height "97"
                          , rx "15"
                          , ry "15"
                          ]
                          []
                   ] (dieFaceCircles dieFace)
      )


dieFaceCircles : Int -> List (Svg Msg)
dieFaceCircles dieFace =
  List.map dieFaceCircle (dieFaceCirclesPosition dieFace)


dieFaceCircle : { cx : String, cy : String } -> Svg Msg
dieFaceCircle position =
  circle [ fill "grey", cx position.cx, cy position.cy, r "10" ] []


dieFaceCirclesPosition : Int -> List { cx : String, cy : String }
dieFaceCirclesPosition dieFace =
  case dieFace of
    1 -> [ { cx = "49", cy = "49"}
         ]
    2 -> [ { cx = "19", cy = "79"}
         , { cx = "79", cy = "19"}
         ]
    3 -> [ { cx = "19", cy = "79"}
         , { cx = "49", cy = "49"}
         , { cx = "79", cy = "19"}
         ]
    4 -> [ { cx = "19", cy = "19"}
         , { cx = "19", cy = "79"}
         , { cx = "79", cy = "19"}
         , { cx = "79", cy = "79"}
         ]
    5 -> [ { cx = "19", cy = "19"}
         , { cx = "19", cy = "79"}
         , { cx = "49", cy = "49"}
         , { cx = "79", cy = "19"}
         , { cx = "79", cy = "79"}
         ]
    _ -> [ { cx = "19", cy = "19"}
         , { cx = "19", cy = "79"}
         , { cx = "19", cy = "49"}
         , { cx = "79", cy = "49"}
         , { cx = "79", cy = "19"}
         , { cx = "79", cy = "79"}
         ]
