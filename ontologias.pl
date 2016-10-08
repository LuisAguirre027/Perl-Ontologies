#!/usr/bin/perl
use strict; use warnings;

#use Graph 'graph.pm';
#use Graph::Directed 'graph.pm';


use Graph;
use Graph::Directed;


#grafo de las ontologias#

my $ontograph = Graph::Directed->new();

#subrutinas#

sub crear_inexistentes {
	foreach my $v (@_){
		if (!$ontograph->has_vertex ($v)){
			$ontograph->add_vertex($v);
		}
	}
}
#crea los nodos si estos no existen

sub hecho{
	crear_inexistentes($_[0],$_[1]);
	$ontograph->set_edge_attribute($_[0],$_[1],"tipo",$_[2]);
}
#crea las distintas premisas

sub es{
	hecho($_[0],$_[1],"es");
}
#premisa "0 es 1"

sub tiene{
	hecho($_[0],$_[1],"tiene");
}
#premisa "0 tiene 1"

sub puede{
	hecho($_[0],$_[1],"puede");
}
#premisa "0 puede 1"

sub consulta_individual{
	if ($ontograph->is_reachable($_[0],$_[1])){
		
		# toma todos los vertices alcanzables desde la fuente y a si mismo
		my @vertices = $ontograph->all_reachable( $_[0] );
		push @vertices, $_[0];
		
		foreach my $v1 ( @vertices ){
			
			# itera todos los vecinos directos de cada vertice v1
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
# consulta el grafo

sub consulta_multiple_arriba{
	
	# toma todos los vertices alcanzables desde la fuente y a si mismo
	my @vertices = $ontograph->all_reachable( $_[0] );
	push @vertices, $_[0];
	
	my @return_array;
	
	foreach my $v1 ( @vertices ) {
		
		# itera todos los vecinos directos de cada vertice v1
		foreach my $v2 ( $ontograph->all_neighbours( $v1 ) ) {
			
			my $edge_attribute = $ontograph->get_edge_attribute($v1,$v2,"tipo") || "";
			if ( $edge_attribute eq $_[1] ){
				push @return_array, $v2;
			}
		}
		
	}
	
	@return_array;
}
# consulta todos los posibles hijos

sub consulta_multiple_abajo{
	
	my @vertices = $ontograph->unique_vertices;
	
	my @return_array;
	
	foreach my $v1 ( @vertices ) {
		
		if (consulta_individual $v1,$_[0],$_[1] ){
			push @return_array, $v1;
		}
		
	}
	@return_array;
}
# consulta todos los posibles padres


sub consulta{
	if (($_[0]) and ($_[1]))
	{return consulta_individual($_[0],$_[1],$_[2]);}
	elsif ($_[0])
	{return consulta_multiple_arriba($_[0],$_[2]);}
	else
	{return consulta_multiple_abajo($_[1],$_[2]);}
}
# subrutina publica de la consulta

sub pertenece{
	return consulta($_[0],$_[1],"es")
}
# consulta "0 pertenece a 1?"

sub posee{
	return consulta($_[0],$_[1],"tiene")
}
# consulta "0 posee 1?"

sub hace{
	return consulta($_[0],$_[1],"puede")
}
# consulta "0 hace 1?"

### programa ###

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  next if $row =~ /^\s*$/;
  my @var = split /[(,).\n]+/, $row;
  my $generic=$var[0];					#start a new scope to keep the effect of "no strict" small
  no strict 'refs';
  &$generic($var[1], $var[2]);	#llama a la función que entró por parametro
 }
 
print "\n---------GRAFO---------\n $ontograph \n-----------------------";

print "\n platon pertenece a: ";
print join ", ", pertenece("platon",undef); #ARRAY

print "\n pueden caminar erguidos: ";
print join ", ", hace(undef, "caminar_erguido"); #ARRAY

print "\n platon es humano? ";
print pertenece("platon", "humano"); #1


print "\n platon tiene ci? ";
print posee("platon", "ci");#1
print "\n";
