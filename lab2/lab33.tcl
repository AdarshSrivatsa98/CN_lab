set ns [new Simulator]

$ns color 1 red
$ns color 2 green

set nf [open sim2.nam w]
set nt [open ag2.tr w]

$ns namtrace-all $nf
$ns trace-all $nt

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$n0 color blue
$n1 color brown
$n2 color yellow
$n3 color orange

$ns duplex-link $n0 $n2 0.5Mb 8ms DropTail
$ns duplex-link $n1 $n2 1Mb 2ms DropTail
$ns duplex-link $n2 $n3 1Mb 8ms DropTail

$ns queue-limit $n0 $n2 3
$ns queue-limit $n1 $n2 3

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

$ns connect $tcp $sink

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

$tcp set fid_ 1
$udp set fid_ 2

$ns connect $udp $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

proc finish {} {
	global ns nf nt
	$ns flush-trace
	close $nf
        close $nt
	exec nam sim2.nam &
	exit 0
}


$ns at 0.1ms "$ftp start"
$ns at 0.1ms "$cbr start"
$ns at 4ms "finish"
$ns run
