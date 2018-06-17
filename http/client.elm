module Main exposing (..)

import Html exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN


type alias Model =
    { clickTimes : Int
    }


initModel : Model
initModel =
    { clickTimes = 0
    }


type Msg
    = Click
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click ->
            model ! []

        NoOp ->
            model ! []


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , Grid.row 
            [Row.aroundXs
            , Row.middleXs
            , Row.attrs [Spacing.p3]]
            [ Grid.col [Col.mdAuto]
                [ Button.button
                    [ Button.primary
                    , Button.onClick Click
                    ]
                    [ text "The Button" ]
                ]
            , Grid.col [Col.mdAuto]
                [text <| (++) "Times clicked: " <| toString model.clickTimes]
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
