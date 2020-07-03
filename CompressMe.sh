#!/bin/bash

spin()
{
  spinner="/|\\-/|\\-"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 0.5
    done
  done
}

echo "I am compressing the files, just a sec please :)"

# Start the Spinner:
spin &
# Make a note of its Process ID (PID):
SPIN_PID=$!
# Kill the spinner on any signal
trap "kill -9 $SPIN_PID" `seq 0 15`


sleep 4

arg_array=("$@") 
cnt=0
target_dir=""
for arg in "${arg_array[@]}"; do
   if [[ $arg == "-t" ]] || [[ $arg == "--target-directory" ]]; then
	target_dir=${arg_array[$((cnt+1))]}
	arg_array=("${arg_array[@]:0:$cnt}" "${arg_array[@]:$((cnt+2))}")
	break
   fi
cnt+=1
done


for ext in "${arg_array[@]}"; do
	for file in `find $target_dir -type f -name *.$ext`; do
		echo "Compressing $file"
		gzip $file
	done
done


echo "Finished."

#kill the spinner now
kill -9 $SPIN_PID
