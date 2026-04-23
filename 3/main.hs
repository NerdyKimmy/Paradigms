{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
-- 3. (11 балів). Детермінізація скінченого автомата.
import Data.Aeson
import GHC.Generics
import Data.Aeson.Encode.Pretty (encodePretty)
import qualified Data.ByteString.Lazy as B
import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Map (Map)
import Data.Set (Set)
import Data.List (intercalate)
import System.Environment (getArgs)

data NFA = NFA {
    alphabet    :: [String],
    transitions :: Map String (Map String [String]),
    start       :: String,
    finals      :: [String]
} deriving (Show, Generic)

instance FromJSON NFA
instance ToJSON NFA

data DFA = DFA {
    dfaStates      :: [String],
    dfaTransitions :: Map String (Map String String),
    dfaStart       :: String,
    dfaFinals      :: [String]
} deriving (Show, Generic)

instance ToJSON DFA

stateName :: Set String -> String
stateName s | Set.null s = "TRAP"
            | otherwise  = intercalate "," (Set.toAscList s)

determinize :: NFA -> DFA
determinize nfa = buildDFA Set.empty [startState] Map.empty
  where
    startState = Set.singleton (start nfa)

    getTrans :: String -> String -> [String]
    getTrans st sym = case Map.lookup st (transitions nfa) of
        Just symMap -> case Map.lookup sym symMap of
                         Just sts -> sts
                         Nothing  -> []
        Nothing -> []

    step :: Set String -> String -> Set String
    step states sym = Set.unions [Set.fromList (getTrans q sym) | q <- Set.toList states]

    buildDFA visited [] transAcc = 
        let dfaSts = Set.toList visited
            nfaFins = Set.fromList (finals nfa)
            isFinal st = not (Set.null (Set.intersection st nfaFins))
            dfaFins = filter isFinal dfaSts
            
            outStates = map stateName dfaSts
            outStart  = stateName startState
            outFinals = map stateName dfaFins
            outTrans  = Map.mapKeys stateName (Map.map (Map.map stateName) transAcc)
        in DFA outStates outTrans outStart outFinals

    buildDFA visited (curr:queue) transAcc
        | Set.member curr visited = buildDFA visited queue transAcc
        | otherwise =
            let nextMoves = [(sym, step curr sym) | sym <- alphabet nfa]
                newTransMap = Map.fromList nextMoves
                newTransAcc = Map.insert curr newTransMap transAcc
                
                newStates = map snd nextMoves
                newQueue = queue ++ newStates
                newVisited = Set.insert curr visited
            in buildDFA newVisited newQueue newTransAcc

-- | Точка входу
main :: IO ()
main = do
    args <- getArgs
    let inputFile = if null args then "1.json" else head args
    
    putStrLn $ "Читаємо файл: " ++ inputFile
    jsonData <- B.readFile inputFile
    
    case eitherDecode jsonData :: Either String NFA of
        Left err -> putStrLn $ "Помилка парсингу JSON: " ++ err
        Right nfa -> do
            let dfa = determinize nfa
            putStrLn "\nРезультат детермінізації (JSON)"
            B.putStr (encodePretty dfa)
            putStrLn "\n"
            
