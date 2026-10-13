---
type: llm
---
The reply identifies the root cause as loadOrder in src/orders.js reading `raw.profile` while the API sends `customer_profile`, fixes the mapping there, and does not rely on a null check or optional chaining in displayName to hide the crash. It mentions a regression test. Exact wording does not matter.
