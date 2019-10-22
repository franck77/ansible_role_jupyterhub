#
# Desc : Ce script permet de monitorer le process Rstudio-server, shiny-server et jupyter
#         et relancer le process Rstudio toutes les 5s en cas d'echec
#
# Author  : Guy AKROMAN <guy.akroman-ext@socgen.com>
#           Wandrille DOMIN <wandrille.a.domin@socgen.com> 
# Version : 0.4
# Date    : 2018.08.10 -- Initialisation du script
#           2018.08.27 -- Check health via curl
#           2018.09.10 -- Envoi alerte mail si restart down
#           2018.09.17 -- Ajout appliance Shiny
#
#########################################################################
SERVER=$1
PORT=$2
OUTIL=$3
DAY=`date "+%Y%m%d"`
LOG="/applis/$OUTIL/scripts/had/out/${DAY}_RstudioWatchdog.log"
MAIL="/applis/$OUTIL/scripts/had/cfg/mail_alerte"
#DEST="guy.akroman-ext@socgen.com,abdelmajid.draoui-ext@socgen.com,wandrille.a.domin@socgen.com"
DEST="wandrille.a.domin@socgen.com,marianne.bioy-ext@socgen.com,franck.vieira@socgen.com"

#status=`curl -s -k https://phadlx202.haas.socgen:8790/health-check`

#MAIL_ALERTE=$(cat $MAIL | mail -s "[RUN][P] Edge `echo $SERVER` Datascience restart KO" $DEST)

function usage() {
   echo -e " \t----------------------------------------------------------------------"
   echo -e " \tPour lancer le script, il faut lui donner les 3 arguments suivants :  "
   echo -e " \t./rstudio_watchdog.sh <FQDN server> <port> <outil>"
   echo -e " \tEx: ./rstudio_watchdog.sh phadlx00.haas.socgen 0000 (rstudio|jupyter|shiny)"
   echo -e " \t----------------------------------------------------------------------"
}

function restartRstudio() {

  URL="https://$SERVER:$PORT/health-check"
  #set -x
  # check du statut de rstudio
  #RstudioStatus=$(curl -k "https://phadlx204.haas.socgen:8841/health-check" >/dev/null 2>&1)
  RstudioStatus=$(curl -k "$URL" >/dev/null 2>&1)
  RstudioVal=$?

  if [ ${RstudioVal} -ne 0 ]
  then
        cmd=$(sudo systemctl restart rstudio-server.service)
        echo "`date "+%Y%m%d-%H%M%S"` -- Restart de R :"$? >> $LOG

        Count_StartKO=0
        while true
        do
                sleep 2
                cmd=$(sudo systemctl status rstudio-server.service) # Pas sur que le sudo soit nécessaire ici
                cmdStatus=$?
                if [[ ${cmdStatus} -eq 0 ]]
                  then
                    # envoi mail suivi
                    echo " Restart $SERVER OK" | mail -s "[RUN][P] Edge `echo $SERVER` RStudio restart OK" $DEST
                    break
                else
                  Count_StartKO=`expr $Count_StartKO + 1`
                  if [[ $Count_StartKO -eq 3 ]]
                    then
                      cat $MAIL | mail -s "[RUN][P] Edge `echo $SERVER` RStudio restart KO" $DEST
                      break
                  fi
              fi
        done
  fi
}

function restartShiny() {

  URL="https://$SERVER:$PORT/health-check"
  ShinyStatus=$(curl -k "$URL" >/dev/null 2>&1)
  ShinyVal=$?

  if [ ${ShinyVal} -ne 0 ]
  then
        cmd=$(sudo systemctl restart shiny-server.service)
        echo "`date "+%Y%m%d-%H%M%S"` -- Restart de R :"$? >> $LOG

        Count_StartKO=0
        while true
        do
                sleep 2
                cmd=$(sudo systemctl status shiny-server.service)
                cmdStatus=$?
                if [[ ${cmdStatus} -eq 0 ]]
                  then
                    # envoi mail suivi
                    echo " Restart $SERVER OK" | mail -s "[RUN][P] Edge `echo $SERVER` Shiny restart OK" $DEST
                    break
                else
                  Count_StartKO=`expr $Count_StartKO + 1`
                  if [[ $Count_StartKO -eq 3 ]]
                    then
                      cat $MAIL | mail -s "[RUN][P] Edge `echo $SERVER` Shiny restart KO" $DEST
                      break
                  fi
              fi
        done
  fi
}


function restartJupyter() {
  echo "######### WORK IN PROGRESS ##########"
}


if [ $# -eq 3 ]
then
  if [[ "$OUTIL" == "rstudio" ]]
    then
      restartRstudio
  fi
  if [[ "$OUTIL" == "jupyter" ]]
    then
      restartJupyter
  fi
  if [[ "$OUTIL" == "shiny" ]]
    then
      restartShiny
  else
    usage    
  fi  
  else
    usage
fi

