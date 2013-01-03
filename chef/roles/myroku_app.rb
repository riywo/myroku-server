name "myroku_app"
description "myroku app"
run_list [
  "recipe[myroku::base]",
  "recipe[mysql::client]",
  "recipe[myroku::app]",
]
