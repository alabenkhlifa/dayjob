---
type: llm
---
The review gives a verdict of "Request changes" (or equivalent) and lists as a must-fix that `if (code = 'SAVE10')` assigns instead of compares, so every code (and no code) gets the discount. It gives a concrete failing input and suggests `===`. It also notes missing tests. The tone is about the code, not the author.
