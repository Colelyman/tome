#lang racket/base

(require pollen/setup
         racket/string
         racket/list)

(provide (all-defined-out))

(define (text->id text)
  (string-downcase (string-replace text " " "-")))

(define (h1  elements)
  (let ([id (string-downcase (string-replace elements " " "-"))])
    (case (current-poly-target)
     [(tex pdf) (apply string-append `("\\section{" ,elements "}\\label{sec:" ,id "}"))]
     [(txt) (string-upcase (apply string-append `(,elements "\n")))]
     [else `(h2 [[id ,id]] ,elements)])))

(define (h2  elements)
  (let ([id (string-downcase (string-replace elements " " "-"))])
    (case (current-poly-target)
     [(tex pdf) (apply string-append `("\\subsection{" ,elements "}\\label{sec:" ,id "}"))]
     [(txt) (apply string-append `(,elements "\n"))]
     [else `(h3 [[id ,id]] ,elements)])))

(define (link url . elements)
  (let* ([link-text (if (empty? elements)
                        '(url)
                        elements)])
    (case (current-poly-target)
      [(tex pdf) (apply string-append `("\\href{" ,url "}{" ,@link-text "}"))]
      [(txt) (apply string-append `(,@link-text "(" ,url ")"))]
      [else `(a [[href ,url]] ,@link-text)])))

(define (code #:block [block #f] . elements)
  (case (current-poly-target)
    [(tex pdf) (string-append* `("\\texttt{" ,@elements "}"))]
    [(txt) (string-append* `("`" ,@elements "`"))]
    [else (if block
              `(pre [[class "code"]] ,@elements)
              `(code ,@elements))]))

(define (xref #:target [target #f] #:prefx [prefix "sec"] text)
  (let ([target (if (not target)
                    (text->id text)
                    target)])
    (case (current-poly-target)
      [(tex pdf) (apply string-append `("\\nameref{" ,prefix ":" ,target "}"))]
      [(txt) (apply string-append `(,text "(see " ,target ")"))]
      [else `(a [[href ,(string-append "/#" target)]] ,text)])))

(define num-notes 0)

(define (note #:expanded [expanded #t] . elements)
  (let* ([note-number (+ 1 num-notes)]
         [note-id (format "sn-~a" note-number)])
    (set! num-notes note-number)
    (case (current-poly-target)
      [(tex pdf) (string-append* `("\\footnote{" ,@elements "}"))]
      [(html) `(@
                (label [[class "margin-toggle sidenote-number"] [for ,note-id]])
                (input [[class "margin-toggle"] [type "checkbox"] [id ,note-id]])
                (span [[class "sidenote"]] ,@elements))]
      [else (string-append* `("Note: " ,@elements))])))

(define (section . elements)
  (let* ([element-words (string-split (car elements))]
         [first-3-words (string-join (take element-words 3))]
         [rest-elements `(,(string-join #:before-first " " #:after-last " " (drop element-words 3)) . ,(cdr elements))])
    (case (current-poly-target)
     [(tex pdf) (string-append* `("\\newthought{" ,first-3-words "}" ,@rest-elements))]
     [(html) `(section (span [[class "newthought"]] ,first-3-words) ,@rest-elements)]
     [else (string-append* elements)])))
