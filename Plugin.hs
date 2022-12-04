module Plugin where

import Discord
import Discord.Interactions (interactionResponseBasic)
import Commands (Context, getCommandMaster, respond, registerCommand)
import qualified Data.Text as T




plugin = registerCommand callback "test3" "The description 3" [] getCommandMaster


callback :: Context -> String -> DiscordHandler ()
callback ctx str = do
  respond ctx $ (interactionResponseBasic . T.pack . show) str
