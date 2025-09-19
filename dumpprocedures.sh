echo "Password for dump procedures"
mysqldump --routines=true -u brett -p -n -d -t --triggers --add-drop-trigger JSONDB > JSONDB_PROCEDURES.sql
