#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -eq 0 ]
then
    echo "Please provide an element as an argument."
    exit
fi

USER_INPUT="$1"

MAIN() {  
    case $USER_INPUT in
        [0-9]*) FIND_BY_NUMBER "$USER_INPUT";;
        [a-zA-Z]) FIND_BY_SYMBOL;;
        [a-zA-Z][a-zA-Z]) FIND_BY_SYMBOL;;
        *) FIND_BY_NAME
    esac
}

FIND_BY_NUMBER() {
    NUMBER="$USER_INPUT"
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $NUMBER;")
    if [[ -z $NAME ]]
    then
        echo 'I could not find that element in the database.'
        exit
    fi

    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $NUMBER;")
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number = $NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER;")
    M_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    B_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
}

FIND_BY_SYMBOL() {
    SYMBOL="$USER_INPUT"
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL';")
    if [[ -z $NUMBER ]]
    then
        echo 'I could not find that element in the database.'
        exit
    fi

    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $NUMBER;")
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number = $NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER;")
    M_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    B_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
}

FIND_BY_NAME() {
    NAME="$USER_INPUT"
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$NAME';")
    if [[ -z $NUMBER ]] 
    then
        echo 'I could not find that element in the database.'
        exit
    fi

    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $NUMBER;")
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number = $NUMBER;")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NUMBER;")
    M_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    B_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NUMBER;")
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
}

MAIN
