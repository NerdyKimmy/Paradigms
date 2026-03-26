-- 59. Підрахувати кількість додатних чисел у списку та сформувати список з номерами позицій цих чисел.

module Main where

findPositives :: [Int] -> Int -> [Int]
findPositives [] _ = []
findPositives (x:xs) index
  | x > 0     = index : findPositives xs (index + 1)
  | otherwise = findPositives xs (index + 1)       

findPositivePositions :: [Int] -> [Int]
findPositivePositions list = findPositives list 0

main :: IO ()
main = do
  putStrLn "Enter a list of numbers separated by spaces:"
  inputList <- getLine
  let list = map read (words inputList) :: [Int]

  let positions = findPositivePositions list
  
  let count = length positions

  putStrLn $ "Count of positive numbers: " ++ show count
  putStrLn "Positions of positive numbers (0-based indexing):"
  print positions
