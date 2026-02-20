#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #obtener team_id winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #si no esta en la db
    if [[ -z $WINNER_ID ]] 
    then 
      #agreagar winner a la db
      INSERT_WINNER_RES=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    #obtener team_id opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #si no esta en la db
    if [[ -z $OPPONENT_ID ]] 
    then 
      #agreagar opponent a la db
      INSERT_OPPONENT_RES=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    #insertar partidos a la tabla
    INSERT_GAME_RES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$W_GOALS,$O_GOALS)")
  fi
done