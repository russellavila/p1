FILE="data.txt"

analyze() { 
	local winnerIndex=("$@")
	echo "$(date +%T):"
	echo "Behold the master of gambling!"
	echo "=============================="
	for value in ${winnerIndex[@]}; do
        	sed "${value}q;d" $FILE
	done
	echo "=============================="



	#for element in "${thisArray[@]}"; do
	#	echo "$element"	
	#done	
}
