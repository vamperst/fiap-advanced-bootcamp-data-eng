# Desafio Técnico - Análise e Processamento de Dados com Apache Iceberg e AWS Athena

## Introdução

Este desafio técnico consolida todos os conhecimentos adquiridos nos laboratórios anteriores, aplicando-os em um cenário prático com dados reais de voos. Você demonstrará competência em todas as etapas do pipeline de dados usando Apache Iceberg e AWS Athena.

### Objetivos de Aprendizagem

Ao completar este desafio, você terá demonstrado capacidade de:
- Configurar infraestrutura de dados no AWS (S3, Glue, Athena)
- Implementar descoberta automática de esquemas com Glue Crawler
- Criar e otimizar tabelas Iceberg para performance
- Executar operações DML complexas (INSERT, UPDATE, ALTER)
- Aplicar técnicas de otimização de tabelas
- Documentar e entregar soluções técnicas completas

### Contexto do Dataset

O dataset de voos contém informações detalhadas sobre voos comerciais, incluindo:
- Informações de origem e destino
- Horários de partida e chegada
- Atrasos e cancelamentos
- Dados de companhias aéreas
- Métricas operacionais

**Fonte**: [Tablab - Sample Parquet Files](https://www.tablab.app/parquet/sample)

Para referência técnica, consulte:
- [Documentação do AWS Glue Crawler](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)
- [Guia de criação de tabelas Iceberg](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg-creating-tables.html)
- [Melhores práticas de otimização](https://docs.aws.amazon.com/prescriptive-guidance/latest/apache-iceberg-on-aws/best-practices-performance.html)

### Desafio

Construir uma solução de análise e processamento de dados utilizando **Apache Iceberg** e **Amazon Athena**, com foco em consultas otimizadas e o uso de funções para manipulação de dados. O desafio também abrange a conexão dos dois conjuntos de dados (Voos).

### Tarefas

#### 1. Preparação dos Dados
1. Faça o download do dataset de voos.
   1. [Voos - Flights 1m](https://www.tablab.app/parquet/sample)

**Dica**: O arquivo está em formato Parquet, otimizado para análise. Verifique a estrutura dos dados antes de prosseguir.

#### 2. Configuração da Infraestrutura AWS
2. O dataset deve ser armazenado no Amazon S3. Você pode criar um bucket específico para este desafio.

**Estrutura recomendada do bucket**:
```
s3://seu-bucket-nome/
├── raw-data/
│   └── flights/
│       └── flights-1m.parquet
├── processed-data/
│   └── iceberg-tables/
└── athena-results/
```

**Referência**: [Melhores práticas para S3](https://docs.aws.amazon.com/s3/latest/userguide/best-practices-design-patterns.html)

#### 3. Descoberta de Esquema
3. Utilize o Glue Crawler para criar as tabelas no AWS Glue Data Catalog e consequentemente no Athena.

**Configurações importantes do Crawler**:
- Configure o caminho S3 corretamente
- Defina um schedule apropriado (ou execute manualmente)
- Verifique as configurações de classificador para Parquet
- Confirme que o database de destino existe

**Referência**: [Configuração de Crawlers](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)

#### 4. Criação de Tabelas Iceberg
4. Crie uma tabela Iceberg para armazenar os dados de voos.
   1. Assim como nas instruções dadas durante a aula forneça as propriedades necessárias para a criação das tabelas.
      1. 'table_type'='iceberg'
      2. 'format'='PARQUET'
      3. 'write_compression'='zstd'

**Exemplo de estrutura**:
```sql
CREATE TABLE seu_database.flights_iceberg (
    -- Use os campos descobertos pelo Crawler
    -- Exemplo: flight_date, airline, origin, destination, etc.
)
LOCATION 's3://seu-bucket/processed-data/iceberg-tables/flights/'
TBLPROPERTIES (
  'table_type'='iceberg',
  'format'='PARQUET',
  'write_compression'='zstd'
);
```

**Referência**: [Propriedades de tabelas Iceberg](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg-creating-tables.html#querying-iceberg-table-properties)

#### 5. Migração de Dados
5. Faça o insert de todos os dados existentes nas tabelas criadas.

**Estratégia recomendada**:
- Use INSERT INTO ... SELECT para migrar dados
- Monitore o progresso da operação
- Verifique a integridade dos dados após a migração

#### 6. Evolução de Esquema
6. Para a tabela de voos, crie uma nova coluna chamada 'arrival_delay' que será a copia da coluna 'arr_delay' com o valor negativo.

**Passos detalhados**:
1. Adicione a nova coluna: `ALTER TABLE ... ADD COLUMNS`
2. Atualize os dados: `UPDATE ... SET arrival_delay = -arr_delay`
3. Verifique os resultados com consultas de validação

**Referência**: [Evolução de esquema no Iceberg](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg-managing-tables.html)

#### 7. Otimização
7. Otimize as partições da tabela de voos conforme feito em aula.

**Técnicas de otimização**:
- Execute `OPTIMIZE ... REWRITE DATA USING BIN_PACK`
- Considere particionamento por data se aplicável
- Monitore métricas antes e depois da otimização

**Referência**: [Comando OPTIMIZE](https://docs.aws.amazon.com/athena/latest/ug/optimize-statement.html)

### Entregável

#### Documentação Obrigatória

1. **Print do crawler do Glue** ter criado as tabelas no AWS Glue Data Catalog/Athena.
   - Capture a tela mostrando o crawler executado com sucesso
   - Inclua screenshot das tabelas criadas no Data Catalog

2. **SQL de criação das tabelas Iceberg**.
   - Comando CREATE TABLE completo com todas as propriedades
   - Comentários explicando escolhas de design

3. **SQL de inserção dos dados nas tabelas**.
   - Comando INSERT INTO utilizado para migrar dados
   - Estatísticas de registros processados

4. **SQL de atualização da tabela e dos dados na tabela de voos**.
   - Comando ALTER TABLE para adicionar coluna
   - Comando UPDATE para popular a nova coluna
   - Consultas de validação dos resultados

5. **SQL de otimização das partições da tabela de voos**.
   - Comando OPTIMIZE executado
   - Comparação de métricas antes/depois (número de arquivos, tamanho, etc.)

6. **Print da tabela de voos no Athena** após a atualização e otimização das partições.
   - Screenshot mostrando dados com a nova coluna
   - Evidência da otimização (consulta aos metadados $files)

#### Formato de Entrega

Monte um zip com os artefatos e façam o upload no portal da FIAP.

**Estrutura do arquivo ZIP**:
```
trabalho-final-iceberg/
├── screenshots/
│   ├── glue-crawler-success.png
│   ├── data-catalog-tables.png
│   ├── athena-final-table.png
│   └── optimization-results.png
├── sql-scripts/
│   ├── 01-create-table.sql
│   ├── 02-insert-data.sql
│   ├── 03-alter-table.sql
│   ├── 04-update-data.sql
│   ├── 05-optimize-table.sql
│   └── 06-validation-queries.sql
├── documentation/
│   └── README.md (explicação das escolhas técnicas)
└── results/
    └── performance-metrics.txt
```

### Dicas

#### Recursos de Apoio

1. **No inicio da aula foi apresentado como fazer o glue crawler**. Você pode voltar na gravação da aula no Teams.
   - Revise os conceitos de configuração de crawlers
   - Observe as melhores práticas apresentadas
   - **Referência**: [Guia do Glue Crawler](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html)

2. **Todos os comandos pedidos foram feitos durante os exercicios da aula**.
   - Consulte os laboratórios anteriores como referência
   - Adapte os comandos para o contexto do dataset de voos
   - **Referência**: Laboratórios 1, 2 e 3 deste repositório

3. **Aproveite o nome dos campos criados pelo crawler para criar a tabela Iceberg**.
   - Execute `DESCRIBE table_name` para ver a estrutura descoberta
   - Use os mesmos tipos de dados na tabela Iceberg
   - Mantenha consistência nos nomes das colunas

4. **A coluna 'arrival_delay' deve ser criada com o mesmo tipo da coluna 'arr_delay'**.
   - Verifique o tipo de dados da coluna original
   - Use `ALTER TABLE ... ADD COLUMNS (arrival_delay TIPO_CORRETO)`
   - **Referência**: [Evolução de esquema](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg-managing-tables.html)

#### Troubleshooting Comum

**Problemas frequentes e soluções**:

| Problema | Causa Provável | Solução |
|----------|----------------|---------|
| Crawler não encontra dados | Caminho S3 incorreto | Verifique o path e permissões |
| Tabela Iceberg não cria | Propriedades incorretas | Revise TBLPROPERTIES |
| INSERT falha | Tipos incompatíveis | Ajuste tipos de dados |
| UPDATE lento | Tabela não otimizada | Execute OPTIMIZE antes |

**Comandos úteis para debugging**:
```sql
-- Verificar estrutura da tabela
DESCRIBE table_name;

-- Verificar arquivos da tabela Iceberg
SELECT * FROM "database"."table$files";

-- Verificar histórico de operações
SELECT * FROM "database"."table$history";
```

#### Critérios de Avaliação

**Aspectos avaliados**:
- ✅ **Completude**: Todos os entregáveis foram fornecidos
- ✅ **Correção técnica**: Comandos SQL funcionam corretamente
- ✅ **Boas práticas**: Uso adequado de propriedades e otimizações
- ✅ **Documentação**: Screenshots e explicações claras
- ✅ **Organização**: Estrutura lógica dos arquivos entregues

**Dica final**: Teste todos os comandos antes de entregar e documente qualquer decisão técnica tomada durante o desenvolvimento.

**Recursos adicionais**:
- [Apache Iceberg Documentation](https://iceberg.apache.org/docs/latest/)
- [AWS Prescriptive Guidance - Iceberg](https://docs.aws.amazon.com/prescriptive-guidance/latest/apache-iceberg-on-aws/)
- [Athena Best Practices](https://docs.aws.amazon.com/athena/latest/ug/best-practices.html)    