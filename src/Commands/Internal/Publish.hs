{-# LANGUAGE OverloadedStrings #-}

module Commands.Internal.Publish (publishCommands) where

import Commands.Types (CommandFieldType (..), CommandMaster, InteractionCommand (commandDescription, commandFieldTypes, commandFields, commandName), commands, CommandOption (commandOptionName, commandOptionDescription))
import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.Maybe (mapMaybe)
import qualified Data.Text as T
import Discord (DiscordHandler, restCall)
import Discord.Interactions (CreateApplicationCommand (CreateApplicationCommandChatInput), OptionValue (OptionValueString, OptionValueInteger), Options (OptionsValues), createOptions)
import Discord.Requests (ApplicationCommandRequest (BulkOverWriteGlobalApplicationCommand))
import Discord.Types (ApplicationId)

publishCommands :: ApplicationId -> CommandMaster -> DiscordHandler ()
publishCommands app commandMaster = do
  void $
    ( restCall
        . BulkOverWriteGlobalApplicationCommand app
        . mapMaybe toDiscordHaskellCommand
        . commands
    )
      commandMaster

createChatInput :: T.Text -> T.Text -> Maybe CreateApplicationCommand
createChatInput name desc = Just $ CreateApplicationCommandChatInput name Nothing desc Nothing Nothing Nothing Nothing



buildOptions :: CommandOption -> CommandFieldType -> OptionValue
buildOptions commandOption StringOption = OptionValueString name Nothing description Nothing True (Left False) Nothing Nothing
-- buildOptions commandOption IntegerOption = OptionValueInteger name Nothing description Nothing False (Left False) Nothing Nothing
  where
    name = T.pack $ commandOptionName commandOption
    description = T.pack $ commandOptionDescription commandOption


toDiscordHaskellCommand :: InteractionCommand -> Maybe CreateApplicationCommand
toDiscordHaskellCommand appCommand =
  createChatInput
    (T.pack $ commandName appCommand)
    (T.pack $ commandDescription appCommand)
    >>= \cac ->
      return $
        cac
          { createOptions =
              Just $
                OptionsValues $ zipWith buildOptions (commandFields appCommand) (commandFieldTypes appCommand)
          }
