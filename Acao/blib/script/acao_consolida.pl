#!/usr/bin/perl

eval 'exec /usr/bin/perl  -S $0 ${1+"$@"}'
    if 0; # not running under some shell
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Acao;

close STDIN;
close STDOUT;

my $id_consolidacao = shift;
my $user = Catalyst::Authentication::User::Hash->new({ id => shift });

my $model = Acao::Model::ProcessoConsolidacao->new(
        user  => $user,
        dbic  => Acao->model('DB')->schema,
        sedna => Acao->model('Sedna')
);

$model->iniciar_consolidacao($id_consolidacao);

exit;
