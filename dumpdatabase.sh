echo "Password for dump database"
mysqldump --routines=true -u brett -p JSONDB > JSONDB.sql
./dumpprocedures.sh

