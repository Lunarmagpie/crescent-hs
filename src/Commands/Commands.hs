{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Commands.Commands (registerCommand, InteractionCommand, onCommandInteraction) where

import Commands.Internal.HandleResp (callCommand)
import Commands.Types (CommandFieldType (..), CommandMaster (CommandMaster, commands), CommandOption, InteractionCommand (..))
import Data.Dynamic (toDyn)
import Data.Maybe (mapMaybe)
import Discord (DiscordHandler)
import Discord.Interactions (Interaction)
import Type.Reflection (Typeable, typeOf)

onCommandInteraction :: CommandMaster -> Interaction -> DiscordHandler ()
onCommandInteraction m inter = do
  case callCommand (head $ commands m) inter of
    Just x -> x
    Nothing -> return ()

registerCommand :: Typeable a => a -> String -> String -> [CommandOption] -> CommandMaster -> CommandMaster
registerCommand cmd_callback name desc fields hdlr = CommandMaster {commands = command' : commands hdlr}
  where
    command' = toCommand cmd_callback name desc fields

toCommand :: forall a. Typeable a => a -> String -> String -> [CommandOption] -> InteractionCommand
toCommand callable name desc fieldNames = InteractionCommand (toDyn callable) name desc fieldNames fieldTypes
  where
    fieldTypes = mapMaybe toFieldType $ (init . words . show . typeOf) callable

    toFieldType "Integer" = Just IntegerOption
    toFieldType "Float" = Just NumberOption
    toFieldType "[Char]" = Just StringOption
    toFieldType "Bool" = Just BooleanOption
    toFieldType "Maybe Integer" = Just IntegerOption
    toFieldType "Maybe Float" = Just NumberOption
    toFieldType "Maybe [Char]" = Just StringOption
    toFieldType "Maybe Bool" = Just BooleanOption
    toFieldType _ = Nothing
