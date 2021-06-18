domain="your.domain.to.update"   # your domain
name="name_of_host"     # name of A record to update
key="key"     # key for godaddy developer API
secret="secret"   # secret for godaddy developer API

headers="Authorization: sso-key $key:$secret"

# echo $headers

result=$(curl -s -X GET -H "$headers" \
 "https://api.godaddy.com/v1/domains/$domain/records/A/$name")

#echo $result;

dnsIp=$(echo $result | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#echo "dnsIp:" $dnsIp

# Get public ip address there are several websites that can do this.
ret=$(curl -s GET "http://ipinfo.io/json")
currentIp=$(echo $ret | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")


#echo "currentIp:" $currentIp

if [ "$dnsIp" != "$currentIp" ];
 then
#	echo "Ips are not equal"
	request='[{"data":"'$currentIp'","ttl":3600}]'
#	echo " request:" $request
	nresult=$(curl -i -s -X PUT \
 -H "$headers" \
 -H "Content-Type: application/json" \
 -d $request "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
#	echo "result:" $nresult
fi
