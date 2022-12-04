module Commands.Context (Context, inter, respond, _fromInter) where

import Control.Monad (void)
import Discord (DiscordHandler, restCall)
import Discord.Interactions (Interaction (interactionId, interactionToken), InteractionResponse (InteractionResponseChannelMessage), InteractionResponseMessage)
import Discord.Requests (InteractionResponseRequest (CreateInteractionResponse))
import Discord.Types (InteractionId, InteractionToken)
import Data.Dynamic (Typeable)

data Context = Context
  { _id :: InteractionId,
    _token :: InteractionToken,
    inter :: Interaction
  } deriving (Show, Typeable)

_fromInter :: Interaction -> Context
_fromInter inter' = Context (interactionId inter') (interactionToken inter') inter'

respond :: Context -> InteractionResponse -> DiscordHandler ()
respond ctx req = do
  void $ restCall $ CreateInteractionResponse (_id ctx) (_token ctx) req
