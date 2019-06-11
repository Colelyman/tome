#lang racket/base

(require gregor
         racket/string
         racket/list
         pollen/decode
         pollen/core
         pollen/setup
         pollen/misc/tutorial
         "pollen-local/tags.rkt")

(provide (all-defined-out)
         (all-from-out "pollen-local/tags.rkt"))

(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html pdf))

  (require racket/runtime-path
           syntax/modresolve)
  (define-runtime-path pollen-local/tags.rkt "pollen-local/tags.rkt")
  (define cache-watchlist
    '(pollen-local/tags.rkt)))

(define default-author "Cole A. Lyman")

(define (pretty-date d)
  (parameterize ([current-locale "en"])
    (~t d "EEEE, MMMM d, y")))

(define (get-current-date)
  (pretty-date (today)))

(define (prettify-date-html date-string)
  date-string)

(define (published-date metas)
  (let ([d (iso8601->date (select-from-metas 'published metas))])
    (pretty-date d)))

(define (get-author metas)
  (let ([author (select-from-metas 'author metas)])
    (cond
      [author author]
      [else default-author])))

;; Inspired by https://github.com/otherjoel/thenotepad/commit/d35f0d40d2d1ce9e1f41086c69fe9fa6183af803
(define (decode-semantic-line-wrapping xs)
  (decode-paragraphs xs
                     #:linebreak-proc (lambda (xs)
                                        (decode-linebreaks xs " "))))

(define (root . elements)
  (case (current-poly-target)
    [(html) `(root ,@(decode-elements elements
                                      #:txexpr-elements-proc decode-semantic-line-wrapping
                                      #:string-proc (compose1 smart-quotes smart-dashes)))]
    [(txt) `(root ,@(decode-elements elements
                                     #:string-proc (compose1 smart-quotes smart-dashes)))]
    [else `(root ,@elements)]))
