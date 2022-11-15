#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  RES=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
  else
  RES=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties ON elements.atomic_number = properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1'")
  fi
fi

if [[ -z $RES ]]
then
echo "I could not find that element in the database."
else
echo $RES | while IFS=' |' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi