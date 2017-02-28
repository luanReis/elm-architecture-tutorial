import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Char exposing (isDigit, isUpper, isLower)
import String exposing (all, any, length)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { name : String
  , age : String
  , password : String
  , passwordAgain : String
  , validation : (Bool, String)
  }


model : Model
model =
  Model "" "" "" "" (False, "")



-- UPDATE


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Validate


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = age }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Validate ->
      { model | validation = validate model }


validate : Model -> (Bool, String)
validate model =
  if not (all isDigit model.age) then
    (False, "Age must be a number!")
  else if not (model.password == model.passwordAgain) then
    (False, "Passwords do not match!")
  else if not (any isUpper model.password) then
    (False, "Password should contain at least 1 upper case character!")
  else if not (any isLower model.password) then
    (False, "Password should contain at least 1 lower case character!")
  else if not (any isDigit model.password) then
    (False, "Password should contain at least 1 numeric character!")
  else if not (length model.password > 8) then
    (False, "Password should be longer than 8 characters!")
  else
    (True, "OK")


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "text", placeholder "Age", onInput Age ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick Validate ] [ text "Submit" ]
    , viewValidation model
    ]


viewValidation : Model -> Html Msg
viewValidation model =
  let
    (color, message) =
      let (valid, message) =
        model.validation
      in
        if valid then
          ("green", message)
        else
          ("red", message)
  in
    div [ style [("color", color)] ] [ text message ]
