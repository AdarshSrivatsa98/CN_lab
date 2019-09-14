set ns [new Simulator]

set nf [open sim.nam w]
set nt [open ag1.tr w]

$ns namtrace-all $nf
$ns trace-all $nt 

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 8ms DropTail
$ns duplex-link $n1 $n2 1Mb 8ms DropTail

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1

$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
$ns attach-agent $n1 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2

$ns connect $tcp2 $sink2

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

$ns at 0.1ms "$ftp1 start"
$ns at 0.1ms "$ftp2 start"
$ns at 4ms exit
$ns run
