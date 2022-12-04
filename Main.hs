{-# LANGUAGE OverloadedStrings #-}

import Commands (CommandOption (CommandOption), publishCommands, registerCommandMaster)
import Commands.Commands (onCommandInteraction, registerCommand)
import Commands.Context (Context, respond)
import Commands.Types (commands, getCommandMaster)
import Control.Monad (void, when)
import Data.Maybe (fromJust)
import Data.Text (Text, isPrefixOf, toLower)
import Data.Text as T
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Discord
  ( DiscordHandler,
    RunDiscordOpts (discordOnEvent, discordOnLog, discordOnStart, discordToken),
    def,
    restCall,
    runDiscord,
  )
import Discord.Interactions (Interaction (interactionChannelId), InteractionResponseMessage (InteractionResponseMessage), OptionValue (..), interactionResponseBasic)
import qualified Discord.Requests as R
import Discord.Types
  ( Event (InteractionCreate, MessageCreate, Ready),
    Message
      ( messageAuthor,
        messageChannelId,
        messageContent,
        messageId
      ),
    PartialApplication (PartialApplication),
    User (userIsBot),
  )
import Plugin (plugin)
import UnliftIO.Concurrent ()

-- Allows this code to be an executable. See discord-haskell.cabal
main :: IO ()
main = do
  putStrLn "Starting the bot!"
  run

token = "Bot OTk4NTIzMzYyNDYyNjc5MDcx.Gzxq-D.0AruBroysAx2dE2qMyyN8s6dL0EFiPQvLPULfs"

master =
  ( registerCommandMaster plugin
      . registerCommand myCommand "test" "The description 1" [CommandOption "name" "desc"]
      . registerCommand myCommand2 "test_b" "The description 2" [CommandOption "name" "desc"]
  )
    getCommandMaster

-- | Replies "pong" to every message that starts with "ping"
run :: IO ()
run = do
  print $ commands master

  userFacingError <-
    runDiscord $
      def
        { discordToken = token,
          discordOnEvent = eventHandler,
          discordOnLog = \s -> TIO.putStrLn s >> TIO.putStrLn ""
        }
  TIO.putStrLn userFacingError

myCommand :: Context -> String -> DiscordHandler ()
myCommand ctx str = respond ctx $ interactionResponseBasic $ T.pack str

myCommand2 :: Context -> Int -> DiscordHandler ()
myCommand2 ctx i = respond ctx $ (interactionResponseBasic . T.pack . show) i

eventHandler :: Event -> DiscordHandler ()
eventHandler event = case event of
  Ready _ _ _ _ _ _ (PartialApplication i _) -> do
    publishCommands i master
  InteractionCreate i -> onCommandInteraction master i
  _ -> return ()
