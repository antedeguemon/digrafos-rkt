#lang racket
;
; Módulo que provê a classe dígrafo e estruturas necessárias para
; o seu funcionamento.
; Tem como objetivo prover operações e algoritmos aplicados à grafos
; com arestas bidirecionais.
;
; Funções presentes:
; - Bellman: algoritmo de Bellman-Ford, para cálculo da distância de
; cada nodo do digrafo com relação a um outro nodo, denominado origem,
; podendo ter arestas com pesos negativos.
; - Dijkstra: algoritmo de Dijkstra, para cálculo da distância de cada
; nodo do digrafo com relação a um nodo origem, sendo necessariamente
; todos os pesos das arestas com peso positivo ou zero.
; - Kosaraju: algoritmo de Kosaraju, para identificação de componentes
; fortemente conexos em um digrafo.
;
; Autor:  Vicente Merlo (vammerlo@inf.ufrgs.br)
;         Bruno Bastiani (bmbastiani@inf.ufrgs.br)
; Data:   02/06/2016
;
; Observações:
; - Nesta documentação, vértices são chamados de nodos.
; - O nome dado aos identificadores únicos de cada nodo é "alias".
;
(provide digrafo%)

; Guarda um digrafo e seus componentes, sendo este definido por:
; G(V, E), sendo V os vértices (nodos) e E as arestas.
; A estrutura digrafo é definida por:
; lista-nodos:   lista de estruturas do tipo nodo
; lista-arestas: lista de estruturas do tipo aresta
(define-struct digrafo
  ([lista-nodos #:mutable]
   [lista-arestas #:mutable]))

; Um nodo é definido por:
; alias: (simbolo|escalar|string|*) identificador do nodo, deve ser
;        único e seu tipo compatível com a função eq.
(define-struct nodo (alias))

; Uma aresta é uma estrutura definida por:
; nodo-a: estrutura do tipo nodo
; nodo-b: estrutura do tipo nodo
; peso:   número qualquer
(define-struct aresta (nodo-a nodo-b peso))

; Classe que define operações sobre um dígrafo.
(define digrafo%
  (class object%
    (super-new)

    ; lista-de-distância:
    ; Algumas funções dessa classe retornam listas de distâncias.
    ; Uma lista de distância é definida como uma lista de pares associados
    ; à distância de um nodo com relação a outro.
    ; Os pares são do tipo: (alias, distância), sendo alias o alias de um
    ; nodo e distância um número que representa a distância entre o seu
    ; respectivo nodo e o nodo origem.
    ; O número pode ser infinito, no caso de não existir conexão entre os
    ; nodos.

    ; Estrutura que armazena o digrafo sendo manipulado.
    (define d (make-digrafo empty empty))

    ; Retorna uma lista com todos os nodos do digrafo que está armazenado
    ; em d.
    ;
    ; Exemplo: (get-nodos)
    ;
    ; Saída: lista de nodos
    (define/private (get-nodos)
      (digrafo-lista-nodos d))

    ; Retorna uma lista com todas as arestas do digrafo que está armazenado
    ; em d.
    ;
    ; Exemplo: (get-arestas)
    ;
    ; Saída: lista de arestas
    (define/private (get-arestas)
      (digrafo-lista-arestas d))

    ; Retorna a estrutura nodo associada ao alias definido,
    ; que se encontra dentro do digrafo. Caso não existe,
    ; retorna #f.
    ;
    ; Exemplo: (get-nodo 0)
    ;
    ; Saída: estrutura nodo ou falso
    (define/public (get-nodo alias)
      (get-nodo-internal alias (get-nodos)))

    ; get-nodos interno
    (define/private (get-nodo-internal alias nodos)
      (cond
        [(empty? nodos) #f]
        [(eqv? alias (nodo-alias (first nodos))) (first nodos)]
        [else (get-nodo-internal alias (rest nodos))]))

    ; Adiciona um nodo a lista de nodos do digrafo d.
    ;
    ; Exemplo: (add-nodo 0)
    ;          Adiciona ao digrafo um nodo com alias 0.
    ;
    ; Saída: void
    (define/public (add-nodo alias)     
      (set-digrafo-lista-nodos! d (append (list (make-nodo alias)) (get-nodos))))

    ; Adiciona uma aresta entre dois nodos usando aliases identificadores como
    ; referências.
    ;
    ; Parâmetros:
    ; alias-a: alias de um nodo origem
    ; alias-b: alias de um nodo ao qual a aresta incidirá
    ; peso:    número representando o peso da aresta
    ;
    ; Exemplo: (add-aresta 0 1 5)
    ;          Cria uma aresta entre o nodo a e o nodo b com peso 5.
    ;
    ; Saída: void
    (define/public (add-aresta alias-a alias-b peso)
      (let ([nodo-a (get-nodo alias-a)]
             [nodo-b (get-nodo alias-b)])        
        (cond
          [(or (false? nodo-a) (false? nodo-b)) (error "nodo_invalido")]
          [else (set-digrafo-lista-arestas! d (append
                                               (list (make-aresta nodo-a nodo-b peso))
                                               (get-arestas)))])))

    ; Retorna o número de nodos do digrafo.
    ; É obtido através da função get-nodos.
    ;
    ; Exemplo: (n-nodos) 
    ;
    ; Saída: número
    (define/public (n-nodos)
      (length (get-nodos)))
    
    ; Retorna o número de arestas do digrafo
    ; É obtido através da função get-arestas.
    ;
    ; Exemplo: (n-arestas)
    ;
    ; Saída: número
    (define/public (n-arestas)
      (length (get-arestas)))

    ; Retorna lista com identificados de nodos adjacentes ao nodo com alias dado.
    ; Caso o parâmetro inv seja especificado como verdadeiro, retorna incidentes.
    ;
    ; Parâmetros:
    ; alias: alias identificador do nodo
    ; rev:   booleano que define se deverá retornar arestas inc ou adj
    ;
    ; Exemplo: (adj 0)
    ;          Retorna uma lista com nodos adjancetes ao nodo 0.
    ;
    ; Saída: lista de aliases
    (define/public (adj alias [rev #f])
      (let ([nodo (get-nodo alias)])
        (filter-map
         (lambda (aresta)
           (cond [(and (false? rev)
                       (eq? (aresta-nodo-a aresta) nodo))
                  (nodo-alias (aresta-nodo-b aresta))]
                 [(and (eqv? rev #t)
                       (eq? (aresta-nodo-b aresta) nodo))
                  (nodo-alias (aresta-nodo-a aresta))]
                 [else #f])) (get-arestas))))
  
    ; DFS com callbacks em pontos e possibilidade de aplicação no
    ; complemento do grafo.
    ;
    ; Parâmetros:
    ; visitados: lista de aliases de nodos (não é uma lista de nodos!)
    ; comeco:    função para callback no começo
    ; meio:      função para callback no meio
    ; fim:       função para callback no fim
    ;
    ; Exemplo: (dfs 0)
    ;          Executará o dfs no nodo com alias 0. Não chamará funções de callback.
    ;
    ; Saída:     void
    (define/public (dfs nodo
                        #:visitados [visitados empty]
                        #:comeco [comeco empty]
                        #:meio [meio empty]
                        #:fim [fim empty]
                        #:rev [rev #f])
      (and (if (not (empty? comeco)) (comeco nodo) #t)
           (for-each
            (lambda (nodo-adj)
              (if (false? (member nodo-adj visitados))
                  (and (if (not (empty? meio)) (meio nodo) #t)
                       (dfs nodo-adj #:visitados (append (list nodo) visitados) #:comeco comeco #:meio meio #:fim fim #:rev rev))
                  #t))
            (adj nodo rev))
           (if (not (empty? fim)) (fim nodo) #t)))

    ; Usa a função DFS para retornar a ordem reversa do DFS nas arestas
    ; incidentes. É utilizada pelo algoritmo de Kosaraju.
    ; Não possui entrada pois atua diretamente no digrafo sendo manipulado
    ; pela classe.
    ;
    ; Saída: lista de aliases de nodos
    (define/public (rpos)
      (let ([pos empty]
            [vis empty])
        (for-each (lambda (nodo)
           (if (false? (member (nodo-alias nodo) vis))
               (dfs (nodo-alias nodo)
                #:fim (lambda (n)
                        (set! pos (append (list n) pos)))
                #:comeco (lambda (n)
                           (set! vis (append (list n) vis)))
                #:rev #t) #t)) (get-nodos))
        pos))

    ; Algoritmo de Kosaraju para encontrar componentes fortemente conexos.
    ; Não possui parâmetros de entrada pois atua diretamente no digrafo sendo
    ; manipulado pela classe.
    ;
    ; Saída: lista de componentes parcialmente conexos, com aliases de nodos
    (define/public (kosaraju-b)
      (let ([mar empty]
            [co 0]
            [componentes empty])
        (for-each
         (lambda (nodo)
           (if (false? (member nodo mar))
               (and
                (dfs nodo
                     #:comeco (lambda (n) (set! mar (append (list n) mar))) #:rev #f)
                (set! co (+ co 1))
                (set! componentes (append componentes (list mar))))
               #f))
         (rpos))
        componentes))

    ; Filtro para verificar as conexões entre nodos dos componentes parciais
    ;
    ; Parâmetros:
    ; parcial:     lista com componentes parciais (nodos não necessariamente fortemente conexos)
    ; usadas:      lista com nodos já conexos
    ; componentes: lista de componentes que tiveram sua conexão verificada,
    ;              com nodos apenas parcialmente conexos removidos.
    ;
    ; Saída:       lista com alises de nodos
   (define (kosaraju-c parcial usadas componentes)
     (cond [(empty? parcial) componentes]
        [else (let ([visitamos (filter-map (lambda (n) (if (false? (member n usadas)) n #f)) (first parcial) )])                
                 (kosaraju-c (rest parcial) (append usadas visitamos) (append (list (remove-duplicates visitamos)) componentes)))]))

    ; Função holder para o algoritmo de Kosaraju
    ; 
    ; Saída: lista de componentes fortemente conexos, sendo que cada lista possui aliases de nodos
    (define/public (kosaraju)
      (kosaraju-c (kosaraju-b) empty empty))

    ; Algoritmo de Bellman para encontrar caminho mínimo com pesos inteiros.
    ; NÃO UTILIZADO!
    ;
    ; Parâmetros:
    ; origem: alias de um nodo
    ;
    ; Saída: lista de distâncias (definida no cabeçalho)
    (define/public (bellman origem)
      (let ([nodos (get-nodos)])
        (let
            ([dist (map
                    (lambda (n)
                      (cons (nodo-alias n)
                            (if (eq? (nodo-alias n) origem) 0 +inf.0)))
                    nodos)])
          (for-each (lambda (n)
             (for-each (lambda (a)
                         (let ([dist-a (dist-nodo (nodo-alias (aresta-nodo-a a)) dist)])
                           (cond [(and (< dist-a +inf.0)
                            (<
                             (+ dist-a (aresta-peso a))
                             (dist-nodo (nodo-alias (aresta-nodo-b a)) dist)))
                                  (set! dist (dist-atualiza (nodo-alias (aresta-nodo-b a)) (+ dist-a (aresta-peso a)) dist))]
                      [else #t])))
            (get-arestas)))
         (rest nodos))
          dist)))

    ; Atualiza a distância de um nodo numa lista de distâncias.
    ;
    ; Parâmetros:
    ; alias: alias do nodo que terá a distância modificada
    ; peso:  nova distância que será colocada do nodo
    ; dist:  lista-de-distâncias
    ;
    ; Saída: lista-de-distâncias
    (define/public (dist-atualiza alias peso dist)
      (map
       (lambda (n)
         (if (eq? (car n) alias) (cons (car n) peso) n)) dist))

    ; Retorna a distância do nodo na lista de distancias
    ;
    ; Parâmetros:
    ; alias: alias do nodo que está sendo buscado
    ; dist:  lista-de-distâncias
    ;
    ; Saída: número
    (define/public (dist-nodo alias dist)
      (car (filter-map
       (lambda (n)
         (if (eq? (car n) alias) (cdr n) #f)) dist)))
    
    ; Retorna o menor nodo de uma lista de alises de nodos associada a uma
    ; lista-de-distâncias.
    ;
    ; Parâmetros:
    ; dist:     lista-de-distâncias
    ; q:        lista com aliases de nodos
    ; min-nodo: menor nodo relativo, usado para recursão
    ;
    ; Saída: par (alias, distância) da lista-de-distância dada
    (define/public (dist-min-q dist q [min-nodo (cons (first q) +inf.0)]) ; talvez de merda aqui
      (cond [(empty? dist) min-nodo]
            [else (dist-min-q
                  (rest dist)
                  q
                  (if (and (< (cdr (first dist)) (cdr min-nodo))
                            (not (false? (member (car (first dist)) q)))) (first dist) min-nodo)
            ) ]))

    ; Algoritmo de Dijkstra para menor rota com pesos >= 0
    ;
    ; Parâmetros:
    ; origem: alias do nodo de origem
    ;
    ; Saída: lista-de-distâncias
    (define/public (dijkstra origem)
      (let ([dist (map (lambda (n)
               (cons (nodo-alias n)
                     (if (eq? (nodo-alias n) origem) 0 +inf.0)))
             (get-nodos))]
            [q (map (lambda (n) (nodo-alias n)) (get-nodos))]) ; nodos não visitados
        (for ([i (length q)])
        (let ([u (dist-min-q dist q)])
          (set! q (q-rm (car u) q))
          (for-each
           (lambda (v) ; quando usar u, usar cdr
             (let
                 ([alt (+ (cdr u) (peso (car u) v))])
               (if
                (< alt (dist-nodo v dist))
                (set! dist (dist-atualiza v alt dist))
                #t)))
           (adj (car u))))) dist))

    ; Remove um alias de uma lista de aliases.
    ;
    ; Parâmetros:
    ; nodo: alias de um nodo
    ; q:    lista de aliases
    ;
    ; Saída: lista de aliases
    (define/public (q-rm nodo q)
      (filter-map
       (lambda (n)
         (if (eq? n nodo) #f n)) q))

    ; Retorna o peso da aresta que liga u a v
    ;
    ; Parâmetros:
    ; u: alias de um nodo
    ; v: alias de um nodo
    ;
    ; Saída: número finito ou não, no caso de não haver arestas ligando
    ;        os dois nodos, ou algum dos nodos não existir.
    (define/public (peso u v)
      (let ([p (filter-map
       (lambda (aresta)
         (if (and (eq? (nodo-alias (aresta-nodo-a aresta)) u)
                  (eq? (nodo-alias (aresta-nodo-b aresta)) v))
             (aresta-peso aresta)
             #f)) (get-arestas))])
        (if (empty? p) +inf.0 (first p))))    
    ))
