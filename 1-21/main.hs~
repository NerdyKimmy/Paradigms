-- Залишити у списку елементи, що входять у нього двічі.
module Main where

countOccurrences :: Int -> [Int] -> Int
countOccurrences n list = length (filter (== n) list)

keepTwice :: [Int] -> [Int]
keepTwice list = filter (\x -> countOccurrences x list == 2) list

safeRead :: String -> Maybe Int
safeRead s = case reads s of
  [(num, "")] -> Just num
  _           -> Nothing

processInput :: IO ()
processInput = do
  putStrLn "Введіть список номерів"
  inputList <- getLine
  
  let maybeList = mapM safeRead (words inputList)
  
  case maybeList of
    Just list -> do
      putStrLn "List after keeping elements that appear exactly twice:"
      print (keepTwice list)
      
    Nothing -> do
      putStrLn "Error, please enter only integer nums separated by spaces"
      processInput

main :: IO ()
main = processInput
