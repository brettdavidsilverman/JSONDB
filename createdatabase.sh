echo "Loading database"
sudo mysql JSONDB < JSONDB.sql
echo "Loading procedures"
sudo mysql JSONDB < JSONDB_PROCEDURES.sql
