echo "Password for database"
mysql -h bee.fish -u brett -p JSONDB < JSONDB.sql
echo "Password for procedures"
mysql -h bee.fish -u brett -p JSONDB < JSONDB_PROCEDURES.sql
