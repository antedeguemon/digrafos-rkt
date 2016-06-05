#lang racket
(require "lib/digrafo.rkt")

(define digr (new digrafo%))
(define digrafo-txt (file->lines "grafo.txt" #:mode 'text))
(define nodos-txt (first digrafo-txt))
(define arestas-txt (list-tail digrafo-txt 2))

(for ([i (string->number nodos-txt)])
  (send digr add-nodo i))

(for-each
 (lambda (aresta-t)
   (let ([l (string-split aresta-t " ")])
     (let ([a (string->number (first l))]
           [b (string->number (second l))]
           [c (string->number (last l))])
       (send digr add-aresta a b c ))))
 arestas-txt)

(send digr dijkstra 0)