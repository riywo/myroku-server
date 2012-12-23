name "myroku_db"
description "myroku db"
run_list [
  "recipe[myroku::base]",
  "recipe[redis2]",
  "recipe[mysql::server]",
  "recipe[myroku::db]",
]
