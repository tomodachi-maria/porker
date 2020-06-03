module Regexes
  REGEX_HDSC= /H|D|S|C/
  REGEX_1_13 = /\b[1-9]\b|\b1[0-3]\b/
  REGEX_INTEGER = /^[0-9]*$/
  REGEX_ACCEPTABLE = /\b^[SHDC]([1-9]|1[0-3])\b*$/
end