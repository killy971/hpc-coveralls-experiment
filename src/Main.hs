module Main where

import Network.Curl
import System.Environment (getArgs)

postJson :: String -> String -> IO CurlResponse
postJson url jsonData = do
    curl <- initialize
    setopt curl (CurlURL url)
    setopt curl (CurlPost True)
    setopt curl (CurlPostFields [jsonData])
    setopt curl (CurlHttpHeaders ["Content-Type: application/json"])
    response <- perform_with_response_ curl
    reset curl
    return response

main :: IO ()
main = do
    args <- getArgs
    case args of
        [jobId] -> do
            let jsonData = "{\"service_name\":\"travis-ci\", \"service_job_id\":\"" ++ jobId ++ "\", \"source_files\":[{\"coverage\":[null,0,1,2],\"name\":\"file1.hs\"}]}"
            response <- postJson "https://coveralls.io/api/v1/jobs" jsonData
            putStrLn jsonData
            putStrLn $ show $ respStatus response
            return ()
        _ -> error "illegal arguments"
