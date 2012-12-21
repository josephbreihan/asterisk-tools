#!/usr/bin/perl
#
# look up an incoming phone number against Google Contacts
# requires: googlecl, granted access to your google account
#
# takes one argument, phone number
# returns name if found in contacts

if($ARGV[0] eq "")
{
    print "MISSING ARGUMENT\n";
    goto END;
}

my $lookupnumber = $ARGV[0];
$lookupnumber =~ s/\D//g;
my $gcl = "google contacts list --delimiter \"---\" --title \".*\" --fields name,phone|grep -v None";
my $contacts = `$gcl`;
@contactlist = split(/\n/,$contacts);
my $caller = "UNKNOWN CALLER";
CHECK: for($i=0;$i<$#contactlist;$i++)
{
    @contactline = split(/---/,$contactlist[$i]);
    @phones = split(/,/,$contactline[1]);
    if($#phones>>0)
    {
        for($j=0;$j<$#phones;$j++)
        {
            my $phone = $phones[$j];
            $phone =~ s/\D//g;
            if ($phones[$j] =~ /$lookupnumber/)
            {
                $caller = $contactline[0];
                last CHECK;
            }
        }
    }
    else{
        my $phone = $contactline[1];
        $phone =~ s/\D//g;
        if ($phones =~ /$lookupnumber/)
        {
            $caller = $contactline[0];
            last CHECK;
        }
    }
}
print "$caller\n";
END:
