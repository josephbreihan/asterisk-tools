#!/usr/bin/perl
#
# Put notifications on your Samsung TV when you get incoming calls
# tvcallerid.pl tvipaddress "caller number" "caller name" "not currently displayed id" "your number"
#
# ARGV[0] = TV IP ADDRESS
# ARGV[1] = CALLERNUM
# ARGV[2] = CALLERNAME
# ARGV[3] = CALLEENUM
# ARGV[4] = CALLEENAME

$content = <<CONTENTEND;
<?xml version="1.0" encoding="utf-8"?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" >
<s:Body><u:AddMessage xmlns:u="urn:samsung.com:service:MessageBoxService:1">
<MessageID>1</MessageID>
<MessageType>text/xml</MessageType>
<Message>
&lt;Category&gt;Incoming Call&lt;/Category&gt;
&lt;DisplayType&gt;Maximum&lt;/DisplayType&gt;
&lt;CallTime&gt;
&lt;Date&gt;FROMDATE&lt;/Date&gt;
&lt;Time&gt;FROMTIME&lt;/Time&gt;
&lt;/CallTime&gt;
&lt;Callee&gt;
&lt;Number&gt;UNKNOWN&lt;/Number&gt;
&lt;Name&gt;CALLEE&lt;/Name&gt;
&lt;/Callee&gt;
&lt;Caller&gt;
&lt;Number&gt;NUM&lt;/Number&gt;
&lt;Name&gt;NAME&lt;/Name&gt;
&lt;/Caller&gt;
</Message>
</u:AddMessage>
</s:Body>
</s:Envelope>
CONTENTEND

$content =~ s/NUM/$ARGV[1]/;
$content =~ s/NAME/$ARGV[2]/;
$content =~ s/UNKNOWN/$ARGV[3]/;
$content =~ s/CALLEE/$ARGV[4]/;
$fromdate = `date +%Y-%m-%d`;
$fromtime = `date +%H:%M:%S`;
$content =~ s/FROMDATE/$fromdate/;
$content =~ s/FROMTIME/$fromtime/;

$len = length($content);

$headers = "POST /PMR/control/MessageBoxService HTTP/1.1\r\n";
$headers .= "Host: $ARGV[0]\r\n";
$headers .= "Content-Type: text/xml; charset=UTF-8\r\n";
$headers .= "Content-Length: $len\r\n";
$headers .= "SOAPACTION: \"urn:samsung.com:service:MessageBoxService:1#AddMessage\"\r\n";
$headers .= "Connection-Close: close\r\n\r\n";

$data = $headers . $content;
#print $data;
open(NC, "| nc -n $ARGV[0] 52235");
print NC $data;
close(NC);
