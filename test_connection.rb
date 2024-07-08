require 'pg'

begin
  connection = PG.connect(
    dbname: 'd7rnsgf5of0mub',
    user: 'uciof0kqlarmc9',
    password: 'pe66156de0d85a0f11b180dcaa4c93467270202de6ae5983c849090d7457111b1',
    host: 'c5p86clmevrg5s.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com',
    port: 5432,
    sslmode: 'require'
  )
  puts 'Connection successful!'
rescue PG::Error => e
  puts e.message
ensure
  connection.close if connection
end
