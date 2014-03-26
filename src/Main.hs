module Main where

import Network.Curl
import System.Environment (getArgs)

postJson :: URLString -> String -> IO CurlResponse
postJson url jsonData = do
    writeFile "coverage.json" jsonData
    h <- initialize
    setopt h (CurlVerbose True)
    setopt h (CurlURL url)
    -- setopt h (CurlPost True)
    -- setopt h (CurlPostFields [jsonData])
    -- setopt h (CurlHttpHeaders ["Content-Type: multipart/form-data"])
    setopt h (CurlHttpPost [HttpPost "json_file"
        Nothing
        (ContentFile "coverage.json")
        []
        Nothing])
    response <- perform_with_response_ h
    reset h
    case respCurlCode response of
        CurlOK -> do
            putStrLn $ respBody response
            return response
        c -> do
            putStrLn $ show c
            return response

main :: IO ()
main = do
    args <- getArgs
    case args of
        [jobId] -> do
            let jsonData = "{\"service_name\":\"travis-ci\", \"service_job_id\":\"" ++ jobId ++ "\", \"source_files\":[{\"coverage\":[null,0,1,2],\"name\":\"file1.hs\",\"source\":\"line1\\nline2\\nline3\\nline4\"}]}"
            response <- postJson "https://coveralls.io/api/v1/jobs" jsonData
            putStrLn jsonData
            putStrLn $ show $ respStatus response
            return ()
        _ -> error "illegal arguments"
