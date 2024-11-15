#!usr/in/bash

#Russell Avila
#Bash Roulette Simulator
 
###### Variables and arrays

total=100
declare -a arr=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j")
declare -a redArray=(1 3 5 7 9 12 14 16 18 19 21 23 25 27 30 32 34 36)
declare -a blackArray=(2 4 6 8 10 11 13 15 17 20 22 24 26 28 29 31 33 35)
declare -a oddArray=(1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35)
declare -a evenArray=(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36)

###### Intro text
echo
echo "What's your name player!?"
read -r -p ">: " name
echo
echo "Tight name $name!" 
echo "Let's play 20 spins of roulette!"
echo "Each spin you'll be playing 5 dollars."

###### Determine type of bet using case switch 

isValid=false
while [ $isValid == false ]; do
	echo
	echo "Type the letter for the type of bet you want!"
	echo "Including 0 and 00, there are 38 numbers on a roullete wheel :)"
	echo "---------------------------------------------------------"
	echo "'a' for \$5 per spin on 1 number, pays 35 to 1"
	echo "'b' for \$2.50 per spin on 2 numbers, pays 35 to 1"
	echo "'c' for \$1 per spin on 5 numbers, pays 35 to 1"
	echo "'d' for \$5 per spin on 1st twelve numbers (1-12), pays 2 to 1"
	echo "'e' for \$5 per spin on 2nd twelve numbers (13-24), pays 2 to 1"
	echo "'f' for \$5 per spin on 3rd twelve numbers (25-36), pays 2 to 1"
	echo "'g' for \$5 per spin on red numbers, pays 1 to 1"
	echo "'h' for \$5 per spin on black numbers, pays 1 to 1"
	echo "'i' for \$5 per spin on odd numbers, pays 1 to 1"
	echo "'j' for \$5 per spin on even numbers, pays 1 to 1"
	read -r -p ">: " input
	
	for i in "${arr[@]}";
		do
		if [[ $i == $input ]]; then
			isValid=true
		fi
	done

	if [ $isValid == false ]; then
		echo
		echo "YOU'VE MADE ME ANGRY. TRY AGAIN."
	fi
done

echo
echo "BETTING ON OPTION $input!? YOU'RE INSANE!"

case $input in
	a)
		#goal: just figuring out bash
		isValid=false
		while [ $isValid == false ]; do
			echo "enter a number between 1 and 36, or 0, or 00"
			read -r -p ">: " number
			if (([[ $number -le 36 ]] && [[ $number -ge 0 ]]) || ([[ $number == 00 ]])); then
				#numArray+=$number
				isValid=true
			else
				echo "Not in range"
			fi
		done
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ $number == $roulNum ]]; then
				total=$(($total+175 ))
				echo "Hit! The result is $roulNum! You won \$175"
			fi
			if [[ $number != $roulNum ]]; then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *a (1 number) and ended up with \$$total." >> ./data.txt
		;;
	
	b)	#2 numbers per spin
		#goal: access array elements (players selected numbers)
		#set up player numbers
		declare -a numArray
		isValid=false
		while [ $isValid == false ]; do
			echo "enter a number between 1 and 36, or 0, or 00"
			read -r -p ">: " number
			if (([[ $number -le 36 ]] && [[ $number -ge 0 ]]) || ([[ $number == 00 ]])); then
				numArray+=($number)
				isValid=true
			else
				echo "Not in range"
			fi
		done
		isValid=false
		while [ $isValid == false ]; do
			echo "enter a number between 1 and 36, or 0, or 00"
			read -r -p ">: " number
			if ((([[ $number -le 36 ]] && [[ $number -ge 0 ]]) || ([[ $number == 00 ]])) && [[ $number != ${numArray[0]} ]]); then
				numArray+=($number)
				isValid=true
			else
				echo "Not in range"
			fi
		done
		#spin 20 times
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ ${numArray[0]} == $roulNum ]]; then
				total=$(($total+85))
				echo "Hit! The result is $roulNum! You won \$87.5"
			fi	
			if [[ ${numArray[1]} == $roulNum ]]; then
				total=$(($total+85))
				echo "Hit! The result is $roulNum! You won \$87.5"
			fi	
			if ([[ ${numArray[0]} != $roulNum ]] && [[ ${numArray[1]} != $roulNum ]]); then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *b (2 numbers) and ended up with \$$total." >> ./data.txt	
		;;
	c)  #goal
		#player will have an array of 5 numbers
		#on each spin, see if player array contains the winning value
		#as opposed to checking each element
		declare -a numArray
		isValid=false
		i=0
		while ([ $isValid == false ] && [ $i -le 5 ]); do
			echo "enter a number between 1 and 36, or 0, or 00"
			read -r -p ">: " number
			if ((([[ $number -le 36 ]] && [[ $number -ge 0 ]]) || ([[ $number == 00 ]])) && ([[ ! " ${numArray[*]} " =~ [[:space:]]${number}[[:space:]] ]])); then
				numArray+=($number)
				i=$(($i+1))
				if [[ $i -eq 5 ]]; then
				isValid=true
				fi
			else
				echo "Not in range"
			fi
		done
		#now that we have our player numbers, do 20 spins
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ " ${numArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total+31))
				echo "Hit! The result is $roulNum! You won \$35"
			fi
			if [[ ! " ${numArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *c (5 numbers) and ended up with \$$total." >> ./data.txt
		;;
	d)  #1-12 pays 2:1
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if ([[ $roulNum -le 12 ]] && [[ $roulNum -ge 1 ]]); then
				echo "Hit! The result is $roulNum! You won \$10"
				total=$(($total+10))
			else
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi			
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *d (1-12) and ended up with \$$total." >> ./data.txt	
		;;
	e) #13-24 pays 2:1
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if ([[ $roulNum -le 24 ]] && [[ $roulNum -ge 13 ]]); then
				echo "Hit! The result is $roulNum! You won \$10"
				total=$(($total+10))
			else
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi			
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *e (13-24) and ended up with \$$total." >> ./data.txt
		;;
	
	f) #25-36 pays 2:1
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if ([[ $roulNum -le 36 ]] && [[ $roulNum -ge 25 ]]); then
				echo "Hit! The result is $roulNum! You won \$10"
				total=$(($total+10))
			else
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi			
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *f (25-36) and ended up with \$$total." >> ./data.txt	
		;;
		
	g) #red numbers pay 1:1	
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ " ${redArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total+5))
				echo "Hit! The result is $roulNum! You won \$5"
			fi
			if [[ ! " ${redArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *g (red) and ended up with \$$total." >> ./data.txt	
		;;
	
	h) #black numbers pay 1:1	
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ " ${blackArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total+5))
				echo "Hit! The result is $roulNum! You won \$5"
			fi
			if [[ ! " ${blackArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *h (black) and ended up with \$$total." >> ./data.txt	
		;;
		
	i) #odd numbers pay 1:1	
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ " ${oddArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total+5))
				echo "Hit! The result is $roulNum! You won \$5"
			fi
			if [[ ! " ${oddArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done
		echo "$(date +%T): $name bet 20 spins using option *i (odd) and ended up with \$$total." >> ./data.txt
		;;

	j) #even numbers pay 1:1	
		for i in {1..20}
		do
			echo
			#random seed
			RANDOM=$(date +%s%N | cut -b10-19 | sed 's|^[0]\+||')
			roulNum=$[ $RANDOM % 38 + 1 ]
			if [[ $roulNum -eq 37 ]]; then
				roulNum=0
			fi
			if [[ $roulNum -eq 38 ]]; then
				roulNum=00
			fi
			if [[ " ${evenArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total+5))
				echo "Hit! The result is $roulNum! You won \$5"
			fi
			if [[ ! " ${evenArray[*]} " =~ [[:space:]]${roulNum}[[:space:]] ]]; then
				total=$(($total-5))
				echo "NO! The result is $roulNum... you lose \$5"
			fi
			echo "You currently have \$$total."
		done 
		echo "$(date +%T): $name bet 20 spins using option *j (even) and ended up with \$$total." >> ./data.txt
		;;
		
	*)	
		echo everything else
		;;
esac

