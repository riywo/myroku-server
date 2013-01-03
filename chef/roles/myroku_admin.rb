name "myroku_admin"
description "myroku admin"
run_list [
  "recipe[myroku::base]",
  "recipe[nginx]",
  "recipe[redisio::install]",
  "recipe[redisio::enable]",
  "recipe[mysql::server]",
  "recipe[mysql::client]",
  "recipe[myroku::admin]",
]
