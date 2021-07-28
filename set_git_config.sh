while getopts u:e:s: flag
do
	case "${flag}" in
		u) username=${OPTARG};;
		e) email=${OPTARG};;
		s) signingkey=${OPTARG};;
	esac
done

for dir in */; do
	(cd -- "$dir" && git config --replace-all user.name "$username" && git config user.email $email && git config user.signingkey $signingkey) 
done
	
