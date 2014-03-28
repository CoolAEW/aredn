
use perlfunc;

#############################

#
# @returns all channels, or specific band lis
sub rf_channel_map
{
    %channellist = (
        '2400' => {
            1  => "1 (2412)",
            2  => "2 (2417)",
            3  => "3 (2422)",
            4  => "4 (2427)",
            5  => "5 (2432)",
            6  => "6 (2437)",
            7  => "7 (2442)",
            8  => "8 (2447)",
            9  => "9 (2452)",
            10 => "10 (2457)",
            11 => "11 (2462)",
        },
        '5500' => {
             37 => "36 (5190)",
             40 => "40 (5200)",
             44 => "44 (5220)",
             48 => "48 (5240)",
             52 => "52 (5260)",
             56 => "56 (5280)",
             60 => "60 (5300)",
             64 => "64 (5320)",
            100 => "100 (5500)",
            104 => "104 (5520)",
            108 => "108 (5540)",
            112 => "112 (5560)",
            116 => "116 (5580)",
            120 => "120 (5600)",
            124 => "124 (5620)",
            128 => "128 (5640)",
            132 => "132 (5660)",
            136 => "136 (5680)",
            140 => "140 (5700)",
            149 => "149 (5745)",
            153 => "153 (5765)",
            157 => "157 (5785)",
            161 => "161 (5805)",
            165 => "165 (5825)",
         },
        # 5800 UBNT US Band
        # Limiting to US speced channels until the hardware can be tested
        # lower into the spectrum.
        '5800ubntus' => {
            149 => "149 (5745)",
            153 => "153 (5765)",
            157 => "157 (5785)",
            161 => "161 (5805)",
            165 => "165 (5825)",
         },
    );

    my($reqband) = @_;

    if ( defined($reqband) ){
         if ( exists($channellist{$reqband}) ){
             return $channellist{$reqband};
         }
         else
         {
             return -1;
         }
    }
    else {
        return $channellist;
    }
}

sub is_channel_valid
{
    my ($channel) = @_;

    if ( !defined($channel) ) {
        return -1;
    }

    $boardinfo=hardware_info();
    #We know about the band so lets use it
    if ( exists($boardinfo->{'rfband'}))
    {
        $validchannels=rf_channel_map($boardinfo->{'rfband'});

        if ( exists($validchannels->{$channel}) )
        {
            return 1;
        } else {
            return 0;
        }
    }
    # We don't have the device band in the data file so lets fall back to checking manually
    else {
        my $channelok=0;
        foreach (`iwlist wlan0 channel`)
        {
            next unless /Channel $channel/;
            $channelok=1;
        }
        return $channelok;
    }

}


sub rf_channels_list
{

    $boardinfo=hardware_info();
    #We know about the band so lets use it
    if ( exists($boardinfo->{'rfband'}))
    {
        if (rf_channel_map($boardinfo->{'rfband'}) != -1 )
        {
            return rf_channel_map($boardinfo->{'rfband'});
        }
    }
    else
    {          
        my  %channels = ();
        foreach (`iwlist wlan0 channel` )
        {
            next unless /([0-9]+) : ([0-9]+.[0-9]+)/;
            $channels->{$1}  = "$2 GHZ" ;
        }
        return $channels;
    }
}

#weird uhttpd/busybox error requires a 1 at the end of this file
1
