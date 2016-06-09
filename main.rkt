#lang racket
(require "lib/digrafo.rkt")

(display "ATBD - Aplicacao para Testar Biblioteca de Digrafos\n")
(display "Arquivo para importar: ")

; Lê qual arquivo que será importado
(define arquivo (read-line (current-input-port) 'any))

; Define a classe para operações
(define digr (new digrafo%))

; Lê o arquivo de importação
(define digrafo-txt
  (with-handlers
      ([exn:fail?
        (lambda (exn)
          (displayln (exn-message exn))
          #f)])
    (file->lines arquivo #:mode 'text)))

(define nodos-txt (first digrafo-txt))
(define arestas-txt (list-tail digrafo-txt 2))

; Adiciona nodos de acordo com o arquivo de importação
(for ([i (string->number nodos-txt)])
  (send digr add-nodo i))

; Adiciona arestas
(for-each
 (lambda (aresta-t)
   (let ([l (string-split aresta-t " ")])
     (let ([a (string->number (first l))]
           [b (string->number (second l))]
           [c (string->number (last l))])
       (send digr add-aresta a b c ))))
 arestas-txt)

; Mostra informações sobre o grafo importado
(display "\n[INFORMACOES SOBRE O GRAFO] ")
(display "\nArestas: ")
(display (send digr n-arestas))
(display "\nNodos: ")
(display (send digr n-nodos))
(display "\nComponentes fortemente conexos: ")
(display (send digr kosaraju))

; Cálculo de distâncias
(display "\n\n[TABELA DE DISTANCIAS]")
(define calcular (lambda () (
(display "\nNodo origem: ")
(let ([nodo-origem (read-line (current-input-port) 'any)])
  (for-each
   (lambda (n)
     (display (car n))
     (display " -> ")
     (display (cdr n))
     (display "\n")) (send digr dijkstra (string->number nodo-origem))))
(read-line (current-input-port) 'any)
(calcular))))
(calcular)
