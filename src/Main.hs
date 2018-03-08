module Main where

import           Control.Lens
import qualified Data.ByteString           as B
import qualified Data.Text                 as T
import           Data.Text.Encoding
import           Network.IRC.Client
import           Network.IRC.Client.Events
import           System.Environment

run :: B.ByteString -> Int -> T.Text -> T.Text -> T.Text -> IO ()
run host port nick pass chan = do
  let conn = plainConnection host port & logfunc .~ stdoutLogger & password .~ (Just pass)
  let cfg  = defaultInstanceConfig nick & handlers %~ (defaultEventHandlers++) & channels %~ (chan:)
  runClient conn cfg ()

main :: IO ()
main = do
  host <- getEnv "TWITCH_IRC_SERVER"
  portStr <- getEnv "TWITCH_IRC_PORT"
  let port = read portStr :: Int
  password <- getEnv "TWITCH_IRC_PASSWORD"
  channel <- getEnv "TWITCH_IRC_CHANNEL"
  nick <- getEnv "TWITCH_IRC_NICK"
  run (encodeUtf8 (T.pack host)) port (T.pack nick) (T.pack password) (T.pack channel)
