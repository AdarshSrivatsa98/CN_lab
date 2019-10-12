set ns [new Simulator]
set nf [open lab62.nam w]
set nt [open lab62.tr w]
$ns namtrace-all $nf
$ns trace-all $nt

$ns color 1 Green 
$ns color 2 Red

for { set i 0 } { $i < 6 } {incr i 1 } {
set n($i) [$ns node]}

for { set i 0 } { $i < 5 } { incr i 1 } {
$ns duplex-link $n($i) $n([expr $i + 1]) 2Mb 4ms DropTail }

$ns duplex-link $n(0) $n(5) 2Mb 4ms DropTail 
	
$ns queue-limit $n(2) $n(3) 20
$ns duplex-link-op $n(2) $n(3) queuePos 0.5

set err [new ErrorModel]
$err ranvar [new RandomVariable/Uniform]
$err drop-target [new Agent/Null]
$err set rate 0.4 $n(2) $n(3)
$ns lossmodel $err $n(2) $n(3)

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $tcp $sink

set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp
set null [new Agent/Null]
$ns attach-agent $n(5) $null
$ns connect $udp $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
  
$tcp set fid_ 1
$udp set fid_ 2


proc finish {} {
		global ns nf nt
		$ns flush-trace
		close $nf
		close $nt
		exec nam lab62.nam &
		set tcpsize [exec sh f1.sh]
		set tcpnum [exec sh f2.sh]
		set udpsize [exec sh f3.sh]
		set udpnum [exec sh f4.sh]
		set time_of_exec 124.00

		puts "Throughput of TCP is [expr $tcpsize * $tcpnum / $time_of_exec] bytes per sec \n"
		puts "Throughput of UDP is [expr $udpsize * $udpnum / $time_of_exec] bytes per sec \n"
		exit 0
		}

$ns at 0ms "$ftp start"
$ns at 0ms "$cbr start"
$ns at 124ms "finish"
$ns run 
