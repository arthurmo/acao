package Acao::Plugins::VilaDoMar::DimSchema::Result::DEnderecoImovel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Acao::Plugins::VilaDoMar::DimSchema::Result::DEnderecoImovel

=cut

__PACKAGE__->table("d_endereco_imovel");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'd_endereco_id_seq'

=head2 logradouro

  data_type: 'character'
  is_nullable: 1
  size: 20

=head2 numero

  data_type: 'character'
  is_nullable: 1
  size: 20

=head2 complemento

  data_type: 'character'
  is_nullable: 1
  size: 20

=head2 bairro

  data_type: 'character'
  is_nullable: 1
  size: 20

=head2 telefone

  data_type: 'character'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    #sequence          => "d_endereco_id_seq",
  },
  "logradouro",
  { data_type => "varchar", is_nullable => 1 },
  "numero",
  { data_type => "varchar", is_nullable => 1 },
  "complemento",
  { data_type => "varchar", is_nullable => 1 },
  "bairro",
  { data_type => "varchar", is_nullable => 1 },
  "telefone",
  { data_type => "varchar", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-06-02 10:22:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SY0C0884y3qR8hjFrBcsbg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
