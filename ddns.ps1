$domain = 'your.domain.to.update'  # your domain
$name = 'name_of_host' #name of the A record to update
$key = 'key' #key for godaddy developer API
$secret = 'Secret' #Secret for godday developer API

$headers = @{}
$headers["Authorization"] = 'sso-key ' + $key + ':' + $secret
$result = Invoke-WebRequest https://api.godaddy.com/v1/domains/$domain/records/A/$name -method get -headers $headers
$content = ConvertFrom-Json $result.content
$dnsIp = $content.data

# Get public ip address there are several websites that can do this.
$currentIp = Invoke-RestMethod http://ipinfo.io/json | Select-Object -ExpandProperty ip

if ( $currentIp -ne $dnsIp) {
    $Request = @(@{ttl=3600;data=$currentIp; })
    $JSON = Convertto-Json $request
    Invoke-WebRequest https://api.godaddy.com/v1/domains/$domain/records/A/$name -method put -headers $headers -Body $json -ContentType "application/json"
}
