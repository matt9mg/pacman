#!/bin/bash

# Clear the screen cursor
tput civis

cleanup ()
{
    kill -s SIGTERM $!
    exit 0
}

finish ()
{
    kill -s SIGTERM $!
    exit 0
}

# set trap for script killed by user
trap cleanup SIGINT SIGTERM

# set trap for when the script has finished
trap finish EXIT

# set the variable we will need for this script
START=1
COLUMNS=$(tput cols)
LINES=$(tput lines)
LETTER=.
PACMAN=C
EATING=O
EMPTY=" "

# Set a nice black screen for our game
echo -e "\e[1;40m";
clear;

# create our pacman food
for (( c=$START; c<=$COLUMNS; c++ ))
do
    for(( l=$START; l<=$LINES; l++ ))
    do
        echo $c $l $LETTER;
    done|awk '{
        printf "\033[%s;%sH\033[36m%s",$2,$1,$3;
    }'
done

# set out initial pacman
awk -v col="1" -v line="1" -v pacman="$PACMAN" 'BEGIN{ printf "\033[%s;%sH\033[33m%s",line,col,pacman;}'

# play our starting game ring tone
play -q ./assets/pacman_ringtone.mp3

# to save on application size we will use a small frame rate and loop over the music
while true
do
    play -q ./assets/pacman_chomp.wav
done &

# for our game board we need to loop through each . and eat it
for (( l=$START; l<=$LINES; l++ ))
do
    for(( c=$START; c<=$COLUMNS; c++ ))
    do
        sleep 0.05;

        afterC=$((c + 1));

        #open mount
        awk -v col="$c" -v line="$l" -v pacman="$PACMAN" 'BEGIN{ printf "\033[%s;%sH\033[33m%s",line,col,pacman;}'

        sleep 0.25;

        #close mouth on the next .
        awk -v col="$afterC" -v line="$l" -v eating="$EATING" 'BEGIN{ printf "\033[%s;%sH\033[33m%s",line,col,eating;}'

        # remove our pacman from the previous space
        awk -v line="$l" -v empty="$EMPTY" -v col="$c"  'BEGIN{ printf "\033[%s;%sH\033[96m%s",line,col,empty;}'

        sleep 0.25;
    done
done