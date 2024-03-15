# prerequisite: nodemon globally installed
nodemon -w src/ -w test/ -e sol -x forge test $@
