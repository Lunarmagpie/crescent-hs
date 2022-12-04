module Commands.Internal.HandleResp where

import Commands.Context (_fromInter)
import Commands.Types (CommandFieldType (..), InteractionCommand (..))
import Data.Dynamic (Dynamic, dynApp, fromDynamic, toDyn)
import Discord (DiscordHandler)
import Discord.Interactions (Interaction)

callCommand :: InteractionCommand -> Interaction -> Maybe (DiscordHandler ())
callCommand a inter = maybeRes
  where
    fieldTypes = commandFieldTypes a

    callback = dynApp (commandCallback a) $ toDyn $ _fromInter inter
    callbackRes = callNext callback fieldTypes
    maybeRes = fromDynamic callbackRes :: Maybe (DiscordHandler ())

    callNext :: Dynamic -> [CommandFieldType] -> Dynamic
    callNext c (x : xs) = callNext (callWithTransform c x) xs
    callNext c [] = c

    callWithTransform :: Dynamic -> CommandFieldType -> Dynamic
    callWithTransform d StringOption = dynApp d (toDyn "String Type")
    callWithTransform d BooleanOption = dynApp d (toDyn False)
    callWithTransform d IntegerOption = dynApp d (toDyn (1 :: Integer))
    callWithTransform d NumberOption = dynApp d (toDyn (1.5 :: Float))
