### digrafos-rkt
Biblioteca em Racket para manipulação de grafos direcionais com pesos. 

Apresentada na disciplina de Teoria dos Grafos (INF05512) do professor Rodrigo Machado na UFRGS.

#### Classe
A classe digrafos tem como objetivo fornecer funções sob um dígrafo para o cálculo de distância entre nodos e para o cálculo do número de elementos fortemente conexos.
Para essas funções, utilizamos os algoritmos:
* [Dijkstra](https://pt.wikipedia.org/wiki/Algoritmo_de_Dijkstra): algoritmo de Dijkstra, para cálculo da distância de cada
nodo do digrafo com relação a um nodo origem, sendo necessariamente
todos os pesos das arestas com peso positivo ou zero.
* [Kosaraju](https://en.wikipedia.org/wiki/Kosaraju%27s_algorithm): algoritmo de Kosaraju, para identificação de componentes fortemente conexos em um digrafo. 
Utilizamos a implementação descrita por Sedgewick no livro [Algorithms](https://books.google.fi/books?id=idUdqdDXqnAC&hl=pt-BR).
* [Bellman-Ford](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm): algoritmo de Bellman-Ford, para cálculo da distância de cada nodo do digrafo com relação a um outro nodo, denominado origem, podendo ter arestas com pesos negativos. ** Algoritmo implementado, mas não utilizado.**

Esses algoritmos requerem funções extras de manipulação e extração de outras informações necessárias, que também são oferecidas pela classe. 

### Programa Exemplo
O arquivo main.rkt é um programa para testar a biblioteca digrafos-rkt. Ele lê um arquivo no formato:
```
número de nodos
número de arestas
nodo_a nodo_b peso
nodo_b nodo_c peso
```
Por exemplo, o seguinte arquivo:
```
2
2
0 1 0.5
1 0 1
```
Produziria as seguintes operações na classe de digrafos:
```
(add-nodo 0)
(add-nodo 1)
(add-aresta 0 1 0.5)
(add-aresta 1 0 1)
```
Após produzir o dígrafo, o programa aplica as operações de cálculo de distâncias para um nodo perguntado e cálculo do número de arestas, nodos e componetnes fortemente conexos.

#### Funções
A descrição e modo de uso de cada função está presente em suas declarações no arquivo digrafos.rkt. Abaixo, há uma lista com todas as funções da classe:
* (get-nodos)
* (get-arestas)
* (get-nodo alias)
* (get-nodo-internal alias nodos)
* (add-nodo alias)
* (add-aresta alias-a alias-b peso)
* (n-nodos)
* (n-arestas)
* (adj alias)
* (dfs nodo)
* (rpos)
* (kosaraju)
* (bellman origem)
* (dist-atualiza alias peso dist)
* (dist-nodo alias dist)
* (dist-min dist)
* (dist-min-q dist q)
* (dijkstra origem)
* (q-rm nodo q)
* (peso u v)
