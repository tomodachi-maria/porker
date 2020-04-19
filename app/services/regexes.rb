module Regexes

  REGEX_0 = /(?<!1)0/
  REGEX_123 = /(?<!S|H|D|C|1)(1|2|3)/
  REGEX_456789 = /(?<!S|H|D|C)(4|5|6|7|8|9)/
  REGEX_MARK = /(S|H|D|C)(?!\d)/

end
