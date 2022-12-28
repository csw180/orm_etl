

PATH=/usr/bin:/etc:/usr/sbin:/usr/ucb:$HOME/bin:/usr/bin/X11:/sbin:.

export PATH

if [ -s "$MAIL" ]           # This is at Shell startup.  In normal
then echo "$MAILMSG"        # operation, the Shell checks
fi                          # periodically.

###################################################
## ORACLE_ENV
###################################################
export ORACLE_BASE=/sw/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.2.0.1
export HOSTNAME=`hostname`
export NLS_LANG=AMERICAN_AMERICA.KO16MSWIN949
export TNS_ADMIN=$ORACLE_HOME/network/admin
export LIBPATH=$ORACLE_HOME/lib:/usr/lib
export PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:/usr/sbin:/usr/java8/bin
export PERL5LIB=$ORACLE_HOME/perl/lib
export ORA_NLS10=$ORACLE_HOME/nls/data

###################################################
## OPE Environment Variables
###################################################
export OPEHOME='/opeapp'
export PATH=$PATH:$OPEHOME
export OPE_LOG_PATH=/opeapp/logs

