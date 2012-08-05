import Graphics.UI.WX
import Data.Time.Clock

data Direction = LEFT | RIGHT deriving Eq
type Record = (Int,Int,NominalDiffTime)

(winW,winH) = (1200,600)

main = start $ gui 10 []

gui :: Int -> [Record] -> IO()
gui n rs = do
    seed <- (return.read.take 2.show=<<nowTime :: IO Int)
    let direction =  if mod seed 2 == 0 then LEFT else RIGHT
        width = (mod seed 8 + 1)*30
        distance = (mod seed 5+1)*50
    f <- frame [text := "フィッツの法則の追実験"]
    p <- panel f []
    from <- getCurrentTime
    lBtn <- button p [ on command := clicked f n width distance (LEFT==direction) from rs
                      ,clientSize := sz (div winH 4 - div width 2)  (winH-100)]
    rBtn <- button p [ on command := clicked f n width distance (RIGHT==direction) from rs
                      ,clientSize := sz ((div winH 4)*3 - div width 2) (winH-100)]
    set p [layout := column 2 [ row 3 [ minsize (sz 400 100) $ label ""
                                       ,minsize (sz 400 100) $ label "待機中"
                                       ,minsize (sz 400 100) $ label ""]
                               ,row 5 [ minsize (sz (div winW 2 -width-distance) (winH-100)) $ label ""
                                       ,widget lBtn
                                       ,minsize (sz (distance*2) (winH-100)) $ label ""
                                       ,widget rBtn
                                       ,minsize (sz (div winW 2-width-distance) (winH-100)) $ label ""]]]
    set f [layout := widget p , clientSize := sz winW winH]

clicked _ _ _ _ False _ _ = return ()
clicked f n w d True from rs = do
    now <- getCurrentTime
    let span = subTime now from
    close f
    gui (n-1) ((w,d,span):rs)

subTime now from = now `diffUTCTime` from

nowTime = return.utctDayTime =<< getCurrentTime
