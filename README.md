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

Esses algoritmos requerem funções extras de manipulação e extração de outras informações necessárias.

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
