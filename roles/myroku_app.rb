name "myroku_app"
description "myroku app"
run_list [
  "recipe[myroku::base]",
  "recipe[nginx]",
  "recipe[mysql::client]",
  "recipe[myroku::app]",
]
