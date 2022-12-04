# Python file to register commands while lib is still in development

import crescent

bot = crescent.Bot("OTk4NTIzMzYyNDYyNjc5MDcx.Gzxq-D.0AruBroysAx2dE2qMyyN8s6dL0EFiPQvLPULfs")

@bot.include
@crescent.command
async def my_command(ctx, s: str) -> str:
    ...

bot.run()
