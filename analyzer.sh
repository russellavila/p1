FILE=./data.txt
source ./analyzerFunc.sh
declare -a arr

while IFS= read -r line; do
	line=$(awk -F'$' '{print $2}' <<< "$line")
	line=$(awk -F'.' '{print $1}' <<< "$line")
	arr+=($line)
done < $FILE

max=0
for number in ${arr[@]}; do
	if (( $number > $max )); then 
		max=$number
	fi
	i=$(($i+1))
done

i=1
declare -a winnerIndex
for number in ${arr[@]}; do 
	if (( $number == $max )); then
		winnerIndex+=($i)
	fi 
	i=$(($i+1))
done

#echo ${arr[@]}
analyze "${winnerIndex[@]}"
