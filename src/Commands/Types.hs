{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE InstanceSigs #-}

module Commands.Types where

import Data.Dynamic (Dynamic)

data CommandFieldType
  = StringOption
  | IntegerOption
  | BooleanOption
  | NumberOption
  | UserOption
  | RoleOption
  | MentionOption
  | ChannelOption
  | AttachmentOption
  deriving (Show)

data CommandOption = CommandOption
  { commandOptionName :: String,
    commandOptionDescription :: String
  }
  deriving (Show)

class ToCommandOption a where
  toCommandOption :: a -> CommandOption

instance ToCommandOption (String, String) where
  toCommandOption :: (String, String) -> CommandOption
  toCommandOption (s1, s2) = CommandOption s1 s2

data InteractionCommand = InteractionCommand
  { commandCallback :: Dynamic,
    commandName :: String,
    commandDescription :: String,
    commandFields :: [CommandOption],
    commandFieldTypes :: [CommandFieldType]
  }
  deriving (Show)

newtype CommandMaster = CommandMaster
  { commands :: [InteractionCommand]
  }
  deriving (Show)

getCommandMaster :: CommandMaster
getCommandMaster = CommandMaster {commands = []}

registerCommandMaster :: CommandMaster -> CommandMaster -> CommandMaster
registerCommandMaster a b = CommandMaster {commands = commands a ++ commands b}
