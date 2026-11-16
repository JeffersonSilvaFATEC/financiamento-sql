## Índices e desempenho

EXPLAIN SELECT * FROM clientes where agencia = '3270';

O EXPLAIN antes do SELECT mostra o plano que o BD usou para a consulta.
O INDEX auxilia na leitura mais filtrada de dados no banco, tirando a necessidade de fazer a leitura de todas as linhas (mais otimizado)

Nesta primeira busca, antes do indice estar criado, mostra que o banco leu toda a tabela (linha por linha) para encontrar a agencia 3270.
Key e possible_keys estavam vazias pois ainda não tinha sido criado nenhum índice para a busca.

| Índice | Coluna | Aceita repetição? | Para que serve |
| --- | --- | --- | --- |
| PRIMARY | id | Não | Identifica cada cliente |
| idx_cpf | cpf | Não | Impede CPF repetido e acelera a busca por CPF |
| parceiro_id | parceiro_id | Sim | Criado junto com a chave estrangeira; liga o cliente ao parceiro |
| idx_clientes_agencia | agencia | Sim | Acelera a busca por agência |


CREATE INDEX idx_clientes_agencia ON clientes (agencia);

Após criar o INDEX, o type do EXPLAIN virou REF e a key virou idx_clientes_agencia e a leitura foi somente em 10 linhas

Antes do índice, o banco fazia a consulta em todas as 29 linhas da tabela (type = ALL). Depois de criar o 'idx_clientes_agencia', ele estimou ler cerca de 10 linhas, indo diretamente Às linhas daquela agência pelo índice ('type = ref').


| Busca | type | key | rows | Extra | Leitura |
| --- | --- | --- | --- | --- | --- |
| Por agência, sem índice | ALL | - | 29 | Using where | Leu a tabela inteira, linha por linha |
| Por agência, com `idx_clientes_agencia` | ref | idx_clientes_agencia | 10 (estimado) | Using index condition | Foi pelo índice; `rows` é uma estimativa do banco |
| Por CPF (índice `UNIQUE`) | const | idx_cpf | 1 | - | Melhor caso: índice único garante no máximo 1 linha |


A busca por CPF foi a mais eficiente ('type = const') pois ele tem um valor único por cliente('UNIQUE'). Já na agência, o mesmo valor se repete em vários clientes, então o banco precisa ler todas as linhas com aquela agência ('type = ref').
Como a tabela só possui 29 linhas, ler a tabela toda é rápido. O ganho do índice aparece de verdade em tabelas grandes, onde ler todas as linhas a cada consulta leva muito mais tempo.





