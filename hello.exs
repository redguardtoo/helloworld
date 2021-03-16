# 1. data structures
import Validator
validate user, name: [length: 1..100],
               email: [matches: ~r/@/]

# 2. functions
import Validator
user
|> validate_length(:name, 1..100)
|> validate_matches(:email, ~r/@/)

# 3. macros + modules
defmodule MyValidator do
  use Validator
  validate_length :name, 1..100
  validate_matches :email, ~r/@/
end

"good" = if true do
  "good"
else
  "This will"
end

# nil is default when else is missing
nil = if false do
  "good"
end

"ok" = unless false do
  "ok"
end

MyValidator.validate(user)