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



## Relatório de financiamento com pandas

Script em Python (`relatorio_cca.py`) lê a tabela `clientes` do banco MySQL `CCA` e gera relatórios de financiamento em um arquivo Excel, com uma aba por relatório.

### O que o script faz

- Lê a tabela `clientes` do MySQL e a carrega em um DataFrame (`df`), uma estrutura de dados do pandas com linhas, colunas e índice.
- Calcula três relatórios com pandas:
  1. Valor financiado por programa e agência.
  2. Valor financiado por faixa de valor (até 200 mil, de 200 a 400 mil e acima de 400 mil).
  3. Prazo médio da vistoria, em dias, por credenciado.
- Grava os três relatórios em `relatorio_cca.xlsx`, cada um em uma aba.

### Bibliotecas

- **pandas:** lê os dados, agrupa e calcula os relatórios, e cria as abas do Excel.
- **SQLAlchemy:** cria a conexão com o banco, com o `create_engine`. A conexão usa o usuário `root` do XAMPP, que por padrão tem senha vazia, e o banco `CCA`.
- **PyMySQL:** driver que o SQLAlchemy usa por baixo para se comunicar com o MySQL.
- **openpyxl:** biblioteca que o pandas usa para gravar o arquivo `.xlsx`.

### Como rodar

1. Deixe o MySQL ligado (XAMPP) e o banco `CCA` criado.
2. Instale as bibliotecas: `pip install pandas sqlalchemy pymysql openpyxl`
3. Se o seu MySQL tiver senha, ajuste a conexão no início do script.
4. Execute: `python relatorio_cca.py`
5. Feche o Excel antes de rodar de novo, senão o arquivo fica bloqueado para gravação.

### Observações

- Os dados do projeto são fictícios.
- O arquivo `relatorio_cca.xlsx` não é enviado ao GitHub (está no `.gitignore`).



