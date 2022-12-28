ls -1 create_TB* > list_all.sql
sed -e "s/^/create_own.bat /" list_all.sql > create_own_all.sh
