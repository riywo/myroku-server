name "myroku_admin"
description "myroku admin"
run_list [
  "recipe[myroku::base]",
  "recipe[nginx]",
  "recipe[redis2]",
  "recipe[mysql::server]",
  "recipe[mysql::client]",
  "recipe[myroku::admin]",
]
