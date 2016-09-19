#!/usr/bin/perl
use strict; use warnings;

use Graph;
use Graph::Undirected;
use Graph::Directed;


my $graph = Graph::Directed->new();

sub crear_inexistentes {
	foreach my $v (@_){
		if (!$graph->has_vertex ($v)){
			$graph->add_vertex($v);
		}
	}
}

sub hecho{
	crear_inexistentes($_[0],$_[1]);
	$graph->set_edge_attribute($_[0],$_[1],"tipo",$_[2]);
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
	if ($graph->is_reachable($_[0],$_[1])){
		foreach my $v1 ($graph->vertices){
			foreach my $v2 ($graph->vertices){

				if ( ( $graph->get_edge_attribute($v1,$v2,"tipo") ~~ $_[2]) #smart match
				and  ($graph->is_reachable($_[0],$v1))
				and  ($graph->is_reachable($v2,$_[1])) ){

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

es("luis","tecnico");
es("tecnico","profesional");
puede("profesional","ejercer");

print "$graph\n\n";

print hace("luis", "ejercer"); #0
print "\n";
