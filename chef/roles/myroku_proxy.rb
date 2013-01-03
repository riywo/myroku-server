name "myroku_proxy"
description "myroku proxy"
run_list [
  "recipe[myroku::base]",
  "recipe[nginx]",
  "recipe[myroku::proxy]",
]
