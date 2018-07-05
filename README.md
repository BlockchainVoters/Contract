# Contract

Esta é a documentação do contrato inteligente por trás da eleição. Esta versão, em português, será traduzida posteriormente

## Recursos

- [X] Criação de uma Eleição / Definição de Prazos
- [X] Cancelamento da Eleição
- [X] Inserção / Exclusão de Candidatos
- [X] Inscrição de Eleitores / Verificação de Inscrição
- [X] Voto Verificável
- [X] Acesso Seguro aos Votos
- [X] Privacidade de Informações

## Contato

- Se você tiver alguma dúvida sobre o uso, mande-nos um [e-mail](mailto:isaiahlima18@gmail.com)
- Caso deseje modificar ou utilizar o código-fonte, clone este repositório em sua máquina (ele é 100% aberto)

## Funções

Abaixo, um descritivo de como cada função deste contrato pode ser utilizada:

### Construtor

```
constructor(uint256 _insertLimit, uint256 _joinLimit, uint256 _voteLimit)
```

Este método inicializa o contrato e o atrela à conta que o criou, que será considerada como o administrador da eleição.

> Este administrador terá o poder de adicionar e deletar candidatos do pleito, podendo também cancelar o processo.

O parâmetro `_insertLimit` representa o prazo, em segundos contados desde a criação da eleição, para a inserção de candidatos.
O parâmetro `_joinLimit` representa o prazo, em segundos contados desde a criação da eleição, para a inscrição de eleitores.
O parâmetro `_voteLimit` representa o prazo, em segundos contados desde a criação da eleição, para os eleitores votarem.

### Encerramento (Admin)

```
function shut_down()
```

Este método permite ao administrador encerrar o processo eleitoral, que ficará restrito à leitura de dados.

### Inserção de Candidatos (Admin)

```
function insert_candidate(string name, uint8 number, string party, string vice)
```

Este método permite ao administrador inserir candidatos no processo eleitoral, dados os prazos. Caso alguém já tenha votado, ele não poderá inserir mais candidatos.

O parâmetro `name` representa o nome do candidato a ser inserido.
O parâmetro `number` representa o número da chapa do candidato, e deve ser **único**.
O parâmetro `party` representa o partido do candidato.
O parâmetro `vice` representa o nome do vice do candidato.

### Exclusão de Candidatos (Admin)

```
function delete_candidate(uint8 number)
```

Este método permite ao administrador excluir algum candidato inserido (não há como editar, é melhor excluir e adicionar novamente).

O parâmetro `number` representa o número da chapa do candidato.

### Inscrição de Eleitor (Público)

```
function join_voter() public
```

Este método permite que qualquer conta externa, exceto a do administrador, se inscreva como eleitor. 

> Num contexto real, este método deveria ser restrito ao administrador, para evitar *outsiders*.

### Voto (Público)

```
function vote(uint8 number, string __hash)
```

Este método permite a eleitores inscritos que votem em um dos candidatos cadastrados.

> Cada eleitor pode votar apenas uma vez
> O parâmetro `__hash` deve ser único e sua definição fica a critério do cliente. Recomendamos solicitar ao eleitor uma palavra-passe que será criptografada com a chave privada da conta, para que esta seja a `__hash`

O parâmetro `number` representa o número da chapa do candidato.
O parâmetro `__hash` representa a chave única a ser usada para verificar o voto posteriormente.

### Funções de Leitura (Público)

```
function get_candidates() public view returns (uint8[])
```

Este método retorna uma lista dos números de chapa de candidatos cadastrados na eleição.

```
function get_appuration(uint8 candidate) public view returns (uint256)
```

Este método retorna a apuração de votos por candidatos.

```
function get_candidate(uint8 number) public view returns (string, uint8, string, string)
```

Este método retorna, dado o número de chapa `number`, os dados completos do candidato cadastrado.

```
function has_joined() public view returns (bool)
```

Este método confirma se a conta está cadastrada como um eleitor.

```
function has_voted() public view returns (bool)
```

Este método confirma se a conta cadastrada já votou na eleição.

```
function get_votes() public view returns (uint8[])
```

Este método retorna uma lista dos números de chapa dos votos, permitindo a apuração.

```
function check_vote(string __hash) public view returns (uint8)
```

Este método, inserida a `__hash` única da conta, retorna o voto realizado por ela.

> Se a `__hash` for esquecida, o voto não poderá ser verificado

