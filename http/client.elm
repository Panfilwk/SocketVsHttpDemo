module Main exposing (..)

import Html exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN


type alias Model =
    { clicks : Int
    , errorText : String
    }


initModel : Model
initModel =
    { clicks = 0
    , errorText = ""
    }


type Msg
    = Click
    | DataReceived (Result Error Int)
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Click ->
            model ! [ updateCount ]

        DataReceived (Ok newClicks) ->
            { model | clicks = newClicks } ! []

        DataReceived (Err error) ->
            { model | errorText = "Unknown error" } ! []


updateCount : Cmd Msg
updateCount =
    send DataReceived (post "http://lvh.me:8888/count" emptyBody countDecoder)


countDecoder : Decoder Int
countDecoder =
    field "count" int


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , Grid.row
            [ Row.aroundXs
            , Row.middleXs
            , Row.attrs [ Spacing.p3 ]
            ]
            [ Grid.col [ Col.mdAuto ]
                [ Button.button
                    [ Button.primary
                    , Button.onClick Click
                    ]
                    [ text "The Button" ]
                ]
            , Grid.col [ Col.mdAuto ]
                [ text <| (++) "Times clicked: " <| toString model.clicks ]
            ]
        , Grid.row []
            [ Grid.col [ Col.mdAuto ] [ text model.errorText ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = initModel ! []
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
