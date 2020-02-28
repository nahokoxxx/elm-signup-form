module Main exposing (main)

import Browser
import Html exposing (Html, div, input, label, button, span, text)
import Html.Attributes exposing (class, value, type_)
import Html.Events exposing (onInput, custom)
import Json.Decode exposing (succeed)

main = Browser.sandbox
  { init = init
  , update = update
  , view = view
  }

type Form
  = FirstForm
  | SecondForm
  | ThirdForm

type alias Model = 
  { firstName : String
  , lastName : String
  , email : String
  , zipCode : String
  , currentForm : Form
  }

init : Model
init =
  Model "" "" "" "" FirstForm

type Msg
  = FirstName String
  | LastName String
  | Email String
  | ZipCode String
  | SubmitFirstForm
  | SubmitSecondForm
  | SubmitThirdForm

update : Msg -> Model -> Model
update msg model =
  case msg of
    FirstName firstName ->
      { model | firstName = firstName }
    LastName lastName ->
      { model | lastName = lastName }
    Email email ->
      { model | email = email }
    ZipCode zipCode ->
      { model | zipCode = zipCode }
    SubmitFirstForm ->
      -- TODO バリデーション
      { model | currentForm = SecondForm }
    SubmitSecondForm ->
      -- TODO バリデーション
      { model | currentForm = ThirdForm }
    SubmitThirdForm ->
      -- TODO バリデーション
      model

view : Model -> Html Msg
view model =
  div
    [ class "min-h-screen flex justify-center items-center bg-pink-100 p-4" ]
    [
      Html.form
        [ 
          Html.Events.custom
            "submit"
            (
              Json.Decode.succeed
                {
                  message = 
                    case model.currentForm of
                      FirstForm ->
                        SubmitFirstForm
                      SecondForm ->
                        SubmitSecondForm
                      ThirdForm ->
                        SubmitThirdForm
                  , stopPropagation = True
                  , preventDefault = True
                }
            )
          , class "flex flex-col items-center py-10 px-12 bg-pink-900 shadow-lg rounded-lg text-pink-100 w-full md:w-1/2 max-w-screen-sm"
        ]
        (
          (
            case model.currentForm of
              FirstForm ->
                [
                  formInput "お名前（姓）" model.lastName LastName ["mb-4"]
                  , formInput "お名前（名）" model.firstName FirstName ["mb-4"]
                  , formInput "メールアドレス" model.email Email ["mb-4"]
                  , formInput "郵便番号" model.zipCode ZipCode []
                ]
              SecondForm ->
                [] -- TODO
              ThirdForm ->
                [] -- TODO
          )
          ++ [
            button
              [
                type_ "submit"
                , class "mt-12 bg-pink-500 text-pink-900 px-12 py-2 shadow-md rounded-sm hover:bg-pink-400 transition-colors duration-200"
              ] [ text "次へ" ]
          ]
        )
    ]

formInput : String -> String -> (String -> msg) -> List String -> Html msg
formInput l v toMsg classes =
  label [ class ([ "flex", "items-center", "w-full" ] ++ classes |> String.join (String.fromChar ' ')) ]
  [
    span [ class "w-24 text-sm text-right text-pink-300" ] [ text l ]
    , input
      [
        class "flex-grow bg-transparent border-b-2 border-pink-300 py-1 focus:outline-none focus:border-pink-100 transition-colors duration-200 ml-2 tracking-wider"
        , value v
        , onInput toMsg
      ] []
  ]