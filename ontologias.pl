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

sub consulta_individual{
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

sub consulta_multiple_arriba{
	
	my @vertices = $ontograph->all_reachable( $_[0] );
	push @vertices, $_[0];
	
	my @ret;
	
	
	foreach my $v1 ( @vertices ) {
		foreach my $v2 ( $ontograph->all_neighbours( $v1 ) ) {
			my $edge_attribute = $ontograph->get_edge_attribute($v1,$v2,"tipo") || "";
			if ( $edge_attribute eq $_[1] ){
				push @ret, $v2;
			}
		}
		
	}
	
	@ret;
}

sub consulta_multiple_abajo{
	
	my @vertices = $ontograph->unique_vertices;
	
	my @ret;
	
	foreach my $v1 ( @vertices ) {
		foreach my $v2 ( $ontograph->all_neighbours( $v1 ) ) {
			
			my $edge_attribute = $ontograph->get_edge_attribute($v1,$v2,"tipo") || "";
			
			if (($edge_attribute eq $_[1])
			and ( $ontograph->is_reachable($v2,$_[0])) ){
				push @ret, $v1;
			}
		}
	}
	@ret;
}


sub consulta{
	if (($_[0]) and ($_[1]))
	{return consulta_individual($_[0],$_[1],$_[2]);}
	elsif ($_[0])
	{return consulta_multiple_arriba($_[0],$_[2]);}
	else
	{return consulta_multiple_abajo($_[1],$_[2]);}
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

print join ", ", pertenece("platon",undef); #ARRAY
print "\n";

print join ", ", pertenece(undef, "mamifero"); #ARRAY
print "\n";

print pertenece("platon", "humano"); #1 ???
print "\n";