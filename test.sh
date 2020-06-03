Request_Dir='./Request_dir'
Variable_Dir='./Var_dir'
V_list=`ls $Request_Dir/`
#V_list=`ls ./test_request_dir/`
##Creating var file for each request file
#echo $V_list
for i in $V_list
do
  NAME=`echo "$i" | cut -d'.' -f1`
#  echo $NAME
#  touch $Variable_Dir/$NAME.yaml
  V_vm=`cat $Request_Dir/$NAME.txt | awk -F "migration_vm:" '{print $2}' | awk -F "," '{print $1}'`
#  echo $V_vm
  for vm in ${V_vm[@]}
  do
  V_source_vc=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'source_vcenter_ip:' '{print$2}' | awk -F ',' '{print $1}'`
  V_destination_vc=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'destination_vcenter_ip:' '{print$2}' | awk -F ',' '{print $1}'`
  V_source_vc_cluster=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'source_vcenter_cluster:' '{print$2}' | awk -F ',' '{print $1}'`
  V_dest_vc_cluster=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'destination_vcenter_cluster:' '{print$2}' | awk -F ',' '{print $1}'`
  V_requester_email=`cat $Request_Dir/$NAME.txt | grep -w $vm |  awk -F 'requester_email:' '{print$2}' | awk -F ',Destination_host' '{print $1}'|awk -F '[' '{print $2}' | awk -F ']' '{print $1}'`
  V_destination_host=`cat $Request_Dir/$NAME.txt | grep -w $vm | awk -F 'Destination_host:' '{print$2}' | awk -F ',' '{print $1}'`
cat>>$Variable_Dir/$NAME-tmp.json<<EOF
    {
      "$vm": {
          'source_vc':$V_source_vc,
          'destination_vc':$V_destination_vc,
          'source_vc_cluster':$V_source_vc_cluster,
          'dest_vc_cluster':$V_dest_vc_cluster,
          'requester_email':$V_requester_email,
          'destination_host':$V_destination_host
      }
    },
EOF

