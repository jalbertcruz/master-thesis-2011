
 SET ERL_EPMD_PORT=5901
 erl -noshell -name nChannel@10.36.14.131 -setcookie coo -s channel start
 
 
 werl -name nChannel@192.168.1.108 -setcookie coo -s iFabricaChannel start 2