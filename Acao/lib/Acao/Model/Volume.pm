package Acao::Model::Volume;
# Copyright 2010 - Prefeitura Municipal de Fortaleza
#
# Este arquivo é parte do programa Ação - Sistema de Acompanhamento de
# Projetos Sociais
#
# O Ação é um software livre; você pode redistribui-lo e/ou modifica-lo
# dentro dos termos da Licença Pública Geral GNU como publicada pela
# Fundação do Software Livre (FSF); na versão 2 da Licença.
#
# Este programa é distribuido na esperança que possa ser util, mas SEM
# NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO a qualquer
# MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença Pública Geral GNU
# para maiores detalhes.
#
# Você deve ter recebido uma cópia da Licença Pública Geral GNU, sob o
# título "LICENCA.txt", junto com este programa, se não, escreva para a
# Fundação do Software Livre(FSF) Inc., 51 Franklin St, Fifth Floor,
use Moose;
extends 'Acao::Model';
use Acao::ModelUtil;
use XML::LibXML;
use XML::Compile::Schema;
use XML::Compile::Util;
use DateTime;
use Encode;
use Data::UUID;

use constant VOLUME_NS =>'http://schemas.fortaleza.ce.gov.br/acao/volume.xsd';

my $controle = XML::Compile::Schema->new( Acao->path_to('schemas/volume.xsd') );
my $controle_w = $controle->compile( WRITER => pack_type( VOLUME_NS, 'volume' ), use_default_namespace => 1 );

=head1 NAME

Acao::Model::GestorVolume - Implementa as regras de negócio do papel gestorvolume

=head1 DESCRIPTION

Essa classe implementa as regras de negócio específicas para o papel
de gestorvolume.

=head1 METHODS

=over

=item listar_volumes()

Retorna os volumes os quais o usuário autenticado tem acesso.

=cut

txn_method 'listar_volumes' => authorized 'gestorvolume' => sub {
    my $self = shift;

    # sera dentro de uma transacao, e so pode ser usado por gestores de volumes
    return $self->dbic->resultset('Volume')->search(
        { 'gestor_volumes.dn' => $self->user->id },
        {
	        join => 'gestor_volumes',
        }
    );
};

=item criar_volume($nome, $estado, $representaVolumeFisico, $classificacao, $localizacao ,$ip)

=cut

txn_method 'criar_volume' => authorized 'gestorvolume' => sub {
    my ( $self, $nome, $estado, $representaVolumeFisico, $classificacao, $localizacao, $role ,$ip ) = @_;

    my $ug  = new Data::UUID;
    my $uuid = $ug->create();

    my $doc_name = 'volume-'. $uuid;

    my $acao;
    my $dados;
    my $dataIni;
    my $dataFim;

#    $self->sedna->execute('declare namespace cd = "http://schemas.fortaleza.ce.gov.br/acao/volume.xsd"; for $x in doc("volume.xsd") return $x');
#    my $xsd = $self->sedna->get_item;
#    my $octets = encode('utf8', $xsd);

#    my $x_c_s    = XML::Compile::Schema->new($octets);
#    my @elements = $x_c_s->elements;

#    my $read = $x_c_s->compile( READER => $elements[0] );
#    my $writ = $x_c_s->compile( WRITER => $elements[0], use_default_namespace => 1 );
    
    my $doc = XML::LibXML::Document->new( '1.0', 'UTF-8' );

    my $res_xml = $controle_w->($doc,
                                {
                                    volume => {
                                        nome       => $nome,
                                        criacao    => DateTime->now(),
                                        fechamento => '',
                                        arquivamento => '',
                                        collection => $doc_name,
                                        estado => 'aberto',
                                        representaVolumeFisico => $representaVolumeFisico,,
                                        classificacao => $classificacao,
                                        localizacao => $localizacao,
                                        autorizacao => {
                                                        principal => $self->user->id,
                                                        role => $role,
                                                        dataIni => $dataIni,
                                                        dataFim => $dataFim,
                                                        },
                                        auditoria => {
                                                        data => DateTime->now(),
                                                        usuario => $self->user->id,
                                                        acao => $acao,
                                                        ip => $ip,
                                                        dados => $dados,
                                                        },
                                    },
        }
    );

#    $self->sedna->conn->loadData( $res_xml->toString, $doc_name, 'volume' );
    $self->sedna->conn->endLoadData();
};

=head1 COPYRIGHT AND LICENSING

Copyright 2010 - Prefeitura de Fortaleza. Este software é licenciado
sob a GPL versão 2.

=cut

42;