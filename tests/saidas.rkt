#lang racket
(require test-engine/racket-tests)
(require "../lib/digrafo.rkt")

; Conjunto de testes para verificar a funcionalidade das operações da
; classe de digrafos.

; Cria um grafo:
; +---+        +---+
; | 0 | -10--> | 1 |
; +---+ <--10- +---+
;
; Esse grafo tem 1 componente fortemente conexo.
; As distâncias entre seus elementos, começando do nodo 1, deve ser:
; 0: 10
; 1: 0
;
(define digr1 (new digrafo%))
(send digr1 add-nodo 0)
(send digr1 add-nodo 1)
(send digr1 add-aresta 0 1 10)
(send digr1 add-aresta 1 0 10)
(check-expect (send digr1 kosaraju) 1)
(check-expect (send digr1 dijkstra 0) (list (cons 1 10) (cons 0 0)))
(check-expect (send digr1 bellman 0) (list (cons 1 10) (cons 0 0)))
(test)

; Cria um novo grafo:
;
;  +---+           +---+
;  | 0 +-----2---->+ 2 +<---1--+         +---+
;  +---+           +---+       |    +--->+ 6 |
;    |               1         |    1    +---+
;    |               v       +---+  |      |
;    |             +---+     |   +--+      |
;    1             | 3 +--1->+ 5 |         2                
;    |             +---+     |   +<-+      |
;    |               1       +---+  |      v
;    v               v         ^    |    +---+
;  +---+           +---+       |    +-1--+ 7 |
;  | 1 +----1----->+ 4 +---2---+         +---+
;  +---+           +---+                      
;
(define digr2 (new digrafo%))
(send digr2 add-nodo 0)
(send digr2 add-nodo 1)
(send digr2 add-nodo 2)
(send digr2 add-nodo 3)
(send digr2 add-nodo 4)
(send digr2 add-nodo 5)
(send digr2 add-nodo 6)
(send digr2 add-nodo 7)
(send digr2 add-aresta 0 1 1)
(send digr2 add-aresta 1 4 1)
(send digr2 add-aresta 3 4 1)
(send digr2 add-aresta 0 2 2)
(send digr2 add-aresta 2 3 1)
(send digr2 add-aresta 3 5 1)
(send digr2 add-aresta 4 5 2)
(send digr2 add-aresta 5 2 1)
(send digr2 add-aresta 5 6 1)
(send digr2 add-aresta 6 7 2)
(send digr2 add-aresta 7 5 1)
(check-expect (send digr2 dijkstra 0) '((7 . 7) (6 . 5) (5 . 4) (4 . 2) (3 . 3) (2 . 2) (1 . 1) (0 . 0)))
(check-expect (send digr2 dijkstra 0) (send digr2 bellman 0))
(check-expect (send digr2 n-nodos) 8)
(check-expect (send digr2 n-arestas) 11)
(check-expect (send digr2 kosaraju) 2)
(test)