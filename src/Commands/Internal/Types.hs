module Commands.Internal.Types where

data CommandOptionInternal = CommandOptionInternal {
  commandOptionInternalName :: String,
  commandOptionInternalDescription :: String,
  commandOptionInternalIsRequired :: Bool
}
