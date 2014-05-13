import System.Random
import System.Time
import Control.Applicative

data State = Clear Int | GameOver Int | OnPlay Int
data Field = Field [[Int]]

instance Show Field where
	show (Field xs) = concat (map show' xs) ++ horizon where
		show' xs = horizon ++ vert ++ concat (map f xs) ++ "|\n" ++ vert
		horizon = replicate 20 '-' ++ "\n"
		vert = concat (replicate 4 "|    ") ++ "|\n"
		f x = "|" ++ replicate (4-length (show x)) ' ' ++ show x

instance Show State where
	show state =header ++ "\n" ++ "SCORE : " ++ show (getScore state) where
		header = case state of
			(Clear _) -> replicate 30 '*' ++ "CLEAR" ++ replicate 30 '*' 
			(GameOver _) -> replicate 20 '*' ++ "GAME OVER..." ++ replicate 20 '*' 
			(OnPlay _) -> []

getScore (Clear score) = score
getScore (OnPlay score) = score
getScore (GameOver score) = score

initialize a b = Field $ divide 4 $ replicate i 0 ++ [2] ++ replicate (j-i-1) 0 ++ [2] ++ replicate (16-max i j - 1) 0 where
	i1 = mod a 16 `min` mod b 16
	i2 = mod a 16 `max` mod b 16
	(i,j) = if i1 == i2 then (i1,i2+1) else (i1,i2)
	divide n [] = []
	divide n xs = take n xs : divide n (drop n xs)

main = do
	time <- toUTCTime <$> getClockTime
	let initField = initialize (ctSec time) (ctMin time)
	result <- game initField (OnPlay 0)
	putStrLn $ show result
	writeFile (show $ getScore result) "score.txt"

game :: Field -> State -> IO State
game field (OnPlay score) = do
	putStrLn $ show field
	command <- getChar
	return $ uncurry game $ next command field state
game filed result = return result

cannotMove :: [[Int]] -> Bool
connotMove fd = foldl (check fd) True [0..15]

--i:縦, j:横
check :: [[Int]] -> Bool -> Int -> Bool
check fd result a = any (filp at fd == at (i,j) fd || flip at fd == 0) where
	(i,j) = toIndex a
	poses = filter inField [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]

toIndex a = (div a 4, mod a 4)
at (i,j) fd = (fd !! i) !! j
inField (i,j) = 0 <= i && i < 4 && 0 <= j && j < 4

next :: Key -> Field -> State -> (Field,State)
next key (Field fd) st = if any (==2048) $ concat fd
	then Clear (getScore st)
	else if cannotMove fd
		then GameOver (getScore st)
		else undefined
