module Main exposing (..)

import Html exposing (..)
import WebSocket
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
    | DataReceived String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Click ->
            model ! [ WebSocket.send "ws://lvh.me:8888/count" "AddOne" ]

        DataReceived wsMsg ->
            case String.toInt wsMsg of
                Ok newClicks ->
                    { model | clicks = newClicks } ! []

                Err error ->
                    { model | errorText = error } ! []


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


subs : Model -> Sub Msg
subs model =
    WebSocket.listen "ws://lvh.me:8888/count" DataReceived


main : Program Never Model Msg
main =
    Html.program
        { init = initModel ! []
        , view = view
        , update = update
        , subscriptions = subs
        }
