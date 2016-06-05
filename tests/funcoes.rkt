#lang racket
(require test-engine/racket-tests)
(require "../lib/digrafo.rkt")

; Teste de integridade nas funções da classe digrafo

(define digr1 (new digrafo%))

; Tenta pegar um nodo com alias não existente no grafo
(check-error (send digr1 get-node 66))


(test)