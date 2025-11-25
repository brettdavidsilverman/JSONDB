echo "Dumping database"
sudo mysqldump --routines=true JSONDB > JSONDB.sql
./dumpprocedures.sh

