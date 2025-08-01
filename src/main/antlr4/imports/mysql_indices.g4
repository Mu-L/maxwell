grammar mysql_indices;

import mysql_literal_tokens, mysql_idents;

if_not_exists:
  IF NOT EXISTS;

index_definition:
  (index_type_1 | index_type_pk | index_type_3 | index_type_4 | index_type_5 | index_type_check);

index_type_1:
  index_or_key exists_or_not? if_not_exists? index_name? index_type? index_column_list index_options*;

index_type_pk:
  index_constraint? PRIMARY KEY if_not_exists? (index_type | index_name)* index_column_list index_options*;

index_type_3:
  index_constraint? UNIQUE if_not_exists? index_or_key? index_name? index_type? index_column_list index_options*;

index_type_4:
  (FULLTEXT | SPATIAL) index_or_key? if_not_exists? index_name? index_column_list index_options*;

index_type_5:
  index_constraint? FOREIGN KEY exists_or_not? if_not_exists? index_name? index_column_list reference_definition;


index_type_check:
  index_constraint? CHECK skip_parens;

index_or_key: (INDEX|KEY);
index_constraint: (CONSTRAINT exists_or_not? constraint_name?);
constraint_name: name | ( name '.' name );

index_name: name;
index_type: USING (BTREE | HASH);
index_options:
  ( KEY_BLOCK_SIZE '=' INTEGER_LITERAL )
  | index_type
  | WITH PARSER name
  | COMMENT string_literal
  | ( VISIBLE | INVISIBLE )
  ;

index_column_list: '(' index_columns ')';
index_columns: index_column (',' index_column )*;

index_column:
  name index_column_partial_def? index_column_asc_or_desc?
  | skip_parens index_column_asc_or_desc?;


index_column_partial_def: '(' index_column_partial_length ')';
index_column_partial_length: INTEGER_LITERAL+;
index_column_asc_or_desc: ASC | DESC;

reference_definition:
  REFERENCES table_name
  index_column_list
  (reference_definition_match | reference_definition_on_delete | reference_definition_on_update)*
  ;

reference_definition_match:
  (MATCH FULL | MATCH PARTIAL | MATCH SIMPLE)
  ;

reference_definition_on_delete:
  ON DELETE reference_option;

reference_definition_on_update:
  ON UPDATE reference_option;

reference_option:
  (RESTRICT | CASCADE | SET NULL | NO ACTION);

exists_or_not: IF NOT? EXISTS;
