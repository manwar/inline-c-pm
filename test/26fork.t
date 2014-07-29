use warnings;
use strict;
use Config;
use Test::More;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

if($^O =~ /MSWin32/i && $Config{useithreads} ne 'define') {
  plan skip_all => 'fork() not implemented';
  exit 0;
}

    my $pid = fork;
    eval { Inline->bind(C => 'int add(int x, int y) { return x + y; }'); };
    exit 0 unless $pid;

    wait;
    is($?, 0, 'child exited status 0');

if($^O =~ /MSWin32/i){
  TODO: {
    local $TODO = "Generally fails on MS Windows";
    is($@, '', 'bind was successful');
    my $x = eval { add(7,3) };
    is ($@, '', 'bound func no die()');
    is($x, 10, 'bound func gave right result');
  }
}

else {
  is($@, '', 'bind was successful');
  my $x = eval { add(7,3) };
  is ($@, '', 'bound func no die()');
  is($x, 10, 'bound func gave right result');
}

done_testing;
