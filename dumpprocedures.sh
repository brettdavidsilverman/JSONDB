echo "Dumping procedures"
sudo mysqldump --routines=true -n -d -t --triggers --add-drop-trigger JSONDB > JSONDB_PROCEDURES.sql
