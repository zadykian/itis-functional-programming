import Test.HUnit

import GameBoard
import AtomicCell
import BoardSegmentState
import Player
import PlayerTurn
import BoardSegment
import GameState

main :: IO Counts
main = runTestTT $ TestList $ map (uncurry TestLabel) [
    ("empty local board creation", createEmptyLocalBoard),
    ("empty global board creation", createEmptyGlobalBoard),
    ("apply turn to empty local board", applyTurnToEmptyLocalBoard),
    ("apply turn to empty global board", applyTurnToEmptyGlobalBoard),
    ("board is owned by X", localBoardIsOwned),
    ("apply turn of X to game state", applyTurnToGameState)]

{-|
    Тест создания пустого локального поля.
-}
createEmptyLocalBoard :: Test
createEmptyLocalBoard = TestCase (
    assertEqual "emptyLocalBoard"
        (GameBoard $ replicate 9 $ AtomicCell Free)
        emptyLocalBoard
    )

{-|
    Тест создания пустого глобального поля.
-}
createEmptyGlobalBoard :: Test
createEmptyGlobalBoard = TestCase (
    assertEqual "emptyGlobalBoard"
        (GameBoard $ replicate 9 emptyLocalBoard)
        emptyGlobalBoard
    )

{-|
    Применить ход к пустому локальному полю.
-}
applyTurnToEmptyLocalBoard :: Test
applyTurnToEmptyLocalBoard = TestCase (
    assertEqual "turn to empty local board"
        (GameBoard $ AtomicCell (Owned X) : replicate 8 emptyAtomicCell)
        (applyTurn playerTurn emptyLocalBoard)
    )
    where playerTurn = PlayerTurn [toEnum 0] X

{-|
    Применить ход к пустому глобальному полю.
-}
applyTurnToEmptyGlobalBoard :: Test
applyTurnToEmptyGlobalBoard = TestCase (
    assertEqual "turn to empty global board"
        (GameBoard $ modifiedLocalBoard : replicate 8 emptyLocalBoard)
        (applyTurn playerTurn emptyGlobalBoard)
    )
    where
        playerTurn = PlayerTurn [toEnum 0, toEnum 4] O
        modifiedLocalBoard = GameBoard $
            replicate 4 emptyAtomicCell ++
            [AtomicCell (Owned O)] ++
            replicate 4 emptyAtomicCell

{-|
    Получить состояние локального поля, захваченного игроком X.
-}
localBoardIsOwned :: Test
localBoardIsOwned = TestCase (
    assertEqual "local board is owned"
        (Owned X)
        (state localBoard)
    )
    where
        localBoard = GameBoard $ map AtomicCell
            [
                Owned X, Free, Free,
                Free, Owned X, Free,
                Free, Free, Owned X
            ]

{-|
    Применить ход игрока 'X' к состоянию игры.
-}
applyTurnToGameState :: Test
applyTurnToGameState = TestCase (
    assertEqual "apply turn of X"
        (Right gameStateAfterTurn)
        (tryApplyTurn currentPlayerTurn gameStateBeforeTurn)
    )
    where
        currentPlayerTurn = PlayerTurn [toEnum 2, toEnum 3] X
        gameStateBeforeTurn = GameState globalBoardBeforeTurn $ Just $ PlayerTurn [toEnum 5, toEnum 8] O
        gameStateAfterTurn = GameState globalBoardAfterTurn $ Just currentPlayerTurn

        {-
            Глобальное поле до применения хода:
            
            X__ | _OO | O_X
            _X_ | _X_ | _OX
            __X | ___ | XXO
            ---------------
            OOO | _X_ | _XX
            X_X | OXO | XOX
            XXO | _X_ | __O
            ---------------
            
        -}
        globalBoardBeforeTurn = GameBoard $ map createLocalBoard
            [
                -- LocalBoard '0'
                [ Owned X, Free, Free, Free, Owned X, Free, Free, Free, Owned X ],
                -- LocalBoard '1'
                [ Free, Owned O, Owned O, Free, Owned X, Free, Free, Free, Free ],
                -- LocalBoard '2'
                [ Owned O, Free, Owned X, Free, Owned O, Owned X, Owned X, Owned X, Owned O],
                -- LocalBoard '3'
                [ Owned O, Owned O, Owned O, Owned X, Free, Owned X, Owned X, Owned X, Owned O],
                -- LocalBoard '4'
                -- todo
                [ Owned X, Free, Free, Free, Owned X, Free, Free, Free, Owned X
                ],
                -- локальное поле '5'
                [
                    Owned X, Free, Free,
                    Free, Owned X, Free,
                    Free, Free, Owned X
                ],
                -- локальное поле '6'
                [
                    Owned X, Free, Free,
                    Free, Owned X, Free,
                    Free, Free, Owned X
                ],
                -- локальное поле '7'
                [
                    Owned X, Free, Free,
                    Free, Owned X, Free,
                    Free, Free, Owned X
                ],
                -- локальное поле '8'
                [
                    Owned X, Free, Free,
                    Free, Owned X, Free,
                    Free, Free, Owned X
                ]
            ]


        globalBoardAfterTurn = undefined :: GlobalBoard

        createLocalBoard :: [BoardSegmentState] -> LocalBoard
        createLocalBoard stateList = GameBoard $ map AtomicCell stateList