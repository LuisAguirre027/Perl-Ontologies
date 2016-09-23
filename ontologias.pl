#!/usr/bin/perl
use strict; use warnings;

use Graph;
use Graph::Directed;

my $ontograph = Graph::Directed->new();

sub crear_inexistentes {
	foreach my $v (@_){
		if (!$ontograph->has_vertex ($v)){
			$ontograph->add_vertex($v);
		}
	}
}

sub hecho{
	crear_inexistentes($_[0],$_[1]);
	$ontograph->set_edge_attribute($_[0],$_[1],"tipo",$_[2]);
}

sub es{
	hecho($_[0],$_[1],"es");
}

sub tiene{
	hecho($_[0],$_[1],"tiene");
}

sub puede{
	hecho($_[0],$_[1],"puede");
}

sub consulta{
	if ($ontograph->is_reachable($_[0],$_[1])){
		
		foreach my $v1 ( $ontograph->all_reachable( $_[0] ) ){
			foreach my $v2 ( $ontograph->all_neighbours( $v1 ) ) {
				
				my $edge_attribute = $ontograph->get_edge_attribute($v1,$v2,"tipo") || "";

				if	( 
							($ontograph->is_reachable($v2,$_[1]))
							and ($edge_attribute eq $_[2])
						){
					return 1;
				}
			}
		}
	}

	return 0;
}

sub pertenece{
	return consulta($_[0],$_[1],"es")
}

sub posee{
	return consulta($_[0],$_[1],"tiene")
}

sub hace{
	return consulta($_[0],$_[1],"puede")
}

########

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  next if $row =~ /^\s*$/;
  my @var = split /[(,).\n]+/, $row;
  # $var[0]($var[1],$var[2]);
  # start a new scope to keep the effect of "no strict" small
  my $generic=$var[0];
  no strict 'refs';
  &$generic($var[1], $var[2]);
 }
 
print "\n---------GRAFO---------\n $ontograph \n-----------------------\n";

print pertenece("platon", "persona_legal"); #1
print "\n";

print pertenece("platon", "persona_juridica"); #0
print "\n";