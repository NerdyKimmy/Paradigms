{-Розбити заданий список на кілька списків, записуючи у перший список значення, які менші за 1!, у другий
– які менші за 2! та не потрапили до попереднього списку, у третій – які менші за 3! та не потрапили до
двох попередніх списків, у четвертий – які менші за 4! та не потрапили до попередніх списків і т.д.-}

module Main where

factorials :: [Int]
factorials = scanl1 (*) [1..]

splitByFactorialsHelper :: [Int] -> [Int] -> [[Int]]
splitByFactorialsHelper [] _ = [] 
splitByFactorialsHelper nums (f:fs) =
  let currentList = filter (< f) nums    
      remainingNums = filter (>= f) nums 
  in currentList : splitByFactorialsHelper remainingNums fs
splitByFactorialsHelper _ [] = []       

splitByFactorials :: [Int] -> [[Int]]
splitByFactorials nums = splitByFactorialsHelper nums factorials

safeRead :: String -> Maybe Int
safeRead s = case reads s of
  [(num, "")] -> Just num
  _           -> Nothing

processInput :: IO ()
processInput = do
  putStrLn "Введіть список цілих чисел через пробіл:"
  inputList <- getLine
  
  let maybeList = mapM safeRead (words inputList)
  
  case maybeList of
    Just list -> do
      putStrLn "Результат розбиття списку за факторіалами:"
      print (splitByFactorials list)
      
    Nothing -> do
      putStrLn "Помилка, будь ласка, введіть тільки цілі числа через пробіл."
      processInput

main :: IO ()
main = processInput
