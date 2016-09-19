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

				if ( 
					($graph->is_reachable($_[0],$v1))
				and ($graph->is_reachable($v2,$_[1])) 
				and ( $graph->get_edge_attribute($v1,$v2,"tipo") ~~ $_[2]) #smart match
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

es("platon","humano");
es("humano","persona natural");
es("persona natural","persona legal");
es("persona juridica","persona legal");
es("humano","bipedo");
es("bipedo","mamifero");

tiene("persona legal","derechos");
tiene("persona legal","deberes");
tiene("persona juridica","rif");
tiene("persona natural","ci");

puede("mamifero","lactar");
puede("bipedo","caminar erguido");
puede("humano","razonar");



print "\n---------GRAFO---------\n$graph\n-----------------------\n";

print pertenece("platon", "persona legal"); #1
print "\n";

print pertenece("platon", "persona juridica"); #0
print "\n";